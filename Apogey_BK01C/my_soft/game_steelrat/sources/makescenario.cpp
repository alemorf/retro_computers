// Steelrat scenario compiler
// 2014-07-25 Version for Windows compilers, Alemorf aleksey.f.morozov@gmail.com
// 2021-01-05 Version for Linux compilers, Alemorf aleksey.f.morozov@gmail.com

#include <stdexcept>
#include <string>
#include <string_view>
#include <iostream>
#include <vector>
#include <map>
#include "fstools.h"
#include <assert.h>

static char utf8ToKoi7Chars(unsigned input)
{
    char result = 0;
    switch (input)
    {
        case 0x044EU: result = 0x60; break;
        case 0x0430U: result = 0x61; break;
        case 0x0431U: result = 0x62; break;
        case 0x0446U: result = 0x63; break;
        case 0x0434U: result = 0x64; break;
        case 0x0435U: result = 0x65; break;
        case 0x0444U: result = 0x66; break;
        case 0x0433U: result = 0x67; break;
        case 0x0445U: result = 0x68; break;
        case 0x0438U: result = 0x69; break;
        case 0x0439U: result = 0x6A; break;
        case 0x043AU: result = 0x6B; break;
        case 0x043BU: result = 0x6C; break;
        case 0x043CU: result = 0x6D; break;
        case 0x043DU: result = 0x6E; break;
        case 0x043EU: result = 0x6F; break;
        case 0x043FU: result = 0x70; break;
        case 0x044FU: result = 0x71; break;
        case 0x0440U: result = 0x72; break;
        case 0x0441U: result = 0x73; break;
        case 0x0442U: result = 0x74; break;
        case 0x0443U: result = 0x75; break;
        case 0x0436U: result = 0x76; break;
        case 0x0432U: result = 0x77; break;
        case 0x044CU: result = 0x78; break;
        case 0x044BU: result = 0x79; break;
        case 0x0437U: result = 0x7A; break;
        case 0x0448U: result = 0x7B; break;
        case 0x044DU: result = 0x7C; break;
        case 0x0449U: result = 0x7D; break;
        case 0x0447U: result = 0x7E; break;
        case 0x044AU: result = 0x78; break;
        case 0x042EU: result = 0x60; break;
        case 0x0410U: result = 0x61; break;
        case 0x0411U: result = 0x62; break;
        case 0x0426U: result = 0x63; break;
        case 0x0414U: result = 0x64; break;
        case 0x0415U: result = 0x65; break;
        case 0x0424U: result = 0x66; break;
        case 0x0413U: result = 0x67; break;
        case 0x0425U: result = 0x68; break;
        case 0x0418U: result = 0x69; break;
        case 0x0419U: result = 0x6A; break;
        case 0x041AU: result = 0x6B; break;
        case 0x041BU: result = 0x6C; break;
        case 0x041CU: result = 0x6D; break;
        case 0x041DU: result = 0x6E; break;
        case 0x041EU: result = 0x6F; break;
        case 0x041FU: result = 0x70; break;
        case 0x042FU: result = 0x71; break;
        case 0x0420U: result = 0x72; break;
        case 0x0421U: result = 0x73; break;
        case 0x0422U: result = 0x74; break;
        case 0x0423U: result = 0x75; break;
        case 0x0416U: result = 0x76; break;
        case 0x0412U: result = 0x77; break;
        case 0x042CU: result = 0x78; break;
        case 0x042BU: result = 0x79; break;
        case 0x0417U: result = 0x7A; break;
        case 0x0428U: result = 0x7B; break;
        case 0x042DU: result = 0x7C; break;
        case 0x0429U: result = 0x7D; break;
        case 0x0427U: result = 0x7E; break;
        case 0x042AU: result = 0x78; break;
        default:      result = 0;    break;
    }
    return result;
}

