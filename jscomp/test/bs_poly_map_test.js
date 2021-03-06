'use strict';

var Mt = require("./mt.js");
var Bs_Map = require("../../lib/js/bs_Map.js");
var Bs_Set = require("../../lib/js/bs_Set.js");
var Bs_Array = require("../../lib/js/bs_Array.js");
var Caml_primitive = require("../../lib/js/caml_primitive.js");
var Array_data_util = require("./array_data_util.js");
var Bs_SortedMapDict = require("../../lib/js/bs_SortedMapDict.js");

var suites = [/* [] */0];

var test_id = [0];

function eq(loc, x, y) {
  return Mt.eq_suites(test_id, suites, loc, x, y);
}

function b(loc, v) {
  return Mt.bool_suites(test_id, suites, loc, v);
}

var Icmp = /* module */[/* cmp */Caml_primitive.caml_int_compare];

function mapOfArray(x) {
  return Bs_Map.ofArray(x, Icmp);
}

function setOfArray(x) {
  return Bs_Set.ofArray(x, Icmp);
}

function emptyMap() {
  return {
          cmp: Icmp[/* cmp */0],
          data: Bs_SortedMapDict.empty
        };
}

function mergeInter(s1, s2) {
  var m = Bs_Map.merge(s1, s2, (function (_, v1, v2) {
          if (v1 && v2) {
            return /* Some */[/* () */0];
          } else {
            return /* None */0;
          }
        }));
  var x = Bs_SortedMapDict.keysToArray(m.data);
  return Bs_Set.ofArray(x, Icmp);
}

function mergeUnion(s1, s2) {
  var m = Bs_Map.merge(s1, s2, (function (_, v1, v2) {
          if (v1) {
            return /* Some */[/* () */0];
          } else if (v2) {
            return /* Some */[/* () */0];
          } else {
            return /* None */0;
          }
        }));
  var x = Bs_SortedMapDict.keysToArray(m.data);
  return Bs_Set.ofArray(x, Icmp);
}

function mergeDiff(s1, s2) {
  var m = Bs_Map.merge(s1, s2, (function (_, v1, v2) {
          if (v1 && !v2) {
            return /* Some */[/* () */0];
          } else {
            return /* None */0;
          }
        }));
  var x = Bs_SortedMapDict.keysToArray(m.data);
  return Bs_Set.ofArray(x, Icmp);
}

function randomRange(i, j) {
  return Bs_Array.map(Array_data_util.randomRange(i, j), (function (x) {
                return /* tuple */[
                        x,
                        x
                      ];
              }));
}

var x = randomRange(0, 100);

var u0 = Bs_Map.ofArray(x, Icmp);

var x$1 = randomRange(30, 120);

var u1 = Bs_Map.ofArray(x$1, Icmp);

var x$2 = Array_data_util.range(30, 100);

b("File \"bs_poly_map_test.ml\", line 50, characters 4-11", Bs_Set.eq(mergeInter(u0, u1), Bs_Set.ofArray(x$2, Icmp)));

var x$3 = Array_data_util.range(0, 120);

b("File \"bs_poly_map_test.ml\", line 51, characters 4-11", Bs_Set.eq(mergeUnion(u0, u1), Bs_Set.ofArray(x$3, Icmp)));

var x$4 = Array_data_util.range(0, 29);

b("File \"bs_poly_map_test.ml\", line 52, characters 4-11", Bs_Set.eq(mergeDiff(u0, u1), Bs_Set.ofArray(x$4, Icmp)));

var x$5 = Array_data_util.range(101, 120);

b("File \"bs_poly_map_test.ml\", line 53, characters 4-11", Bs_Set.eq(mergeDiff(u1, u0), Bs_Set.ofArray(x$5, Icmp)));

var x$6 = randomRange(0, 10);

var a0 = Bs_Map.ofArray(x$6, Icmp);

var a1 = Bs_Map.set(a0, 3, 33);

var a2 = Bs_Map.remove(a1, 3);

var a3 = Bs_Map.update(a2, 3, (function (k) {
        if (k) {
          return /* Some */[k[0] + 1 | 0];
        } else {
          return /* Some */[11];
        }
      }));

