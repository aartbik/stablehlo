// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<1x125xi32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<0> : tensor<1xi64>
    %0:2 = call @inputs() : () -> (tensor<1x125xi32>, tensor<1xi32>)
    %1 = call @expected() : () -> tensor<1x125xi32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1]>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      stablehlo.return %arg1 : tensor<i32>
    }) : (tensor<1x125xi32>, tensor<1xi64>, tensor<1xi32>) -> tensor<1x125xi32>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<1x125xi32>, tensor<1x125xi32>) -> ()
    return %2 : tensor<1x125xi32>
  }
  func.func private @inputs() -> (tensor<1x125xi32> {mhlo.layout_mode = "default"}, tensor<1xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0xFEFFFFFF00000000FDFFFFFFFDFFFFFF05000000FDFFFFFF00000000FEFFFFFFFFFFFFFFFCFFFFFF02000000FDFFFFFF0100000000000000FDFFFFFFFFFFFFFF0500000000000000FEFFFFFFFFFFFFFF05000000050000000300000000000000FEFFFFFF0000000003000000FFFFFFFFFFFFFFFF00000000040000000000000004000000FEFFFFFF0100000003000000FFFFFFFF000000000100000003000000FFFFFFFF0000000001000000FDFFFFFF02000000000000000000000000000000FDFFFFFF05000000FFFFFFFF02000000FEFFFFFF00000000FFFFFFFF0000000000000000FCFFFFFFFDFFFFFF000000000000000005000000FCFFFFFFFFFFFFFF020000000B00000001000000FFFFFFFF00000000FDFFFFFF0500000000000000FCFFFFFF00000000050000000400000003000000FFFFFFFF000000000000000000000000FDFFFFFF0000000000000000FFFFFFFFFCFFFFFFFFFFFFFF000000000500000000000000000000000200000000000000FCFFFFFF06000000FFFFFFFFFFFFFFFF01000000FDFFFFFF00000000FBFFFFFF0200000000000000FBFFFFFFFCFFFFFF0000000000000000FBFFFFFF06000000FFFFFFFF0600000000000000FCFFFFFF0500000003000000FFFFFFFF0000000001000000000000000000000000000000FBFFFFFFFEFFFFFF0700000001000000"> : tensor<1x125xi32>
    %c_0 = stablehlo.constant dense<0> : tensor<1xi32>
    return %c, %c_0 : tensor<1x125xi32>, tensor<1xi32>
  }
  func.func private @expected() -> (tensor<1x125xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x0000000000000000FDFFFFFFFDFFFFFF05000000FDFFFFFF00000000FEFFFFFFFFFFFFFFFCFFFFFF02000000FDFFFFFF0100000000000000FDFFFFFFFFFFFFFF0500000000000000FEFFFFFFFFFFFFFF05000000050000000300000000000000FEFFFFFF0000000003000000FFFFFFFFFFFFFFFF00000000040000000000000004000000FEFFFFFF0100000003000000FFFFFFFF000000000100000003000000FFFFFFFF0000000001000000FDFFFFFF02000000000000000000000000000000FDFFFFFF05000000FFFFFFFF02000000FEFFFFFF00000000FFFFFFFF0000000000000000FCFFFFFFFDFFFFFF000000000000000005000000FCFFFFFFFFFFFFFF020000000B00000001000000FFFFFFFF00000000FDFFFFFF0500000000000000FCFFFFFF00000000050000000400000003000000FFFFFFFF000000000000000000000000FDFFFFFF0000000000000000FFFFFFFFFCFFFFFFFFFFFFFF000000000500000000000000000000000200000000000000FCFFFFFF06000000FFFFFFFFFFFFFFFF01000000FDFFFFFF00000000FBFFFFFF0200000000000000FBFFFFFFFCFFFFFF0000000000000000FBFFFFFF06000000FFFFFFFF0600000000000000FCFFFFFF0500000003000000FFFFFFFF0000000001000000000000000000000000000000FBFFFFFFFEFFFFFF0700000001000000"> : tensor<1x125xi32>
    return %c : tensor<1x125xi32>
  }
}
