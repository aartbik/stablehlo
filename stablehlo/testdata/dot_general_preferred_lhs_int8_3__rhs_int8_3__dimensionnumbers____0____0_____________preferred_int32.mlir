// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<3xi8>, tensor<3xi8>)
    %1 = call @expected() : () -> tensor<i32>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_contracting_dimensions = [0], rhs_contracting_dimensions = [0]>} : (tensor<3xi8>, tensor<3xi8>) -> tensor<i32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<i32>, tensor<i32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3xi8>, tensor<3xi8>) {
    %0 = stablehlo.constant dense<[3, 0, 0]> : tensor<3xi8>
    %1 = stablehlo.constant dense<[0, -3, -5]> : tensor<3xi8>
    return %0, %1 : tensor<3xi8>, tensor<3xi8>
  }
  func.func private @expected() -> tensor<i32> {
    %0 = stablehlo.constant dense<0> : tensor<i32>
    return %0 : tensor<i32>
  }
}
