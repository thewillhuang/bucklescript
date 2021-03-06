'use strict';

var Bs_SortArray = require("./bs_SortArray.js");
var Bs_internalAVLset = require("./bs_internalAVLset.js");

function remove0(nt, x, cmp) {
  var k = nt.key;
  var c = cmp(x, k);
  if (c) {
    if (c < 0) {
      var match = nt.left;
      if (match !== null) {
        nt.left = remove0(match, x, cmp);
        return Bs_internalAVLset.balMutate(nt);
      } else {
        return nt;
      }
    } else {
      var match$1 = nt.right;
      if (match$1 !== null) {
        nt.right = remove0(match$1, x, cmp);
        return Bs_internalAVLset.balMutate(nt);
      } else {
        return nt;
      }
    }
  } else {
    var l = nt.left;
    var r = nt.right;
    if (l !== null) {
      if (r !== null) {
        nt.right = Bs_internalAVLset.removeMinAuxWithRootMutate(nt, r);
        return Bs_internalAVLset.balMutate(nt);
      } else {
        return l;
      }
    } else {
      return r;
    }
  }
}

function remove(d, v) {
  var oldRoot = d.data;
  if (oldRoot !== null) {
    var newRoot = remove0(oldRoot, v, d.cmp);
    if (newRoot !== oldRoot) {
      d.data = newRoot;
      return /* () */0;
    } else {
      return 0;
    }
  } else {
    return /* () */0;
  }
}

function removeMany0(_t, xs, _i, len, cmp) {
  while(true) {
    var i = _i;
    var t = _t;
    if (i < len) {
      var ele = xs[i];
      var u = remove0(t, ele, cmp);
      if (u !== null) {
        _i = i + 1 | 0;
        _t = u;
        continue ;
        
      } else {
        return Bs_internalAVLset.empty;
      }
    } else {
      return t;
    }
  };
}

function removeMany(d, xs) {
  var oldRoot = d.data;
  if (oldRoot !== null) {
    var len = xs.length;
    d.data = removeMany0(oldRoot, xs, 0, len, d.cmp);
    return /* () */0;
  } else {
    return /* () */0;
  }
}

function removeCheck0(nt, x, removed, cmp) {
  var k = nt.key;
  var c = cmp(x, k);
  if (c) {
    if (c < 0) {
      var match = nt.left;
      if (match !== null) {
        nt.left = removeCheck0(match, x, removed, cmp);
        return Bs_internalAVLset.balMutate(nt);
      } else {
        return nt;
      }
    } else {
      var match$1 = nt.right;
      if (match$1 !== null) {
        nt.right = removeCheck0(match$1, x, removed, cmp);
        return Bs_internalAVLset.balMutate(nt);
      } else {
        return nt;
      }
    }
  } else {
    removed[0] = /* true */1;
    var l = nt.left;
    var r = nt.right;
    if (l !== null) {
      if (r !== null) {
        nt.right = Bs_internalAVLset.removeMinAuxWithRootMutate(nt, r);
        return Bs_internalAVLset.balMutate(nt);
      } else {
        return l;
      }
    } else {
      return r;
    }
  }
}

function removeCheck(d, v) {
  var oldRoot = d.data;
  if (oldRoot !== null) {
    var removed = [/* false */0];
    var newRoot = removeCheck0(oldRoot, v, removed, d.cmp);
    if (newRoot !== oldRoot) {
      d.data = newRoot;
    }
    return removed[0];
  } else {
    return /* false */0;
  }
}

function addCheck0(t, x, added, cmp) {
  if (t !== null) {
    var k = t.key;
    var c = cmp(x, k);
    if (c) {
      var l = t.left;
      var r = t.right;
      if (c < 0) {
        var ll = addCheck0(l, x, added, cmp);
        t.left = ll;
      } else {
        t.right = addCheck0(r, x, added, cmp);
      }
      return Bs_internalAVLset.balMutate(t);
    } else {
      return t;
    }
  } else {
    added[0] = /* true */1;
    return Bs_internalAVLset.singleton(x);
  }
}

function addCheck(m, e) {
  var oldRoot = m.data;
  var added = [/* false */0];
  var newRoot = addCheck0(oldRoot, e, added, m.cmp);
  if (newRoot !== oldRoot) {
    m.data = newRoot;
  }
  return added[0];
}

function add(m, e) {
  var oldRoot = m.data;
  var newRoot = Bs_internalAVLset.addMutate(m.cmp, oldRoot, e);
  if (newRoot !== oldRoot) {
    m.data = newRoot;
    return /* () */0;
  } else {
    return 0;
  }
}

function addArrayMutate(t, xs, cmp) {
  var v = t;
  for(var i = 0 ,i_finish = xs.length - 1 | 0; i <= i_finish; ++i){
    v = Bs_internalAVLset.addMutate(cmp, v, xs[i]);
  }
  return v;
}

