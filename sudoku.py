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

test_2 = [[0,9,0,0,0,0,1,5,0],
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

test_3 = [[0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0],
          [0,0,0,0,0,0,0,0,0]]

def groupn(lst, n):
    return itertools.zip_longest(
        *[itertools.islice(lst, i, None, n) for i in range(n)])


class sudoku(object):
    def __init__(self):
        "solve sudoku problem"
        self.rlt_lst = []
        self.task_lst = []
        self.unit_lst = self.init_unit()

    def load(self, simple_lst):
        assert(len(simple_lst) == 9)
        assert(sum([len(i) for i in simple_lst]) == 81)
        rlt_lst = []
        for i in simple_lst:
            for j in i:
                if j:
                    rlt_lst.append(set([j]))
                else:
                    rlt_lst.append(set([i+1 for i in range(9)]))
        self.rlt_lst = rlt_lst
        return rlt_lst

    def show(self, rlt_lst=None):
        if rlt_lst is None:
            rlt_lst = self.rlt_lst
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
                                list(groupn(rlt_lst, 9)), 3)])
        # print(s)
        return s

    def cel_one(self, lst=None):
        if lst is None:
            lst = self.rlt_lst
        return [bool(len(i)==1) for j in self.rlt_lst for i in j]

    def cel_not_one(self, lst):
        return [not(i) for i in self.cel_one()]

    def init_unit(self):
        st_lst = [set() for i in range(9 + 9 + 9)]
        for i in range(9 * 9):
            c = i % 9
            r = int((i - c) / 9)
            x = 3 * int((r - r%3) / 3) + int((c - c%3) / 3)
            # print(c, r, x)
            st_lst[c].add(i)
            st_lst[r+9].add(i)
            st_lst[x+18].add(i)
        return st_lst

    def get_unit(self, sn, unit_lst=None):
        assert(type(sn) == int and (0 <= sn <= 80))
        if unit_lst is None:
            unit_lst = self.unit_lst
        return [i for i in unit_lst if sn in i]

    def tok_acc(self, v_set, unit_set, rlt_lst):
        sn_set = set([i for i in range(9*9)
                      if  ((len(v_set - rlt_lst[i])==0)
                           and (len(rlt_lst[i] - v_set)==0))])
        if not len(unit_set - sn_set) == len(unit_set) - len(v_set):
            return rlt_lst
        if len(unit_set - sn_set) < len(unit_set):
            rlt_lst = [(rlt_lst[i] - v_set)
                       if (not i in sn_set
                           and (i in unit_set))
                       else rlt_lst[i]
                       for i in range(9*9)]
        return rlt_lst

    def tok(self, rlt_lst=None):
        """
        exclude cells Outside targets possible value set.
        """
        if rlt_lst is None:
            rlt_lst = self.rlt_lst
        if rlt_lst is None:
            rlt_lst = self.rlt_lst
        set_lst = [set([i+1, j+1, k+1]) for i in range(9) for j in range(9) for k in range(9)
                   if (i<=j<=k)]
        for v_set in set_lst:
            for unit in self.unit_lst:
                rlt_lst = self.tok_acc(v_set, unit, rlt_lst)
        return rlt_lst

    def tic_acc(self, v_set, unit, rlt_lst):
        v_in_unit = [i for i in unit if (len(v_set - rlt_lst[i])<len(v_set))]
        if not len(v_in_unit) == len(v_set):
            return rlt_lst
        # print(v_in_unit)
        sn_set = set(v_in_unit)
        return [(v_set & i[0]) if (i[1] in sn_set) else i[0]
                for i in zip(rlt_lst, range(len(rlt_lst)))]

    def tic(self, rlt_lst=None):
        """
        exclude target Inside possible value set.
        """
        if rlt_lst is None:
            rlt_lst = self.rlt_lst
        set_lst = [set([i+1, j+1, k+1]) for i in range(9) for j in range(9) for k in range(9)
                   if (i<=j<=k)]
        for v_set in set_lst:
            for unit in self.unit_lst:
                rlt_lst = self.tic_acc(v_set, unit, rlt_lst)
        return rlt_lst

    def tic_tok(self, rlt_lst=None, n=3):
        if rlt_lst is None:
            rlt_lst = self.rlt_lst
        assert(n>=1)
        set_lst = [set([i+1]) for i in range(9)]
        n -= 1
        while n > 0:
            set_lst = [(st_one | set([i+1]))
                       for i in range(9)
                       for st_one in set_lst
                       if (i+1>=max(st_one))]
            n -= 1
        # set_lst = [set([i+1, j+1, k+1]) for i in range(9)
        #            for j in range(9) for k in range(9)
        #            if (i<=j<=k)]
        for v_set in set_lst:
            for unit_tic in self.unit_lst:
                rlt_lst = self.tic_acc(v_set, unit_tic, rlt_lst)
            for unit_tok in self.unit_lst:
                rlt_lst = self.tok_acc(v_set, unit_tok, rlt_lst)
                # for unit_tok in self.unit_lst:
                #     if (len(unit_tic | unit_tok) < len(v_set)
                #         or len(unit_tic | unit_tok)==9):
                #         continue
                #     rlt_lst = self.tok_acc(v_set, unit_tok, rlt_lst)
        return rlt_lst


def main():
    pass

if __name__ == '__main__':
    main()
