;;; sudoku.el --- do the saku search

;; Copyright (C) 1999-2013 Free Software Foundation, Inc.

;; Author: Jinqian Chen  <2012chenjinqian@gmail.com>
;; Maintainer: none
;; Keywords: games lisp sudoku

;; This file is part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.


;;   :::|:::|:::
;;   ```|```|```
;;   ,,,|,,,|,,,
;;   `::|:::|:::

;;   :::|:::|:::
;;   ```|```|```


;; There is 81 cell, and most of them have 9 possibility, some is pre-defined.Every cell related to the defined(or solved) cell reduce some possibility and is solved when there is only one possible. The way every cell related to the anothers is extensible and well defined.

;; lists (((1 2 3 1) (1 2 3 4 5 6 7 8 9)) ...)which is the (3 4)th of the 9x9 table, for easy use later. The possibility is in the followed list.

;; init example

;;(setq lists nil)

;;(pushs '( ((2 1) 2) ((2 2) 7) ((2 6) 1) ((2 9) 5) ((3 1) 3) ((3 2) 5) ((3 4) 4) ((3 5) 7) ((4 1) 4) ((4 2) 1) ((4 5) 5) ((4 7) 2) ((4 9) 8) ((6 1) 8) ((6 3) 5) ((6 5) 3) ((6 8) 9) ((6 9) 4) ((7 3) 8) ((7 5) 6) ((7 6) 3) ((7 8) 4) ((7 9) 1) ((8 1) 1) ((8 4) 8) ((8 8) 5) ((8 9) 9) ((9 2) 9)))

;; usage example

;; (cels '((1 2) (2 3)))
;; (chec '(5 5))
;; (checs (not-sur))
;; (np (sur))
;; (hard-way)

;;"methoed, as tested, weak-way is faster for some
;;situation, but hard way can solve more with multy-
;;run" "str-way is no use, seems one have to 
;;do the (chec (sur)) first"

(setq lists nil)

(pushs '( ((1 1) 8) ((2 3) 3) ((2 4) 6) ((3 2) 7) ((3 5) 9) ((3 7) 2) ((4 2) 5) ((4 6) 7) ((5 5) 4) ((5 6) 5) ((5 7) 7) ((6 4) 1) ((6 8) 3) ((7 3) 1) ((7 8) 6) ((7 9) 8) ((8 3) 8) ((8 4) 5) ((8 8) 1) ((9 2) 9) ((9 7) 4) ))

(weak-way)

(hard-way)

(mix-way)

(print lists)

(str-way)
(hard-way1)
lists
(rep '(8 7) '(2))

(cel '(8 7))

(cels (al))
(sur)
(al)
(sure (al))
(cel '(3 7))
(np (sur))
(cels (quit-sur 3))
(see-cels (quit-sur 3))

(empt)

;; "to be"

(defun mix-way ()
  (weak-way)
  (if (eq (np (sur)) 
	  (and (np (hard-way))
	       (np (sur))))
      (show 0)
    (mix-way)))

(defun weak-way ()
  (defun wea-acc (p1 p2)
    (checs (dif p2 p1))
    (if (equal p2 p1)
	(show 0)
      (wea-acc p2 (sur))))
(wea-acc nil (sur)))

(defun hard-way ()
  (defun har-acc (p1 p2)   
    (checs p1)
    (if (equal p1 p2)
	(show 0)
      (har-acc (not-sur) p1)))
  (har-acc (not-sur) nil))

(defun hard-way1 ()
  (defun har-acc (p1 p2)
    (checs p2)
    (if (equal p1 (not-sur))
	(show 0)
      (har-acc p2 (not-sur))))
  (checs (sur))
  (har-acc (not-sur) (not-sur)))

(defun str-way ()
  (defun str-acc (p1)
    (checs p1)
    (if (equal p1 (not-sur))
	(show 0)
      (str-acc (not-sur))))
  (str-acc (not-sur)))


;; "functions needed" "chec need to be rewrited for upgrade"

;;code:
(defun push (lst)
  (rep (car lst) (cdr lst)))

(defun pushs (lst)
  (if (null lst)
      lists
    (and (push (car lst))
	 (pushs (cdr lst)))))

(defun form (lst)
  (defun form-rown (n lst1)
    (defun rncm (n m lst2)
      (cons '(n m) (car lst2))
      (rncm n (- m 1) (cdr lst2)))
    (rncm n 0 (car lst1))
    ))

(defun np (ls)
  (defun n-acc (lst acc)
    (if (null lst)
	acc
      (n-acc (cdr lst) (+ 1 acc))))
  (n-acc ls 0))

(defun al ()
  (defun all (a b acc)
    (if (and (equal a 9) (equal b 9))
	(cons (list a b) acc)
      (if (equal b 9)
	  (all (+ 1 a) 1 (cons (list a b) acc))
	(all a (+ 1 b) (cons (list a b) acc)))))
  (mrev (all 1 1 nil)))

(defun simp (lst)
  (and (not (atom lst)) 
       (atom (car lst)) 
       (null (cdr lst)) 
       (not (equal lst nil)))) 

(defun nsimp (n lst)
  (if (equal n 1)
      (simp lst)
    (and (simp (list (car lst)))
	 (nsimp (- n 1) (cdr lst)))))

(defun elenum (lst)
  (defun ele-acc (lst acc)
    (if (null lst)
	acc
      (ele-acc (cdr lst) (+ 1 acc))))
  (ele-acc lst 0))

(defun sure (lst)
  (if (null lst)
      nil
      (if (simp (cel (car lst)))
	  (cons (car lst) (sure (cdr lst)))
	(sure (cdr lst)))))

(defun sur ()
  (sure (al)))

(defun quit-sure (n lst)
    (if (null lst)
      nil
      (if (nsimp n (cel (car lst)))
	  (cons (car lst) (quit-sure n (cdr lst)))
	(quit-sure n (cdr lst)))))

(defun quit-sur (n)
  (quit-sure n (al)))

(defun empt ()
  (defun empty (lst)
    (if (null lst)
	nil
      (if (null (cel (car lst)))
	  (cons (car lst) (empty (cdr lst)))
	(empty (cdr lst)))))
  (empty (al)))

(defun not-sur ()
  (dif (al) (sur)))

(defun dif (lsta lstb)
  (if (null lstb)
      lsta
    (dif (rm-ele lsta (car lstb))
	 (cdr lstb))))

(defun difs (a b)
  (if (null b)
      a
    (difs (dif a (car b))
	  (cdr b))))

(defun same (lsa lsb)
  (dif lsa (dif lsa lsb)))

(defun show (n)
  (defun replace (lst ela elb)
    (if (null lst)
	nil
      (if (equal (car lst) ela)
	  (cons elb (replace (cdr lst) ela elb))
	(cons (car lst) (replace (cdr lst) ela elb)))))
  (if (equal n 0)
      (replace (cels (al)) '(1 2 3 4 5 6 7 8 9) '(all))
    (cels (sur))))

(defun cel (pla)
  (defun cell (lst list) 
    (if (null list)
	'(1 2 3 4 5 6 7 8 9)
	(if (equal lst (caar list))
	    (cdar list)
	  (cell lst (cdr list)))))
  (if (null pla)
      nil
    (cell pla lists)))

(defun cels (lst)
  (if (null lst)
      nil
    (cons (cel (car lst))
	  (cels (cdr lst)))))

(defun see-cels (lst)
    (if (null lst)
      nil
    (cons (cons (car lst) (cel (car lst)))
	  (see-cels (cdr lst)))))

(defun rm-ele (lst ele)
  (if (null lst)
      nil
    (if (equal (car lst) ele)
	(rm-ele (cdr lst) ele)
      (cons (car lst) (rm-ele (cdr lst) ele)))))

(defun za (pla)
  (rm-ele (list (cons 1 (cdr pla)) (cons 2 (cdr pla)) (cons 3 (cdr pla)) (cons 4 (cdr pla)) (cons 5 (cdr pla)) (cons 6 (cdr pla)) (cons 7 (cdr pla)) (cons 8 (cdr pla)) (cons 9 (cdr pla))) pla))

(defun zb (pla)
  (rm-ele (list (list (car pla) 1) (list (car pla) 2) (list (car pla) 3) (list (car pla) 4) (list (car pla) 5) (list (car pla) 6) (list (car pla) 7) (list (car pla) 8) (list (car pla) 9)) pla))

(defun zc (pla)
  (defun zcv (plc)
    (defun fd-z (plc)
      (list  (/ (- (car plc) 1) 3) (/ (- (cadr plc) 1) 3)))
    (defun zab (m n a b acc)
      (if (and (equal a 3) (equal b 3))
	(cons (list (+ (* 3 m) a) (+ (* 3 n) b)) acc)
	(if (equal b 3)
	    (zab m n (+ 1 a) 1 (cons (list (+ (* 3 m) a) (+ (* 3 n) b)) acc))
	(zab m n a (+ 1 b) (cons (list (+ (* 3 m) a) (+ (* 3 n) b)) acc)))))
    (zab (car (fd-z plc)) (cadr (fd-z plc)) 1 1 nil))
  (rm-ele (zcv pla) pla))

(defun rela (place)
  (pecons (za place) (pecons (zb place) (zc place))))

(defun rep (pla pos)
  (defun mrev (lst) 
    (defun rev-acc (lst acc)
      (if (null lst)
	  acc
	(rev-acc (cdr lst) (cons (car lst) acc))))
    (rev-acc lst nil))
  (defun last (lst)
    (car (mrev lst)))
  (defun exlast (lst)
    (mrev (cdr (mrev lst))))
  (defun pecons (lsta lstb)
    (if (and (atom lsta) (not (equal lsta nil)))
	(message "first element need to be a list")
      (if (null lsta)
	  lstb
	(pecons (exlast lsta) (cons (last lsta) lstb)))))
  (defun naft (lst n)
    (if (eq n 1)
	lst
      (naft (cdr lst) (- n 1))))
  (defun nbef (lst n)
    (defun nbefacc (lst n acc)
      (if (eq n acc)
	nil
	(cons (car lst) (nbefacc (cdr lst) n (+ 1 acc)))))
    (nbefacc lst n 1))
  (defun find-acc (place list acc)
    (if (null list)
	0
      (if (equal (caar list) place)
	  acc
	(find-acc place (cdr list) (+ 1 acc)))))
  (defun find (place) 
    (find-acc place lists 1))
  (if (equal (find pla) 0)
      (and (setq lists (cons (cons pla pos) lists)) (cons pla pos))
    (setq lists (pecons (nbef lists (find pla)) 
			(cons (cons pla pos) (cdr (naft lists (find pla))))))
    (cons pla pos)))

(defun rep2 (pla pos)
  (if (not (and (simp pos) (not (simp (cel pla)))))
      (rep pla pos)
    (rep pla pos)
    (chec pla)))
      

(defun rdu (place)
  (defun rdu-pos (pla pos)
    (rep pla (rm-ele (cel pla) pos)))
  (defun gro-rdu (plst pos)
    (if (null plst)
	lists
      (and (rdu-pos (car plst) pos)
	   (gro-rdu (cdr plst) pos))))
  (if (not (simp (cel place)))
      nil
      (gro-rdu (rela place) (car (cel place)))
      (cons place (pecons (cel place) (cel place)))))


(defun consider (pla)
  (if (null pla)
      nil
    (if (simp (cel pla))
	nil
      (if (not (simp (same (difs (cel pla) (cels (za pla)))
			   (same (difs (cel pla) (cels (zb pla)))
			       (difs (cel pla) (cels (zc pla)))))))
	  (rep pla (difs (cel pla) (cels (sure (rela pla)))))
	(rep pla (same (difs (cel pla) (cels (za pla)))
		       (same (difs (cel pla) (cels (zb pla)))
			     (difs (cel pla) (cels (zc pla))))))))))

(defun chec (pla)
    (if (simp (cel pla))  
	(rdu pla)
      (consider pla)))

(defun checs (lsts)
  (if (null lsts)
      nil
    (cons (chec (car lsts))
	  (checs (cdr lsts)))))

(provide sudoku.el)
;;code ends here