function mergeMany(d, xs) {
  d.data = addArrayMutate(d.data, xs, d.cmp);
  return /* () */0;
}

function empty(dict) {
  return {
          cmp: dict[/* cmp */0],
          data: Bs_internalAVLset.empty
        };
}

function isEmpty(d) {
  return Bs_internalAVLset.isEmpty(d.data);
}

function minimum(d) {
  return Bs_internalAVLset.minimum(d.data);
}

function minUndefined(d) {
  return Bs_internalAVLset.minUndefined(d.data);
}

function maximum(d) {
  return Bs_internalAVLset.maximum(d.data);
}

function maxUndefined(d) {
  return Bs_internalAVLset.maxUndefined(d.data);
}

function forEach(d, f) {
  return Bs_internalAVLset.forEach(d.data, f);
}

function reduce(d, acc, cb) {
  return Bs_internalAVLset.reduce(d.data, acc, cb);
}

function every(d, p) {
  return Bs_internalAVLset.every(d.data, p);
}

function some(d, p) {
  return Bs_internalAVLset.some(d.data, p);
}

function size(d) {
  return Bs_internalAVLset.size(d.data);
}

function toList(d) {
  return Bs_internalAVLset.toList(d.data);
}

function toArray(d) {
  return Bs_internalAVLset.toArray(d.data);
}

function ofSortedArrayUnsafe(xs, dict) {
  return {
          cmp: dict[/* cmp */0],
          data: Bs_internalAVLset.ofSortedArrayUnsafe(xs)
        };
}

function checkInvariantInternal(d) {
  return Bs_internalAVLset.checkInvariantInternal(d.data);
}

function ofArray(data, dict) {
  var cmp = dict[/* cmp */0];
  return {
          cmp: cmp,
          data: Bs_internalAVLset.ofArray(data, cmp)
        };
}

function cmp(d0, d1) {
  return Bs_internalAVLset.cmp(d0.data, d1.data, d0.cmp);
}

function eq(d0, d1) {
  return Bs_internalAVLset.eq(d0.data, d1.data, d0.cmp);
}

function get(d, x) {
  return Bs_internalAVLset.get(d.data, x, d.cmp);
}

function getUndefined(d, x) {
  return Bs_internalAVLset.getUndefined(d.data, x, d.cmp);
}

function getExn(d, x) {
  return Bs_internalAVLset.getExn(d.data, x, d.cmp);
}

function split(d, key) {
  var arr = Bs_internalAVLset.toArray(d.data);
  var cmp = d.cmp;
  var i = Bs_SortArray.binarySearchBy(arr, key, cmp);
  var len = arr.length;
  if (i < 0) {
    var next = (-i | 0) - 1 | 0;
    return /* tuple */[
            /* tuple */[
              {
                cmp: cmp,
                data: Bs_internalAVLset.ofSortedArrayAux(arr, 0, next)
              },
              {
                cmp: cmp,
                data: Bs_internalAVLset.ofSortedArrayAux(arr, next, len - next | 0)
              }
            ],
            /* false */0
          ];
  } else {
    return /* tuple */[
            /* tuple */[
              {
                cmp: cmp,
                data: Bs_internalAVLset.ofSortedArrayAux(arr, 0, i)
              },
              {
                cmp: cmp,
                data: Bs_internalAVLset.ofSortedArrayAux(arr, i + 1 | 0, (len - i | 0) - 1 | 0)
              }
            ],
            /* true */1
          ];
  }
}

function keepBy(d, p) {
  return {
          cmp: d.cmp,
          data: Bs_internalAVLset.filterCopy(d.data, p)
        };
}

function partition(d, p) {
  var cmp = d.cmp;
  var match = Bs_internalAVLset.partitionCopy(d.data, p);
  return /* tuple */[
          {
            cmp: cmp,
            data: match[0]
          },
          {
            cmp: cmp,
            data: match[1]
          }
        ];
}

function subset(a, b) {
  return Bs_internalAVLset.subset(a.data, b.data, a.cmp);
}

function intersect(a, b) {
  var cmp = a.cmp;
  var match = a.data;
  var match$1 = b.data;
  if (match !== null) {
    if (match$1 !== null) {
      var sizea = Bs_internalAVLset.lengthNode(match);
      var sizeb = Bs_internalAVLset.lengthNode(match$1);
      var totalSize = sizea + sizeb | 0;
      var tmp = new Array(totalSize);
      Bs_internalAVLset.fillArray(match, 0, tmp);
      Bs_internalAVLset.fillArray(match$1, sizea, tmp);
      if (cmp(tmp[sizea - 1 | 0], tmp[sizea]) < 0 || cmp(tmp[totalSize - 1 | 0], tmp[0]) < 0) {
        return {
                cmp: cmp,
                data: Bs_internalAVLset.empty
              };
      } else {
        var tmp2 = new Array(sizea < sizeb ? sizea : sizeb);
        var k = Bs_SortArray.intersect(tmp, 0, sizea, tmp, sizea, sizeb, tmp2, 0, cmp);
        return {
                cmp: cmp,
                data: Bs_internalAVLset.ofSortedArrayAux(tmp2, 0, k)
              };
      }
    } else {
      return {
              cmp: cmp,
              data: Bs_internalAVLset.empty
            };
    }
  } else {
    return {
            cmp: cmp,
            data: Bs_internalAVLset.empty
          };
  }
}

