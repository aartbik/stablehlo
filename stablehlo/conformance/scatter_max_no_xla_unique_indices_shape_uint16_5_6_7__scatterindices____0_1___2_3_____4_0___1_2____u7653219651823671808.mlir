module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[[0, 1], [2, 3]], [[4, 0], [1, 2]]]> : tensor<2x2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>)
    %2 = call @expected() : () -> tensor<5x6x7xui16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui16>, %arg1: tensor<ui16>):
      %5 = stablehlo.maximum %arg0, %arg1 : tensor<ui16>
      stablehlo.return %5 : tensor<ui16>
    }) {indices_are_sorted = false, scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2], index_vector_dim = 2>, unique_indices = true} : (tensor<5x6x7xui16>, tensor<2x2x2xi32>, tensor<5x2x2xui16>) -> tensor<5x6x7xui16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xui16>, tensor<5x6x7xui16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xui16>, tensor<5x2x2xui16>) {
    %0 = stablehlo.constant dense<"0x0100030000000500010004000500040000000100000001000000040000000300010002000400000001000100000000000000000000000000010001000100010001000000030002000000020005000200030003000200020000000000000003000000020001000400030001000A0000000000030004000100010003000200020002000300000003000100020001000600030003000400010000000000030001000000010000000400020005000400030002000000060000000000010003000200030008000300010000000400010002000300040005000300070001000300000000000100010001000100040003000800000002000100030004000100080004000200000001000300030005000100010002000000010003000200030000000400030005000100000003000800040000000100020001000000030003000200000000000000010003000200030004000100030000000000020007000200010002000700030001000100030002000400010004000000010004000100010002000100040003000300030004000600010001000000010001000300010002000400000000000300"> : tensor<5x6x7xui16>
    %1 = stablehlo.constant dense<[[[0, 2], [1, 1]], [[2, 1], [1, 7]], [[2, 2], [1, 3]], [[2, 4], [2, 0]], [[0, 4], [6, 0]]]> : tensor<5x2x2xui16>
    return %0, %1 : tensor<5x6x7xui16>, tensor<5x2x2xui16>
  }
  func.func private @expected() -> tensor<5x6x7xui16> {
    %0 = stablehlo.constant dense<"0x0100030000000500010004000500040000000100000001000000040000000300010002000400000001000100000000000000000000000000010001000100010001000000030002000000020005000200030003000200020000000000000003000000020001000700030001000A0000000000030004000100010003000200020002000300000003000100020001000600030003000400010000000000030001000000010000000400020005000400030002000000060000000000030003000200030008000300010000000400010002000300040005000300070001000300000001000100010001000100040003000800000002000100030004000100080004000200000001000300030005000100010002000000010003000200030000000400030005000100000003000800040000000100020002000000030003000200000000000000010003000200030004000100030000000000020007000200010002000700030001000100030002000400010004000400010004000100010002000100040003000300030006000600010001000000010001000300010002000400000000000300"> : tensor<5x6x7xui16>
    return %0 : tensor<5x6x7xui16>
  }
}