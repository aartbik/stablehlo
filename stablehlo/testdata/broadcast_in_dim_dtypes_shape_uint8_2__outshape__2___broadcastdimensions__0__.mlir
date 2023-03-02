// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<2xui8>
    %1 = call @expected() : () -> tensor<2xui8>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<2xui8>, tensor<2xui8>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<2xui8> {
    %0 = stablehlo.constant dense<[2, 3]> : tensor<2xui8>
    return %0 : tensor<2xui8>
  }
  func.func private @expected() -> tensor<2xui8> {
    %0 = stablehlo.constant dense<[2, 3]> : tensor<2xui8>
    return %0 : tensor<2xui8>
  }
}