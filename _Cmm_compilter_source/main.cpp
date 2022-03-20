#include "Parser.h"
#include <fstream>
#include <iostream>
#include <sstream>
#include "fstools.h"

bool loadFile(std::string& out, const std::string& fileName)
{
    std::ifstream f;
    f.open(fileName);
    if (!f.is_open()) return false;
    std::stringstream ss;
    ss << f.rdbuf();
    out = ss.str();
    return true;
}

bool compile(const std::string& outputFile, const std::string& inputFile)
{
    try
    {
        bool console = outputFile == ".";

        // Output file
        std::ostringstream oss;
        std::ostream* os = &oss;
        if (console) os = &std::cout;

        // Input file
        std::string inputFileBody;
        if (!loadFile(inputFileBody, inputFile))
        {
            std::cerr << "Can't open file " << inputFile << std::endl;
            return 2;
        }

        // Run
        std::istringstream iss(inputFileBody);
        Scanner s(iss);
        s.setFilename(inputFile);
        s.setSourceForGetLine(inputFile, inputFileBody);
        Parser parser(s, *os);
        try {
            int r = parser.parse();
            if (r != 0) throw "Parser error " + std::to_string(r);
        }
        catch(const char* e)
        {
            throw s.filename() + ":" + std::to_string(s.lineNr()) + ": " + e;
        }
        catch(std::string e)
        {
            throw s.filename() + ":" + std::to_string(s.lineNr()) + ": " + e;
        }

        parser.writeFooter();

        // Output file
        if (!console)
        {
            std::ofstream out;
            out.open(outputFile);
            if (!out.is_open())
            {
                std::cerr << "Can't create file " << outputFile << std::endl;
                return false;
            }
            out << oss.str();
        }
    }
    catch(const char* e)
    {
        std::cerr << e << std::endl;
        return false;
    }
    catch(std::string e)
    {
        std::cerr << e << std::endl;
        return false;
    }
    return true;
}

int main(int argc, char** argv)
{
    if (argc != 3)
    {
        std::cerr << "CMM compiler (c) 15-11-2019 Alemorf" << std::endl
                  << "Syntax: " << argv[0] << " output_file input_file" << std::endl
                  << std::endl;
        return 1;
    }

    if (!compile(argv[1], argv[2]))
        return 2;

    return 0;

}

