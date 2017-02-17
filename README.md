# **Black Box: Assembled** #

The *Black Box: Assembled* is a version of the classic [*Black Box Game*](https://en.wikipedia.org/wiki/Black_Box_(game)) created with the Assembly language for the processors Intel 8086. It runs completely by command line and keyboard on the prompt/terminal. 

## **Playing** ##

When first starting the game the user is asked to give a scenario file. This file contains the information about the game matrix. Some scenarios already exist, however one can also create its own scenario by typing down a 8x8 matrix of 1's and 0's (more informations below).

*Black Box: Assembled* follows the same basic rules of the original *Black Box Game*. It simulates the shooting of rays inside a black box to guess where a set of *atoms* is located. The player has to guess where all the atoms are based on the output given by the box when a ray is shot from a certain position in the edge of the box. Inside the box there is a 8x8 matrix which cells may, or may not contain an atom. When a ray is shot, it interacts with atoms in its way and may be deflected or absorbed by atoms. The interaction is given as follows:

* If a ray hits straight to an atom, the ray is absorbed by the atom, and the box has no output;
* If an atom is found in any diagonal of the rays path, it deflects the ray to the opposite side. For example, if the ray is going up and an atom is located at its left, the ray will be deflected to the right;
* If no atom is found, the ray will go by a straight line to the other side of the box.

Based on these interactions, and observing where each rays comes out of the box, the user must guess the position of each atom inside. The smaller the number of rays used, the smaller the final score (smaller scores are better).

### Creating my own scenarios ###

To create one's own scenario, the user can create a plain text file and type down a 8x8 matrix of 1's and 0's, following the same pattern of the existing scenarios (with no blank spaces, and one new line after each row). Number 1 indicates that the position contains an atom, and number 0 indicates a free position.

## **Running** ##

Because this game was implemented in a older version of the Intel's set of instructions and memory organization, one has to emulate the processors of the 8086 era. To do so, one can use DOSBox. Also, one has to compile the source code in Assembly to generate an executable file. The complete guide is given below, it works for both Linux and Windows:

1. Install DOSBox
     * Available for download [here](http://www.dosbox.com/) (http://www.dosbox.com/);
     * For Ubuntu users, it is available in the Software Center;


2. After DOSBox is installed, run it. All the following commands should be executed in the DOSBox, not in you OS terminal;

3. The default directory of DOSBox is Z: (the prompt should be showing Z:\> ). We need to mount the directory containing the *Black Box: Assembled* (referred as dir_bb, and should be a valid path in your OS). Type the following command: 
	
```
#!shell

Z:\> mount c dir_bb
```
For example, my path in Linux is: ~/bba/

4. Now, go to the new C:/ directory in DOSBox by typing
```
#!shell

Z:\> C:
```

5. Once in the mounted C:\, we will compile the source code. Run the compiler TASM to compile bba_final:
```
#!shell

C:\> TASM.exe bba_final.asm
```

6. A file bba_final.OBJ will be generated, and like when compiling C files, one should link it, by running TLINK
```
#!shell

C:\> TLINK.exe bba_final.OBJ
```

7. Finally, a file bba_final.exe should be created in the directory. Now one can run it by
```
#!shell

C:\> bba_final.exe
```

8. Enjoy :)

## **About** ##

Done for the "INF01108 - Computers' Architecture and Organization I", 2012, at UFRGS.