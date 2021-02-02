B='/'
import os,sys
C=os.getcwd().replace('/home/ubuntu','~')
A=C.split(B)
if len(A)>3:sys.exit(f"../{B.join(A[-3:])}")
else:sys.exit(B.join(A))
