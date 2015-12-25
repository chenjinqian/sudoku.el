;; This is a game to guess four different random number in ten times, you will
;; be told how  much number you are right each time.
;; Copyright (C) 1999-2013 Free Software Foundation, Inc.

;;;;;;;;;;;;;;;;;;;;;; Code here, you should evalue the code first ;;;;;;;;;;;;;
;; How to evalue the expression?
;; This game is write in emacs-lisp, you'd better open it with emacs. To evalue
;; one expression you should put the cursor at the end of the expression 
;; and press Ctrl-x Ctrl-e

(defun newgame (num)
  (defun normalanswer (num)
    "If the answer have repeated number, regenerate one"
    (if (repeatp (makeanswer num))
	(normalanswer num)
      (message "%s number answer ready" num)))
  (defun repeatp (lst)
    "To test if one simple list have repeated numbers"
    (if (null lst)
	nil
      (if (ninlstp (car lst) (cdr lst))
	  t
	(repeatp (cdr lst)))))
  (defun makeanswer (num)
    (setq answer (gen num)))
  (defun gen (num)
    (defun genacc (acc nu)
      (if (>= nu num)
	  acc
	(genacc (cons (random 10) acc) (+ 1 nu))))
    (genacc nil 0))
  (defun ninlstp (nu lst)
    "To test if one number is menber of one list"
    (if (null lst)
	nil
      (if (eq nu (car lst))
	  t
	(ninlstp nu (cdr lst)))))
  (defun enter (list)
    "To check one guess with the answer, give the amount of right number&position 
   and the amount of right number without right position."
    (defun nandp (list answer a)
      (if (null list)
	  a
	(if (eq (car list) (car answer))
	    (nandp (cdr list) (cdr answer) (+ 1 a))
	  (nandp (cdr list) (cdr answer) a))))
    (defun position (list b)
      (if (null list)
	  b
	(if (ninlstp (car list) answer)
	    (position (cdr list) (+ 1 b))
	  (position (cdr list) b))))
    (list 'number&position (nandp list answer 0)
	  'number  (- (position list 0) (nandp list answer 0))))
  (normalanswer num))

;; function end here.
;;;;;;;;;;;;;;;;;;;;;;Test functions here;;;;;;;;;;;;;;;;;
(newgame 4.5)
(makeanswer 4)
(normalanswer 4)
(random 4)
answer
(ninlstp (random 3) '(1 2))
(normalanswer 4)
(repeatp '(1 2 3 4))
(repeatp '(1 2 3 3))
(ninlstp 1 '(1 2 3 4))

;;;;;;;;;;;;;;;;;;;;;;;;;;; Answer and play here ;;;;;;;;;;;;;;;;;;;;
;; also some example here. This programe is still simple,
;; one should record the result after.
;; envalue next expression to reset the answer, the next to see the answer, the 
;; next to enter a guess and you will get a result from the message zone.
(newgame 4)
answer
(enter '(3 7 5 9)) 

(enter '(1 2 4 6)) (0 2)
(enter '(0 3 7 8)) (0 1)
(enter '(1 2 5 9)) (0 1)
(enter '(5 9 4 6)) (0 1)
(enter '(4 1 3 7)) (3 0)
(enter '(4 1 3 3)) (3 1)
(enter '(4 1 3 1)) (4 0) the right answer

(enter '(1 2 3 4)) (0 0)
(enter '(5 6 7 8)) (0 2)
(enter '(2 1 6 5)) (0 0)
(enter '(7 8 0 3)) (3 0)
(enter '(7 8 4 3)) (3 0)
(enter '(7 8 9 3)) (4 0)
;;right answer is (7 8 9 3) in this example.

(enter '(1 2 3 4)) (0 2)
(enter '(5 6 7 8)) (0 1)
(enter '(0 1 2 9)) (1 2)
(enter '(0 9 5 6)) (0 1)
(enter '(0 7 1 2)) (0 2)
(enter '(2 8 9 1)) (2 2)
(enter '(2 9 8 1)) (1 3)
(enter '(8 1 9 2)) (0 4)
(enter '(9 8 2 1)) (4 0)

