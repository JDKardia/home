#  ______   __  __     ______     __  __     __     __   __     ______     __  __     __     ______
# /\  ___\ /\ \/\ \   /\  ___\   /\ \/ /    /\ \   /\ "-.\ \   /\  ___\   /\ \_\ \   /\ \   /\__  _\
# \ \  __\ \ \ \_\ \  \ \ \____  \ \  _"-.  \ \ \  \ \ \-.  \  \ \___  \  \ \  __ \  \ \ \  \/_/\ \/
#  \ \_\    \ \_____\  \ \_____\  \ \_\ \_\  \ \_\  \ \_\\"\_\  \/\_____\  \ \_\ \_\  \ \_\    \ \_\
#   \/_/     \/_____/   \/_____/   \/_/\/_/   \/_/   \/_/ \/_/   \/_____/   \/_/\/_/   \/_/     \/_/
from pprint import pformat
import traceback


def vpp(val):
    """
    prints out the code that evaluates to val and val itself, then returns the value passed in.

    >>> a = 'farce'
    >>> b = vpp(a)
    a -> 'farce'
    >>> b
    'farce'
    >>> def func(donothing): return donothing
    ...
    >>> def funk(donothing,FUNKY): return donothing
    ...
    >>> c = ["hello","dave"]
    >>> d = funk(func(vpp(func([entry for entry in c]))),funk(123,funk(456,funk(678,func("hi")))))
    func([entry for entry in c]) -> ['hello', 'dave']
    >>> d
    ['hello', 'dave']
    """

    before, after = traceback.extract_stack()[-2].line.split("vpp")
    before_unmatched_paren = before.count("(") - before.count(")")
    after_unmatched_paren = 0
    after_slice_index = 0

    for i, char in enumerate(reversed(after)):
        if char == ")":
            if after_unmatched_paren == before_unmatched_paren:
                after_slice_index = i + 1
            after_unmatched_paren += 1
        elif char == "(":
            after_unmatched_paren -= 1
        else:
            continue

    input_code = after[1:-after_slice_index]
    print(f"{input_code} -> {pformat(val)}")
    return val


def epp(evaluation):
    """
    act as passthrough if not outermost call, but if it is, will print out the name of the
    variable being assigned, then the value, then return the value passed in

    >>> a = 'farce'
    >>> b = epp(a)
    b -> 'farce'
    >>> b
    'farce'
    >>> def func(donothing): return donothing
    ...
    >>> c = ["hello","dave"]
    >>> d = func(func(epp(func([entry for entry in c]))))
    >>> d
    ['hello', 'dave']
    >>> dog, man = epp(("fido","jim"))
    dog, man -> ('fido', 'jim')
    """
    before, after = traceback.extract_stack()[-2].line.split("=", 1)
    epp_location = after.lstrip().index("epp")

    if epp_location != 0:
        return evaluation
    else:
        print(f"{before.rstrip()} -> {pformat(evaluation)}")
        return evaluation


if __name__ == "__main__":
    import doctest

    doctest.testmod()
