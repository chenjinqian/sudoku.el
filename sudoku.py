#!/usr/bin/env python
# author: chenjinqian
# email: 2012chenjinqian@gmail.com


import itertools


test_1 = [[8,0,0,0,0,0,0,0,0],
          [0,0,7,5,0,0,0,0,9],
          [0,3,0,0,0,0,1,8,0],
          [0,6,0,0,0,1,0,5,0],
          [0,0,9,0,4,0,0,0,0],
          [0,0,0,7,5,0,0,0,0],
          [0,0,2,0,7,0,0,0,4],
          [0,0,0,0,0,3,6,1,0],
          [0,0,0,0,0,0,8,0,0]]
test_4 = [[0,0,0,0,0,2,0,7,0],
          [0,9,5,0,0,0,0,4,0],
          [0,0,6,0,0,5,9,0,0],
          [0,0,0,0,4,8,5,0,1],
          [0,0,0,0,2,0,0,0,0],
          [8,0,9,5,6,0,0,0,0],
          [0,0,4,1,0,0,2,0,0],
          [0,1,0,0,0,0,8,3,0],
          [0,6,0,7,0,0,0,0,0]]
test_2 = [[0,9,0,0,0,0,1,5,0],
          [0,0,0,3,7,0,0,0,0],
          [0,0,0,0,0,5,2,8,0],
          [0,0,4,1,0,0,0,0,6],
          [7,0,0,0,4,0,0,0,8],
          [8,0,0,0,0,2,4,0,0],
          [0,5,3,8,0,0,0,0,0],
          [0,0,0,0,1,4,0,0,0],
          [0,1,2,0,0,0,0,7,0]]
test_3 = [[0,9,0,0,0,0,1,5,0],
          [0,0,0,3,7,0,0,0,0],
          [0,0,0,0,0,5,2,8,0],
          [0,0,4,1,0,0,0,0,6],
          [7,0,0,0,4,0,0,0,8],
          [8,0,0,0,0,2,4,0,0],
          [0,5,3,8,0,0,0,0,0],
          [0,0,0,0,1,4,0,0,0],
          [0,1,2,0,0,0,0,7,0]]
solve_2 = """
3 9 6|4 2 8|1 5 7
2 8 5|3 7 1|6 4 9
1 4 7|6 9 5|2 8 3
-----+-----+-----
5 2 4|1 8 3|7 9 6
7 3 1|9 4 6|5 2 8
8 6 9|7 5 2|4 3 1
-----+-----+-----
4 5 3|8 6 7|9 1 2
9 7 8|2 1 4|3 6 5
6 1 2|5 3 9|8 7 4
"""
# solved within four tic_tok process.


def groupn(lst, n):
    return itertools.zip_longest(
        *[itertools.islice(lst, i, None, n) for i in range(n)])


