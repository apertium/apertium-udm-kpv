import sys
import xml.etree.ElementTree as ET

doc = open(sys.argv[1]).read()
root = ET.fromstring(doc)

#<e>
#   <lg>
#     <l pos="N">асъя</l>
#     <stg> <st/>
#     </stg>
#   </lg>
#   <mg>
#     <tg xml:lang="udm">
#       <t pos="N">ӵукнянь</t>
#     </tg>
#   </mg>
#</e>
count = 0
pos = sys.argv[2]
for elem in root.findall('.//e'):
	left = elem.findall('.//l')[0]
	right = elem.findall('.//t')
	for t in right:
		bad = 0
		bad += left.text.count(' ') + t.text.count(' ')
		if bad == 0:
			print('<e><p><l>%s<s n="%s"/></l><r>%s<s n="%s"/></r></p></e>' % (left.text, pos, t.text, pos));

	count += 1


