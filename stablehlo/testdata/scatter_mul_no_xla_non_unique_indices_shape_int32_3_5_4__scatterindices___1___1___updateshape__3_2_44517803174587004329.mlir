// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x4xi32>, tensor<3x2x4xi32>)
    %2 = call @expected() : () -> tensor<3x5x4xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 2], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 1>} : (tensor<3x5x4xi32>, tensor<2x1xi32>, tensor<3x2x4xi32>) -> tensor<3x5x4xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x4xi32>, tensor<3x5x4xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x4xi32>, tensor<3x2x4xi32>) {
    %0 = stablehlo.constant dense<[[[2, 1, -2, 3], [0, 3, 2, -3], [5, 3, -2, 1], [-4, 0, 0, 0], [-5, -3, -2, -1]], [[7, -2, 2, 1], [2, 0, 0, 3], [2, -3, 1, -7], [2, 2, 0, -2], [0, -5, 6, -2]], [[0, 8, -3, -2], [-4, 8, 0, 0], [-3, -1, -2, 1], [1, 1, 2, 4], [0, -3, 1, 3]]]> : tensor<3x5x4xi32>
    %1 = stablehlo.constant dense<[[[1, 3, -3, 0], [1, -1, 0, -4]], [[0, -1, -3, 2], [-2, 1, 4, 0]], [[0, 0, 1, 0], [-4, 7, -3, 0]]]> : tensor<3x2x4xi32>
    return %0, %1 : tensor<3x5x4xi32>, tensor<3x2x4xi32>
  }
  func.func private @expected() -> tensor<3x5x4xi32> {
    %0 = stablehlo.constant dense<[[[2, 1, -2, 3], [0, -9, 0, 0], [5, 3, -2, 1], [-4, 0, 0, 0], [-5, -3, -2, -1]], [[7, -2, 2, 1], [0, 0, 0, 0], [2, -3, 1, -7], [2, 2, 0, -2], [0, -5, 6, -2]], [[0, 8, -3, -2], [0, 0, 0, 0], [-3, -1, -2, 1], [1, 1, 2, 4], [0, -3, 1, 3]]]> : tensor<3x5x4xi32>
    return %0 : tensor<3x5x4xi32>
  }
}
