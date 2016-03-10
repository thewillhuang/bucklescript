// Generated CODE, PLEASE EDIT WITH CARE
'use strict';

var Caml_builtin_exceptions = require("../runtime/caml_builtin_exceptions");
var Caml_curry              = require("../runtime/caml_curry");

function peek_queue() {
  throw [
        Caml_builtin_exceptions.assert_failure,
        [
          "format_regression.ml",
          10,
          19
        ]
      ];
}

function int_of_size() {
  throw [
        Caml_builtin_exceptions.assert_failure,
        [
          "format_regression.ml",
          11,
          20
        ]
      ];
}

function take_queue() {
  throw [
        Caml_builtin_exceptions.assert_failure,
        [
          "format_regression.ml",
          12,
          19
        ]
      ];
}

function format_pp_token(_, _$1) {
  throw [
        Caml_builtin_exceptions.assert_failure,
        [
          "format_regression.ml",
          13,
          26
        ]
      ];
}

var pp_infinity = 1000000010;

function advance_loop(state) {
  while(true) {
    var match = peek_queue(state[3]);
    var size = match[0];
    var size$1 = int_of_size(size);
    if (size$1 < 0 && state[2] - state[1] < state[0]) {
      return 0;
    }
    else {
      take_queue(state[3]);
      Caml_curry.app1(format_pp_token(state, size$1 < 0 ? pp_infinity : size$1), match[1]);
      state[1] = match[2] + state[1];
      continue ;
      
    }
  };
}

exports.peek_queue      = peek_queue;
exports.int_of_size     = int_of_size;
exports.take_queue      = take_queue;
exports.format_pp_token = format_pp_token;
exports.pp_infinity     = pp_infinity;
exports.advance_loop    = advance_loop;
/* No side effect */