

1. Install DOSBOX;
2. Run DOSBOX;
3. Mount the directory containing the BB_Final.asm file (referred as dir_bb here):
	mount c ~/dir_bb

4. Go to the new C:/ directory in DOSBOX by typing
	C:
5. run the compiler TASM to compile BB_Final:
	TASM.exe BB_Final.asm
6. A file BB_final.OBJ will be generated, and like with C files, one should link it
	TLINK.exe BB_Final.OBJ
7. A file BB_Final.exe should appear in the directory. Now one can run it by
	BB_Final.exe
8. Enjoy :)