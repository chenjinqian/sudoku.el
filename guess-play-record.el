;;This is the play record of me and my brother.

(newgame 4)
(makeanswer 4)
(normalanswer 4)
;;(random 4)
;;;;;;;;;;;;;;;;;;;;
(defun newrandom (a lst)
  (if (ninlstp (random a) lst)
      ))

(defun gen (num)
  (defun genacc (acc nu)
    (if (eq nu num)
	acc
      (genacc (cons (random 10) acc) (+ 1 nu))))
  (genacc nil 0))
;(ninlstp (random 3) '(1 2))
(defun makeanswer (num)
  (setq answer (gen num)))

(defun repeatp (lst)
  (if (null lst)
      nil
    (if (ninlstp (car lst) (cdr lst))
	t
      (repeatp (cdr lst)))))
;test (repeatp '(1 2 3 4))
(defun normalanswer (num)
  (if (repeatp (makeanswer num))
      (normalanswer num)
    (message "%s number answer ready" num)))
;;test  (normalanswer 4)
(defun newgame (num)
  (normalanswer num))
;;(newgame 4)
(defun ninlstp (nu lst)
  (if (null lst)
      nil
    (if (eq nu (car lst))
	t
      (ninlstp nu (cdr lst)))))
;;test (ninlstp 1 '(1 2 3 4))

(defun enter (list)
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

(defmacro ent (fi se th fo)
  `(enter ','(fi se th fo)))
(defmacro ent (fi se th fo)
  `(list ',(list fi se th fo)))
(ent 2 8 0 3)
(ent 1)
(defmacro  tei (else)
  `)

 ;something else
;(let ((zebra 'stripes)      (tiger 'fierce))  (message "One kind of the animal is %s and another is %s" zebra tiger))
;;;;;;;;;;;;;;;;;;;;
answer
(newgame 4)

(enter '(0 1 2 3)) 0 1
(enter '(4 5 6 7)) 1 1
(enter '(4 8 3 6)) 0 3
(enter '(8 3 6 5)) 2 0
(enter '(8 4 6 2)) 4 0

(enter '(0 1 2 3)) 0 1
(enter '(4 5 6 7)) 0 2
(enter '(1 2 5 6)) 1 0
(enter '(3 7 8 4)) 0 2
(enter '(1 9 4 7)) 0 2
(enter '(9 3 7 6)) 2 2
(enter '(7 3 9 6))4 0

(enter '(0 1 2 3)) 1 0
(enter '(4 5 6 7)) 1 1
(enter '(1 7 8 5)) 1 0
(enter '(9 2 3 6)) 0 2
(enter '(0 9 6 5)) 4 0



(enter '(0 1 2 3)) 0 1
(enter '(4 0 5 6)) 0 1
(enter '(7 8 0 9)) 0 2
(enter '(1 4  8 9)) 0 2
(enter '(2 5 7 8)) 2 1
(enter '(8 6 5 7)) 0 2
(enter '(2 7 4 8)) 4 0


(enter '(0 1 2 3)) 0 2
(enter '(4 0 5 6)) 0 2
(enter '(7 8 0 9)) 0 2
(enter '(1 4 7 2)) 1 0
(enter '(3 5 6 8)) 1 1
(enter '(1 6 8 9)) 1 0
(enter '(3 6 7 0)) 2 0
(enter '(3 4 8 0))

(enter '(8 5 4 7)) 
(enter '(9 4 0 7)) 
(enter '(8 9 0 4))

(enter '(0 1 2 3)) 0 1
(enter '(4 0 5 6)) 0 2
(enter '(7 8 0 9)) 1 2
(enter '(5 6 9 0)) 0 2
(enter '(8 5 4 7)) 1 1
(enter '(9 4 0 7)) 1 2
(enter '(8 9 0 4))

(enter '(0 1 2 3)) 0 2
(enter '(4 0 5 6)) 1 0
(enter '(7 8 0 9)) 0 1
(enter '(4 1 2 7)) 0 1
(enter '(3 5 1 8)) 2 0
(enter '(3 9 1 6)) 4 0


(enter '(1 9 8 7)) 0 4
(enter '(8 9 1 7)) 0 4
(enter '(9 8 7 1)) 4 0

(enter '(4 0 5 6)) 0 1
(enter '(7 8 0 9)) 0 3
(enter '(8 7 1 0)) 1 2
(enter '(9 1 7 0)) 1 2
(enter '(1 9 8 0)) 4 0

(enter '(4 5 6 7)) 0 1
(enter '(0 1 8 9)) 0 3
(enter '(8 9 4 5)) 2 1
(enter '(8 9 1 5)) 1 2
(enter '(1 9 4 8)) 4 0

(enter '(1 4 9 5)) 0 0
(enter '(2 0 6 8)) 0 2
(enter '(7 8 0 3)) 4 0

(enter '(3 6 8 9)) 2 1
(enter '(3 6 9 7)) 1 1
(enter '(6 3 0 9)) 1 1
(enter '(1 6 3 9)) 2 1
(enter '(2 6 8 9)) 2 1
(enter '(8 6 4 9)) 3 0
(enter '(8 6 5 9)) 3 0
(enter '(8 6 1 9)) 4 0


(1 0)
(enter '(5 6 7 8))

(enter '(1 2 4 6)) (0 2)
(enter '(0 3 7 8)) (0 1)
(enter '(1 2 5 9)) (0 1)
(enter '(5 9 4 6)) (0 1)
(enter '(4 1 3 7)) (3 0)
(enter '(4 1 3 3)) (3 1)
(enter '(9 0 4 8)) (4 0) the right answer

"you should have a plan the earlier the better, but if you want to success, 
you need a plan and not too much time. Even the mistake you make is on
porpuls."

answer

(setq ans (gen 4))

(gen 3)

"how to write a function to interact with one person in the text zone?"