class sudoku(object):
    def __init__(self):
        """
        solve sudoku problem
        example:
        s = sudoku()
        load = s.load(test_2)
        s.rlt = s.tic_tok()
        print(s.show())
        rlt = s.process()
        print(s.show(rlt))
        TODO: speed up by trim search place.
        """
        self.rlt = []
        self.task_lst = []
        self.unit_lst = self.init_unit()

    def load(self, simple_lst, setv=True):
        """
        represent 9*9 matrix with list of length 81,
        each element is set of possible values.
        solved puzzle is like [{1}, {3}, ...],
        each cell have only one possible value.

        Notice: in this class,
        sn_? means index(series number) of this list,
        started with zero
        """
        assert(len(simple_lst) == 9)
        assert(sum([len(i) for i in simple_lst]) == 81)
        rlt = []
        for i in simple_lst:
            for j in i:
                if j:
                    rlt.append(set([j]))
                else:
                    rlt.append(set([i+1 for i in range(9)]))
        self.rlt = rlt
        return rlt

    def show(self, rlt=None):
        """
        print rlt in human readable format.
        """
        if rlt is None:
            rlt = self.rlt
        r_div = "\n-----+-----+-----\n"
        c_div = '|'
        s = r_div.join(["\n".join(
            [c_div.join([" ".join(
                ["%s"%list(j)[0] if (1==len(j))
                 else "." if (len(j)>1) else "x"
                 for j in c3])
                         for c3 in groupn(i, 3)])
             for i in r3])
                        for r3 in groupn(
                                list(groupn(rlt, 9)), 3)])
        return s

    def is_solved(self, lst=None):
        """
        neccery to have only one possible value for each cell.
        return list of bool of each cell have one value, like
        [True, False, ...]
        """
        if lst is None:
            lst = self.rlt
        return [bool(len(i)==1) for i in lst]

    def is_unsolved(self, lst=None):
        """
        like is_solved, but reverse.
        """
        if lst is None:
            lst = self.rlt
        return [bool(len(i)>1) for i in lst]

    def is_died(self, lst=None):
        """
        if puzzle ill designed, or after bad guess, cell possible value is nil,
        in another words, len(set) < 1
        return list of bool value.
        """
        if lst is None:
            lst = self.rlt
        return [bool(len(i)<1) for i in lst]

    def init_unit(self):
        """
        one unit is formed of 9 cells, each unit have all numbers from 0 ~ 9,
        this is all rules for sudoku puzzle.
        in normal case, each puzzle have 27 units: 9 rows, 9 columns, 9 square.
        some cases 31 units. if so, this function is only place to be changed,
        not consider here.
        """
        st_lst = [set() for i in range(9 + 9 + 9)]
        for i in range(9 * 9):
            c = i % 9
            r = int((i - c) / 9)
            x = 3 * int((r - r%3) / 3) + int((c - c%3) / 3)
            st_lst[c].add(i)
            st_lst[r+9].add(i)
            st_lst[x+18].add(i)
        return st_lst

    def tok_acc(self, v_set, unit_set, rlt):
        """
        1 . .|C . .|. . .
        . A .|. . .|. . .
        . . .|. . .|. . .
        -----+-----+-----
        B . .|. . .|. . .
        . . .|. . .|. . .
        . . .|. . .|. . E
        -----+-----+-----
        . . .|. . .|D . .
        . . .|. . .|. . (2, 3)
        . . .|. G .|. . (2, 3)
        consider upper case, it's easy to figure out  (A)
        could not be 1, because 1 and (A) both in same unit,
        and in rules, one unit only have one number once.
        This means (1 not in set(A)), simular to (B) and (C).
        in mathmatic language,

        set(A) - set([1]) < len(set([1]))

        (B) = (B) - set(1)
        (C) = (C) - set(1) ...
        which means OUTSIDE target cell, one possible value is clear up.

        Same thory, even we are not sure about right-down corner,
        E, D should not be 2 nor 3, G not affacted.
        math expression is the same.
        complex rules are not neccessery in some easy puzzles.

        NOTICE, if there three cell that have value set of (2, 3) or (2),
        then we meet dead end, this puzzle have no solve.
        Because there are no enough values to give every cell(drawer theory).
        if we find this case, set all three cell to empty set and return,
        so that upper level function could findout and handle it.
        """
        sn_set = set([i for i in range(9*9)
                      if  ((len(v_set - rlt[i])==0)
                           and (len(rlt[i] - v_set)==0))])
        if not (len(unit_set - sn_set) == len(unit_set) - len(v_set)):
            if (len(sn_set & unit_set) > len(v_set)):
                return [(rlt[i] - v_set) for i in range(9*9)]
            else:
                return rlt
        if len(unit_set - sn_set) < len(unit_set):
            rlt = [(rlt[i] - v_set)
                       if (not i in sn_set
                           and (i in unit_set))
                       else rlt[i]
                       for i in range(9*9)]
        return rlt

    def tok(self, rlt=None):
        """
        check tok_acc case for all conbinetion one by one.
        """
        if rlt is None:
            rlt = self.rlt
        if rlt is None:
            rlt = self.rlt
        set_lst = [set([i+1, j+1, k+1]) for i in range(9)
                   for j in range(9) for k in range(9)
                   if (i<=j<=k)]
        for v_set in set_lst:
            for unit in self.unit_lst:
                rlt = self.tok_acc(v_set, unit, rlt)
        return rlt

    def tic_acc(self, v_set, unit, rlt):
        """
        A . .|. . .|2 . .
        . . .|. . .|1 . .
        . . .|1 . .|3 . .
        -----+-----+-----
        . . 1|. . .|. . .
        . . .|. . .|. 3 .
        . . .|. . .|. 2 .
        -----+-----+-----
        . 1 .|. . .|9 . 7
        . . .|. . .|. . C
        . . .|. . .|. . B
        consider upper case,
        in unit square-1, there is only one cell have possiblity
        to be 1, then this cell (A) have to be 1.
        if not, this unit will not have value 1.

        if v_set is (1), unit is left-up square
        then (A) = (A) & (1)
        Which mean (A) clear up INSIDE possible values.

        expand this rule, v_set is (2, 3), unit is right-down square,
        only two cells left for two value (2, 3), perfect match.
        (A) = (A) & (2, 3)
        (B) = (B) & (2, 3)

        Notice, cell and value must math same length.
        """
        sn_set = set([i for i in unit
                     if (len(v_set - rlt[i])<len(v_set))])
        if not len(sn_set) == len(v_set):
            return rlt
        return [(v_set & i[0]) if (i[1] in sn_set) else i[0]
                for i in zip(rlt, range(len(rlt)))]

    def tic(self, rlt=None):
        """
        exclude target Inside possible value set.
        """
        if rlt is None:
            rlt = self.rlt
        set_lst = [set([i+1, j+1, k+1]) for i in range(9)
                   for j in range(9) for k in range(9)
                   if (i<=j<=k)]
        for v_set in set_lst:
            for unit in self.unit_lst:
                rlt = self.tic_acc(v_set, unit, rlt)
        return rlt

    def tic_tok(self, rlt=None, n=3):
        """
        use tic and tok one time, for every unit set,
        for every value_set, such as [{1}, {2}, ..., {1,2}, ...],
        in which max length of value_set is n.
        if n is 1, only apply simple value set for tic-tok process.
        Some complex puzzle may get stalled using simple rule.
        """
        if rlt is None:
            rlt = self.rlt
        assert(n>=1)
        set_lst = [set([i+1]) for i in range(9)]
        n -= 1
        while n > 0:
            set_lst = [(st_one | set([i+1]))
                       for i in range(9)
                       for st_one in set_lst
                       if (i+1>=max(st_one))]
            n -= 1
        for v_set in set_lst:
            for unit_tic in self.unit_lst:
                rlt = self.tic_acc(v_set, unit_tic, rlt)
            for unit_tok in self.unit_lst:
                rlt = self.tok_acc(v_set, unit_tok, rlt)
        return rlt

    def process_acc(self, rlt=None):
        """
        auto handle rule complex parameter n.
        It seems n >= 4 is of little meaning.
        """
        if rlt is None:
            rlt = self.rlt
        for n_1 in range(3):
            n = n_1 + 1
            useless_cnt = 0
            old_sum = sum([len(i) for i in rlt])
            old_solved = sum(self.is_solved(rlt))
            while useless_cnt < 1:
                rlt_new = self.tic_tok(rlt=rlt, n=n)
                new_sum = sum([len(i) for i in rlt_new])
                now_solved = sum(self.is_solved(rlt_new))
                if new_sum == old_sum:
                    useless_cnt += 1
                rlt = rlt_new
                old_sum = new_sum
                old_solved = now_solved
                solved_sum = self.is_solved(rlt_new)
                if now_solved == 81:
                    return rlt
        return rlt

    def make_choice(self, rlt):
        """
        if one puzzle is stalled, chose one cell and
        guess its value each time,
        return list of all guess.
        """
        cnt = -1
        st_pick = set([])
        st_acc = None
        for st_one in rlt:
            cnt += 1
            if ((len(st_one) > 1 > len(st_pick))
                or (1 < len(st_one) < len(st_pick))):
                st_pick = st_one
                st_acc = cnt
        if len(st_pick) >= 1:
            choice_lst = []
            symbol_lst = []
            for pop_one in st_pick:
                ss = "GUESS: (%s, %s) --> %s"%(
                    int(st_acc/9)+1,
                    st_acc%9+1,
                    pop_one)
                symbol_lst.append(ss)
                choice_lst.append([set([pop_one]) if i[0]==st_acc else i[1]
                                   for i in zip(range(len(rlt)), rlt)])
            return [i for i in zip(choice_lst, symbol_lst)]
        return []

    def process(self, rlt=None):
        """
        use process_acc should sove most sudoku puzzle,
        but there exist supper hard ones, even complex rules is
        of no help, such as test_1
        For those puzzles, it need to use deepth prior search
        to find out one solve.
        In thory, if there is a function to determine puzzled solved or not,
        it is enough to find a solve, but that takes long time.
        to save time, after each guess, use process_acc
        to reduce search space.
        Notice:
        do not return all solve if puzzle have multiple solve.
        """
        if rlt is None:
            rlt = self.rlt
        rlt = self.process_acc(rlt)
        choice_lst = self.make_choice(rlt)
        for coss in choice_lst:
            choice_one, ss = coss
            # print(ss)
            rlt = self.process(choice_one)
            if sum(self.is_solved(rlt)) == 9*9:
                return rlt
            else:
                continue
        return rlt


def main():
    s = sudoku()
    load = s.load(test_1)
    print(s.show())
    print("start slove...")
    rlt = s.process()
    print("result:")
    print(s.show(rlt))
    return rlt


if __name__ == '__main__':
    main()
