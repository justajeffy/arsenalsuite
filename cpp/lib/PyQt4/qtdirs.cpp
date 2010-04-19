#include <QFile>
#include <QLibraryInfo>
#include <QTextStream>

int main(int, char **)
{
    QFile outf("qtdirs.out");

    if (!outf.open(QIODevice::WriteOnly|QIODevice::Truncate|QIODevice::Text))
        return 1;

    QTextStream out(&outf);

    out << QLibraryInfo::location(QLibraryInfo::PrefixPath) << '\n';
    out << QLibraryInfo::location(QLibraryInfo::HeadersPath) << '\n';
    out << QLibraryInfo::location(QLibraryInfo::LibrariesPath) << '\n';
    out << QLibraryInfo::location(QLibraryInfo::BinariesPath) << '\n';
    out << QLibraryInfo::location(QLibraryInfo::DataPath) << '\n';
    out << QLibraryInfo::location(QLibraryInfo::PluginsPath) << '\n';

    out << QT_VERSION << '\n';
    out << QT_EDITION << '\n';

    out << QLibraryInfo::licensee() << '\n';

#if defined(QT_SHARED) || defined(QT_DLL)
    out << "shared\n";
#else
    out << "\n";
#endif

    // Determine which features should be disabled.

#if defined(QT_NO_ACCESSIBILITY)
    out << "PyQt_Accessibility\n";
#endif

#if defined(QT_NO_SESSIONMANAGER)
    out << "PyQt_SessionManager\n";
#endif

#if defined(QT_NO_STATUSTIP)
    out << "PyQt_StatusTip\n";
#endif

#if defined(QT_NO_TOOLTIP)
    out << "PyQt_ToolTip\n";
#endif

#if defined(QT_NO_WHATSTHIS)
    out << "PyQt_WhatsThis\n";
#endif

#if defined(QT_NO_OPENSSL)
    out << "PyQt_OpenSSL\n";
#endif

#if defined(QT_NO_SIZEGRIP)
    out << "PyQt_SizeGrip\n";
#endif

#if !defined(QT3_SUPPORT) || QT_VERSION >= 0x040200
    out << "PyQt_NoPrintRangeBug\n";
#endif

    if (sizeof (qreal) != sizeof (double))
        out << "PyQt_qreal_double\n";

    return 0;
}
