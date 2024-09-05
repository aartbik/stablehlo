// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<3x4x5xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<3x4x5xf32>
    %1 = call @expected() : () -> tensor<3x4x5xf32>
    %2 = stablehlo.reverse %0, dims = [2, 0, 1] : tensor<3x4x5xf32>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<3x4x5xf32>, tensor<3x4x5xf32>) -> ()
    return %2 : tensor<3x4x5xf32>
  }
  func.func private @inputs() -> (tensor<3x4x5xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[[-4.16123152, 1.03798163, 1.545964, -3.34564614, -1.29558265], [-1.25220227, 2.61347604, 4.83895779, 6.6032381, -1.46145332], [-1.02181327, 0.830060303, -2.26763988, 3.14276481, -5.53717566], [-6.71528673, 4.17442322, -1.79220343, -0.606934905, -2.30312443]], [[-4.45187521, -1.71513712, -4.07779169, -1.86085105, -4.49964476], [1.99716985, 1.28841817, -0.0114714811, -2.74107265, 2.15327168], [2.746320e+00, -0.179251179, -4.4955163, -1.03507566, 0.969574689], [-2.34100795, -2.87235856, 2.47205973, 0.160662219, 0.0798297449]], [[1.22375059, -1.9826901, -3.56181765, -0.458005041, 4.21031904], [-0.790890514, -5.68564939, -2.82658482, -1.04863465, 0.388497621], [5.7634511, -1.05089259, -4.09291315, 6.24962615, -0.579899192], [2.53630376, 5.1565814, 2.40977168, 0.946334898, 2.18487072]]]> : tensor<3x4x5xf32>
    return %cst : tensor<3x4x5xf32>
  }
  func.func private @expected() -> (tensor<3x4x5xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[[2.18487072, 0.946334898, 2.40977168, 5.1565814, 2.53630376], [-0.579899192, 6.24962615, -4.09291315, -1.05089259, 5.7634511], [0.388497621, -1.04863465, -2.82658482, -5.68564939, -0.790890514], [4.21031904, -0.458005041, -3.56181765, -1.9826901, 1.22375059]], [[0.0798297449, 0.160662219, 2.47205973, -2.87235856, -2.34100795], [0.969574689, -1.03507566, -4.4955163, -0.179251179, 2.746320e+00], [2.15327168, -2.74107265, -0.0114714811, 1.28841817, 1.99716985], [-4.49964476, -1.86085105, -4.07779169, -1.71513712, -4.45187521]], [[-2.30312443, -0.606934905, -1.79220343, 4.17442322, -6.71528673], [-5.53717566, 3.14276481, -2.26763988, 0.830060303, -1.02181327], [-1.46145332, 6.6032381, 4.83895779, 2.61347604, -1.25220227], [-1.29558265, -3.34564614, 1.545964, 1.03798163, -4.16123152]]]> : tensor<3x4x5xf32>
    return %cst : tensor<3x4x5xf32>
  }
}