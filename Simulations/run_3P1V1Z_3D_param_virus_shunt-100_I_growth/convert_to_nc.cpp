#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>
#include <string>
#include <netcdf>

using namespace std;
using namespace netCDF;

void swap_endian(float &f) {
    char *ptr = reinterpret_cast<char*>(&f);
    std::reverse(ptr, ptr + 4);
}

int main(int argc, char* argv[]) {
    if (argc < 5) {
        cout << "Usage: ./convert <prefix> <NX> <NY> <NR> <NFELDS>" << endl;
        return 1;
    }

    string prefix = argv[1];
    int nx = stoi(argv[2]);
    int ny = stoi(argv[3]);
    int nr = stoi(argv[4]);
    int nfields = (argc > 5) ? stoi(argv[5]) : 1; 

    string input_path = prefix + ".data";
    string output_path = prefix + ".nc";

    size_t total_elements = (size_t)nfields * nr * ny * nx;
    vector<float> data(total_elements);

    ifstream is(input_path, ios::binary);
    if (!is) {
        cerr << "Error: Cant open " << input_path << endl;
        return 1;
    }
    is.read(reinterpret_cast<char*>(data.data()), total_elements * sizeof(float));
    is.close();

    for (float &val : data) swap_endian(val);

    try {
        NcFile nc(output_path, NcFile::replace);
        NcDim dF = nc.addDim("Field", nfields);
        NcDim dZ = nc.addDim("Z", nr);
        NcDim dY = nc.addDim("Y", ny);
        NcDim dX = nc.addDim("X", nx);

        NcVar var = nc.addVar("data", ncFloat, {dF, dZ, dY, dX});
        var.putVar(data.data());
        cout << "Converted " << input_path << " (" << nfields << " fields)" << endl;
    } catch (exceptions::NcException& e) {  // Added "exceptions::" prefix
        cerr << "NetCDF Error: " << e.what() << endl;
        return 1;
    }
    return 0;
}
