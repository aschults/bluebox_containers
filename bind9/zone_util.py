import dns.zone
import dns.name
import dns.rdata
import dns.rdatatype
import dns.reversename
import sys
import os
import os.path


def setup_serial(zone):
  serial=0
  fn=os.environ.get("ZONE_UTIL_SERIAL_FILE") or "/var/bind/serial.txt"

  if os.path.isfile(fn):
    fh=open(fn,'r')
    serial=int(fh.readline())
    fh.close()

  soa=zone.find_rdataset(zone.origin,'SOA')[0]
  serial+=1
  soa.serial=serial

  fh=open(fn,'w')
  fh.write(str(serial) +"\n")
  fh.close()

  return zone

def reverse_zone(z,domain_out):
  """ Generate reverse lookup entries (IP -> FQDN) for a zone file
      Retains the SOA file
  """
  z2=dns.zone.Zone(dns.name.from_text(domain_out))
  z2.replace_rdataset("@",z.find_rdataset(z.origin,'SOA'))
  z2.replace_rdataset(domain_out,z.find_rdataset(z.origin,'NS'))

  for k,o in z.items():
    for e in o:
      if e.rdtype != dns.rdatatype.A:
	continue
      for a in e.items:
	r=dns.reversename.from_address(a.address)
	#n2=z2.find_node(dns.name.from_text(r),create=True)
	n2=z2.find_node(r,create=True)
	ds2=n2.find_rdataset(dns.rdataclass.IN, dns.rdatatype.PTR,create=True)
	r2=dns.rdata.from_text(dns.rdataclass.IN, dns.rdatatype.PTR,k.to_text())
	ds2.add(r2)

  return z2

def main(argv):
  file_in=sys.stdin
  file_out=sys.stdout
  if len(argv)<1:
    cmd=None
  else:
    cmd=argv[0]


  if cmd=='serial':
    if len(argv)!=2:
      print >>sys.stderr, "Usage: serial <in_doman>"
      sys.exit(1)

    domain_in=argv[1] #'test-domain.nowhere.'
    z=dns.zone.from_file(sys.stdin,domain_in,relativize=False)
    z=setup_serial(z)

  elif cmd=='reverse':
    if len(argv)!=3:
      print >>sys.stderr, "Usage: reverse <in_doman> <out_domain>"
      sys.exit(1)

    domain_in=argv[1] #'test-domain.nowhere.'
    domain_out=argv[2] #'168.192.in-addr.arpa.'
    z=dns.zone.from_file(sys.stdin,domain_in,relativize=False)
    z=reverse_zone(z,domain_out)
    z=setup_serial(z)
  else:
    print >>sys.stderr, "Usage: sub commands available: serial, reverse"
    sys.exit(1)


  z.to_file(sys.stdout)
     


if __name__ == "__main__":
  if len(sys.argv )<2:
    main([None])
  else:
    main(sys.argv[1:])