static std::string utf8ToKoi7(std::string_view input)
{
    std::string output;
    output.resize(input.size());
    std::string::size_type outPos = 0U;
    for(auto inputCursor = input.begin(); inputCursor != input.end();)
    {
        char prefix = *inputCursor;
        inputCursor++;

        if ((prefix & 0x80) == 0)
        {
            output[outPos] = prefix;
            outPos++;
            continue;
        }

        if (((~prefix) & 0x20) != 0)
        {
            char suffix = *inputCursor;
            inputCursor++;
            if (suffix == 0)
            {
                throw std::runtime_error("Unsupported unicode char");
            }
            int first5bit = prefix & 0x1F;
            first5bit <<= 6;
            int sec6bit = suffix & 0x3F;
            int unicode_char = first5bit + sec6bit;

            char c = (char)utf8ToKoi7Chars(unicode_char);
            if (c == 0)
            {
                throw std::runtime_error("Unsupported unicode char");
            }
            output[outPos] = c;
            outPos++;
            continue;
        }

        throw std::runtime_error("Unsupported unicode char");
    }

    output.resize(outPos);
    return output;
}

static bool toUnsigned(unsigned& output, std::string_view input)
{
    bool result = true;
    const unsigned radix = 10U;
    output = 0U;
    for(char c : input)
    {
        if ((c < '0') || (c > '9')) // Not number
        {
            result = false;
            break;
        }
        unsigned next = (output * radix) + static_cast<unsigned>(c - '0');
        if (next < output) // Overflow
        {
            result = false;
            break;
        }
        output = next;
    }
    return result;
}

static std::string align(std::string_view input, unsigned padding, unsigned& lines)
{
    // Remove spaces
    std::string output;
    output.reserve(input.size());
    bool insertSpace = false;
    for(char c : input)
    {
        if ((c == '\r') || (c == '\n') || (c == ' ') || (c == '\t'))
        {
            insertSpace = true;
            continue;
        }
        if (insertSpace && !output.empty())
        {
            output.push_back(' ');
        }
        output.push_back(c);
        insertSpace = false;
    }

    // Insert EOL
    static const unsigned screenWidth = 58;
    unsigned len = padding;
    unsigned prevLen = padding;
    char* prevSpace = nullptr;
    lines += 1U;
    for(auto& c : output)
    {
        len++;
        if (c == ' ')
        {
            if (len > screenWidth)
            {
                len -= prevLen + 1U;
                if (prevSpace != nullptr)
                {
                    *prevSpace = 10;
                    lines++;
                }
            }
            prevSpace = &c;
            prevLen = len;
        }
    }
    if (len > screenWidth)
    {
        if (prevSpace != nullptr)
        {
            *prevSpace = 10;
            lines++;
        }
    }

    return output;
}

// Consts
static const char textTerminator = 0;
static const char pageTerminator = char(0xFF);
static const unsigned maxPageNumber1 = 253;
static const unsigned gameOverPageNumber = 253;
static const unsigned nextChapterPageNumber = 254;
static const unsigned answerPadding = 2U;

