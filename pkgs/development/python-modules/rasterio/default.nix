{ lib
, stdenv
, affine
, attrs
, boto3
, buildPythonPackage
, click
, click-plugins
, cligj
, certifi
, cython
, fetchFromGitHub
, gdal
, hypothesis
, matplotlib
, ipython
, numpy
, packaging
, pytest-randomly
, pytestCheckHook
, pythonOlder
, setuptools
, shapely
, snuggs
}:

buildPythonPackage rec {
  pname = "rasterio";
  version = "1.3.6";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rasterio";
    repo = "rasterio";
    rev = "refs/tags/${version}";
    hash = "sha256-C5jenXcONNYiUNa5GQ7ATBi8m0JWvg8Dyp9+ejGX+Fs=";
  };

  nativeBuildInputs = [
    cython
    gdal
  ];

  propagatedBuildInputs = [
    affine
    attrs
    click
    click-plugins
    cligj
    certifi
    numpy
    snuggs
    setuptools
  ];

  passthru.optional-dependencies = {
    ipython = [
      ipython
    ];
    plot = [
      matplotlib
    ];
    s3 = [
      boto3
    ];
  };

  nativeCheckInputs = [
    hypothesis
    packaging
    pytest-randomly
    pytestCheckHook
    shapely
  ];

  pytestFlagsArray = [
    "-m 'not network'"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_reproject_error_propagation"
  ];

  pythonImportsCheck = [
    "rasterio"
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/rio --version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "Python package to read and write geospatial raster data";
    homepage = "https://rasterio.readthedocs.io/";
    changelog = "https://github.com/rasterio/rasterio/blob/${version}/CHANGES.txt";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
  };
}