function diff(a, b) {
  var cmp = a.cmp;
  var dataa = a.data;
  var match = b.data;
  if (dataa !== null) {
    if (match !== null) {
      var sizea = Bs_internalAVLset.lengthNode(dataa);
      var sizeb = Bs_internalAVLset.lengthNode(match);
      var totalSize = sizea + sizeb | 0;
      var tmp = new Array(totalSize);
      Bs_internalAVLset.fillArray(dataa, 0, tmp);
      Bs_internalAVLset.fillArray(match, sizea, tmp);
      if (cmp(tmp[sizea - 1 | 0], tmp[sizea]) < 0 || cmp(tmp[totalSize - 1 | 0], tmp[0]) < 0) {
        return {
                cmp: cmp,
                data: Bs_internalAVLset.copy(dataa)
              };
      } else {
        var tmp2 = new Array(sizea);
        var k = Bs_SortArray.diff(tmp, 0, sizea, tmp, sizea, sizeb, tmp2, 0, cmp);
        return {
                cmp: cmp,
                data: Bs_internalAVLset.ofSortedArrayAux(tmp2, 0, k)
              };
      }
    } else {
      return {
              cmp: cmp,
              data: Bs_internalAVLset.copy(dataa)
            };
    }
  } else {
    return {
            cmp: cmp,
            data: Bs_internalAVLset.empty
          };
  }
}

function union(a, b) {
  var cmp = a.cmp;
  var dataa = a.data;
  var datab = b.data;
  if (dataa !== null) {
    if (datab !== null) {
      var sizea = Bs_internalAVLset.lengthNode(dataa);
      var sizeb = Bs_internalAVLset.lengthNode(datab);
      var totalSize = sizea + sizeb | 0;
      var tmp = new Array(totalSize);
      Bs_internalAVLset.fillArray(dataa, 0, tmp);
      Bs_internalAVLset.fillArray(datab, sizea, tmp);
      if (cmp(tmp[sizea - 1 | 0], tmp[sizea]) < 0) {
        return {
                cmp: cmp,
                data: Bs_internalAVLset.ofSortedArrayAux(tmp, 0, totalSize)
              };
      } else {
        var tmp2 = new Array(totalSize);
        var k = Bs_SortArray.union(tmp, 0, sizea, tmp, sizea, sizeb, tmp2, 0, cmp);
        return {
                cmp: cmp,
                data: Bs_internalAVLset.ofSortedArrayAux(tmp2, 0, k)
              };
      }
    } else {
      return {
              cmp: cmp,
              data: Bs_internalAVLset.copy(dataa)
            };
    }
  } else {
    return {
            cmp: cmp,
            data: Bs_internalAVLset.copy(datab)
          };
  }
}

function has(d, x) {
  return Bs_internalAVLset.has(d.data, x, d.cmp);
}

function copy(d) {
  return {
          cmp: d.cmp,
          data: Bs_internalAVLset.copy(d.data)
        };
}

var Int = 0;

var $$String = 0;

exports.empty = empty;
exports.ofArray = ofArray;
exports.ofSortedArrayUnsafe = ofSortedArrayUnsafe;
exports.copy = copy;
exports.isEmpty = isEmpty;
exports.has = has;
exports.add = add;
exports.addCheck = addCheck;
exports.mergeMany = mergeMany;
exports.remove = remove;
exports.removeCheck = removeCheck;
exports.removeMany = removeMany;
exports.union = union;
exports.intersect = intersect;
exports.diff = diff;
exports.subset = subset;
exports.cmp = cmp;
exports.eq = eq;
exports.forEach = forEach;
exports.reduce = reduce;
exports.every = every;
exports.some = some;
exports.keepBy = keepBy;
exports.partition = partition;
exports.size = size;
exports.toList = toList;
exports.toArray = toArray;
exports.minimum = minimum;
exports.minUndefined = minUndefined;
exports.maximum = maximum;
exports.maxUndefined = maxUndefined;
exports.get = get;
exports.getUndefined = getUndefined;
exports.getExn = getExn;
exports.split = split;
exports.checkInvariantInternal = checkInvariantInternal;
exports.Int = Int;
exports.$$String = $$String;
/* No side effect */