static std::string processPage(std::string_view page, std::map<unsigned, unsigned>& pageNumbers)
{
    // Code
    std::string out;
    std::string::size_type pos = 0U;
    unsigned currentPadding = 0U;
    unsigned lines = 0U;
    for(;;)
    {
        auto pos1 = page.find("{", pos);
        if (pos1 == page.npos)
        {
            if (pos != page.size())
            {
                out += align(utf8ToKoi7(page.substr(pos)), currentPadding, lines);
            }
            // Value is never used, if "currentPadding = answerPadding;"
            out.push_back(textTerminator); // Text terminator
            break;
        }
        auto pos2 = page.find("}", pos1);
        if (pos2 == page.npos)
        {
            throw std::runtime_error("{ not closed");
        }
        unsigned pageNumber = 0U;
        auto labelText = page.substr(pos1 + 1, pos2 - pos1 - 1);
        if (labelText == "NEXT")
        {
            pageNumber = nextChapterPageNumber;
        }
        else if (labelText == "GAMEOVER")
        {
            pageNumber = gameOverPageNumber;
        }
        else if (toUnsigned(pageNumber, labelText))
        {
            auto i = pageNumbers.find(pageNumber);
            if (i == pageNumbers.end())
            {
                throw std::runtime_error("Unknown label (" + std::to_string(pageNumber) + ")");
            }
            pageNumber = i->second;
        }
        else
        {
            throw std::runtime_error("Incorrect number (" + std::string(labelText) + ")");
        }
        out += align(utf8ToKoi7(page.substr(pos, pos1 - pos)), currentPadding, lines);
        lines++;
        currentPadding = answerPadding;
        out.push_back(textTerminator); // Text terminator
        out.push_back(static_cast<char>(pageNumber));
        pos = pos2 + 1U;
    }
    if (lines > 21u)
    {
        throw std::runtime_error(std::string("Too many lines ") + std::string(page));
    }
    out.push_back(pageTerminator); // Page terminator
    return out;
}

static std::string_view trim(std::string_view str)
{
    std::string_view::size_type l = 0U;
    std::string_view::size_type r = str.size();
    while ((l < r) && (str[l] == ' '))
    {
        l++;
    }
    while ((r > 0U) && (str[r - 1U] == ' '))
    {
        r--;
    }
    return str.substr(l, r - l);
}

static void convert(const char* outputFileName, const char* inputFileName)
{
    assert(outputFileName != nullptr);
    assert(inputFileName != nullptr);

    // Load file
    std::string fileContents;
    loadFile(inputFileName, [&fileContents](size_t fileSize)
    {
        fileContents.resize(fileSize);
        return fileContents.data();
    });

    // Split file
    std::map<unsigned, unsigned> pageNumbers;
    std::vector<std::string_view> pages;
    {
        unsigned pageCounter = 0U;
        std::string_view::size_type pos = 0U;
        std::string_view::size_type start = 0U;
        for (;;)
        {
            auto pos1 = fileContents.find("\n", pos);

            std::string_view lineText = trim(std::string_view(fileContents).substr(pos,
                                               (pos1 == fileContents.npos) ? fileContents.npos : (pos1 - pos)));

            lineText = trim(lineText);

            if (!lineText.empty())
            {
                unsigned numberInLine = 0;
                if (toUnsigned(numberInLine, lineText))
                {
                    if (pageCounter > 0U)
                    {
                        pages.push_back(std::string_view(fileContents).substr(start, pos - start));
                    }
                    pageNumbers[numberInLine] = pageCounter;
                    pageCounter++;
                    start = pos1 + 1U;
                }
            }

            if (pos1 == fileContents.npos)
            {
                break;
            }
            pos = pos1 + 1U;
        }

        if (pageCounter > 0U)
        {
            pages.push_back(std::string_view(fileContents).substr(start));
        }
    }

    // Convert text
    std::string out;
    for(std::string_view page : pages)
    {
        out.append(processPage(page, pageNumbers));
    }
    out.push_back(pageTerminator);

    // Save file
    saveFile(outputFileName, out.data(), out.size());
}

int main(int argc, const char** argv)
{
    assert(argv != nullptr);
    assert(argv[0] != nullptr);
    assert(argc > 0);

    int result = 1;
    try
    {
        if (argc != 3)
        {
            throw std::runtime_error(std::string("Usage: ") + argv[0] + " <output file name> <input file name>");
        }

        assert(argv[1] != nullptr);
        assert(argv[2] != nullptr);
        convert(argv[1], argv[2]);
        result = 0;
    }
    catch(const std::exception& e)
    {
        std::cerr << argv[0] << ": " << e.what() << std::endl;
        result = 1;
    }
    catch(...)
    {
        std::cerr << argv[0] << ": Unknown exception" << std::endl;
        result = 1;
    }
    return result;
}
