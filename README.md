Author: ChenJinQian
Email: 2012chenjinqian@gmail
This is a program write in emacs-lisp, I want to solve a number game, named sudoku. Basicly you are given some numbers, and you need to fill up the rest to make 81 numbers, under certain rools.
This is a game I played in high school, at first it's a lot of fun, but as I prectise more, I find I have to do a lot of repeated works of search. And I wander how much skills it is needed to solve any sudoku problems. Cause some one are very easy, you just need to perform some basic skills, and the answer shows up enventuly.  But sometimes you need advance skills, such as drawer principle(drawer number must equal to number of things in it) to constraint the possibilities.
After I finish the fist version of this program, I solved almost every sudoku problems I have ever meet with it. Untill one day, some one give me an extramly difficult one, I run the program, it get stucked. Then I know the skills I have find is not enough. It seems I have to assume some case, and prove that it will lead to errors latter, and go back exclude that case. This process can be nested, making it more complicated. I tried in this version 2, but not success.
Latter, I find some one solve it with python, and SAT. see  https://github.com/ContinuumIO/pycosat.git
But still, it is fun to work on this problem. If you are interested, or have some advise, contact me.

v2 can solve most sudoku problems, v3 try to solve everything, but not yet.