var a4 = Bs_Map.update(a2, 3, (function (k) {
        if (k) {
          return /* Some */[k[0] + 1 | 0];
        } else {
          return /* None */0;
        }
      }));

var a5 = Bs_Map.remove(a0, 3);

var a6 = Bs_Map.remove(a5, 3);

b("File \"bs_poly_map_test.ml\", line 72, characters 4-11", +(a5 === a6));

b("File \"bs_poly_map_test.ml\", line 73, characters 4-11", Bs_Map.has(a0, 3));

b("File \"bs_poly_map_test.ml\", line 74, characters 4-11", 1 - Bs_Map.has(a5, 3));

b("File \"bs_poly_map_test.ml\", line 75, characters 4-11", +(3 === Bs_Map.getUndefined(a0, 3)));

b("File \"bs_poly_map_test.ml\", line 76, characters 4-11", +(33 === Bs_Map.getUndefined(a1, 3)));

b("File \"bs_poly_map_test.ml\", line 77, characters 4-11", +(Bs_Map.getUndefined(a2, 3) === undefined));

b("File \"bs_poly_map_test.ml\", line 79, characters 4-11", +(11 === Bs_Map.getUndefined(a3, 3)));

b("File \"bs_poly_map_test.ml\", line 80, characters 4-11", +(Bs_Map.getUndefined(a4, 3) === undefined));

var a7 = Bs_Map.removeMany(a0, /* array */[
      7,
      8,
      0,
      1,
      3,
      2,
      4,
      922,
      4,
      5,
      6
    ]);

eq("File \"bs_poly_map_test.ml\", line 83, characters 5-12", Bs_SortedMapDict.keysToArray(a7.data), /* int array */[
      9,
      10
    ]);

var a8 = Bs_Map.removeMany(a7, Array_data_util.randomRange(0, 100));

b("File \"bs_poly_map_test.ml\", line 85, characters 4-11", Bs_SortedMapDict.isEmpty(a8.data));

var x$7 = randomRange(0, 100);

var u0$1 = Bs_Map.ofArray(x$7, Icmp);

var u1$1 = Bs_Map.set(u0$1, 3, 32);

eq("File \"bs_poly_map_test.ml\", line 92, characters 5-12", Bs_Map.get(u1$1, 3), /* Some */[32]);

eq("File \"bs_poly_map_test.ml\", line 93, characters 5-12", Bs_Map.get(u0$1, 3), /* Some */[3]);

function acc(m, is) {
  return Bs_Array.reduce(is, m, (function (a, i) {
                var m = a;
                var i$1 = i;
                return Bs_Map.update(m, i$1, (function (n) {
                              if (n) {
                                return /* Some */[n[0] + 1 | 0];
                              } else {
                                return /* Some */[1];
                              }
                            }));
              }));
}

var m = {
  cmp: Icmp[/* cmp */0],
  data: Bs_SortedMapDict.empty
};

var m1 = acc(m, Bs_Array.concat(Array_data_util.randomRange(0, 20), Array_data_util.randomRange(10, 30)));

var x$8 = Bs_Array.makeBy(31, (function (i) {
        return /* tuple */[
                i,
                i >= 10 && i <= 20 ? 2 : 1
              ];
      }));

b("File \"bs_poly_map_test.ml\", line 105, characters 4-11", Bs_Map.eq(m1, Bs_Map.ofArray(x$8, Icmp), (function (x, y) {
            return +(x === y);
          })));

var v0 = {
  cmp: Icmp[/* cmp */0],
  data: Bs_SortedMapDict.empty
};

var v1 = Bs_Map.mergeMany(v0, Bs_Array.map(Array_data_util.randomRange(0, 10000), (function (x) {
            return /* tuple */[
                    x,
                    x
                  ];
          })));

var x$9 = Bs_Array.map(Array_data_util.randomRange(0, 10000), (function (x) {
        return /* tuple */[
                x,
                x
              ];
      }));

var v2 = Bs_Map.ofArray(x$9, Icmp);

