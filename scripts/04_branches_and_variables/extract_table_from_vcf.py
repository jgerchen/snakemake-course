import argparse
parser=argparse.ArgumentParser()
parser.add_argument("-v", "--vcf", help="input VCF file")
parser.add_argument("-o", "--output", help="output table")

args=parser.parse_args()
input_vcf=args.vcf
output=args.output

with open(input_vcf) as VCF:
    for line in VCF:
        if line[0]=="#":
            if line[1]!="#":
                ind_cats=line.strip().split("\t")[9:]
                break
with open(output, "w") as out_file:
    for ind_cat in ind_cats:
        out_file.write("%s\t%s\t%s\n" % (ind_cat, ind_cat.split(":")[0], "2"))