b("File \"bs_poly_map_test.ml\", line 119, characters 4-11", Bs_Map.eq(v1, v2, (function (x, y) {
            return +(x === y);
          })));

function inc(x) {
  if (x) {
    return /* Some */[x[0] + 1 | 0];
  } else {
    return /* Some */[0];
  }
}

var v3 = Bs_Map.update(v1, 10, inc);

var v4 = Bs_Map.update(v3, -10, inc);

var match = Bs_Map.split(v3, 5000);

var pres = match[1];

var match$1 = match[0];

var match$2 = Bs_Map.get(v3, 10);

b("File \"bs_poly_map_test.ml\", line 128, characters 4-11", match$2 && match$2[0] === 11 ? /* true */1 : /* false */0);

var match$3 = Bs_Map.get(v3, -10);

b("File \"bs_poly_map_test.ml\", line 129, characters 4-11", match$3 ? /* false */0 : /* true */1);

var match$4 = Bs_Map.get(v4, -10);

b("File \"bs_poly_map_test.ml\", line 130, characters 4-11", match$4 && match$4[0] === 0 ? /* true */1 : /* false */0);

var map = Bs_Map.remove({
      cmp: Icmp[/* cmp */0],
      data: Bs_SortedMapDict.empty
    }, 0);

b("File \"bs_poly_map_test.ml\", line 131, characters 4-11", Bs_SortedMapDict.isEmpty(map.data));

var map$1 = Bs_Map.removeMany({
      cmp: Icmp[/* cmp */0],
      data: Bs_SortedMapDict.empty
    }, /* int array */[0]);

b("File \"bs_poly_map_test.ml\", line 132, characters 4-11", Bs_SortedMapDict.isEmpty(map$1.data));

b("File \"bs_poly_map_test.ml\", line 133, characters 4-11", pres && pres[0] === 5000 ? /* true */1 : /* false */0);

b("File \"bs_poly_map_test.ml\", line 134, characters 4-11", Bs_Array.eq(Bs_SortedMapDict.keysToArray(match$1[0].data), Bs_Array.makeBy(5000, (function (i) {
                return i;
              })), (function (x, y) {
            return +(x === y);
          })));

b("File \"bs_poly_map_test.ml\", line 135, characters 4-11", Bs_Array.eq(Bs_SortedMapDict.keysToArray(match$1[1].data), Bs_Array.makeBy(5000, (function (i) {
                return 5001 + i | 0;
              })), (function (x, y) {
            return +(x === y);
          })));

var v7 = Bs_Map.remove(v3, 5000);

var match$5 = Bs_Map.split(v7, 5000);

var match$6 = match$5[0];

b("File \"bs_poly_map_test.ml\", line 139, characters 4-11", match$5[1] ? /* false */0 : /* true */1);

b("File \"bs_poly_map_test.ml\", line 140, characters 4-11", Bs_Array.eq(Bs_SortedMapDict.keysToArray(match$6[0].data), Bs_Array.makeBy(5000, (function (i) {
                return i;
              })), (function (x, y) {
            return +(x === y);
          })));

b("File \"bs_poly_map_test.ml\", line 141, characters 4-11", Bs_Array.eq(Bs_SortedMapDict.keysToArray(match$6[1].data), Bs_Array.makeBy(5000, (function (i) {
                return 5001 + i | 0;
              })), (function (x, y) {
            return +(x === y);
          })));

Mt.from_pair_suites("bs_poly_map_test.ml", suites[0]);

var M = 0;

var N = 0;

var A = 0;

var I = 0;

exports.suites = suites;
exports.test_id = test_id;
exports.eq = eq;
exports.b = b;
exports.Icmp = Icmp;
exports.M = M;
exports.N = N;
exports.A = A;
exports.I = I;
exports.mapOfArray = mapOfArray;
exports.setOfArray = setOfArray;
exports.emptyMap = emptyMap;
exports.mergeInter = mergeInter;
exports.mergeUnion = mergeUnion;
exports.mergeDiff = mergeDiff;
exports.randomRange = randomRange;
exports.acc = acc;
/* x Not a pure module */
