import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'prayer_service.dart';
import 'ramadhan_detail_page.dart';
import 'ramadhan_article_page.dart';

class RamadhanPage extends StatefulWidget {
  const RamadhanPage({super.key});

  @override
  State<RamadhanPage> createState() => _RamadhanPageState();
}

class _RamadhanPageState extends State<RamadhanPage> with SingleTickerProviderStateMixin {
  final PrayerService _prayerService = PrayerService();
  late TabController _tabController;

  String _selectedProvince = 'Jawa Timur';
  String _selectedCity = 'Kab. Bangkalan';
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  List<String> _provinces = [];
  List<String> _cities = [];
  Map<String, dynamic>? _scheduleData;
  bool _isLoading = true;
  String _selectedCategory = 'Kumpulan Doa';

  Timer? _countdownTimer;
  String _countdownLabel = 'Memuat jadwal...';
  String _countdownTime = '00:00:00';

  static const Color primaryTeal = Color(0xFF0C5441);
  static const Color accentTeal = Color(0xFF13A884);
  static const Color lightTeal = Color(0xFFE8F5F1);
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color backgroundLight = Color(0xFFF9FBFB);

  final List<String> _monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  final List<Map<String, dynamic>> _artikelMenu = [
    {
      'title': 'Waktu Sahur dalam Lintas Mazhab',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Sahur adalah salah satu sunnah muakkad dalam ibadah puasa yang sangat dianjurkan oleh Rasulullah SAW. Selain memberikan kekuatan fisik untuk menjalani puasa seharian, di dalam sahur juga terdapat keberkahan yang besar. Sebagaimana sabda beliau:',
        },
        {
          'type': 'arabic',
          'content': 'تَسَحَّرُوا فَإِنَّ فِي السَّحُورِ بَرَكَةً',
          'latin': 'Tasahharû fa inna fîs sahûri barakah',
          'translation': '"Sahurlah kalian, karena sesungguhnya dalam sahur itu terdapat keberkahan." (HR. Bukhari & Muslim)',
        },
        {
          'type': 'text',
          'content': 'Secara umum, seluruh ulama sepakat bahwa sahur dilakukan pada sepertiga malam terakhir hingga terbitnya fajar shadiq (waktu Subuh), sebagaimana firman Allah Ta\'ala:',
        },
        {
          'type': 'arabic',
          'content': 'وَكُلُوا وَاشْرَبُوا حَتَّىٰ يَتَبَيَّنَ لَكُمُ الْخَيْطُ الْأَبْيَضُ مِنَ الْخَيْطِ الْأَسْوَدِ مِنَ الْفَجْرِ',
          'latin': 'Wa kulû wasyrabû hattâ yatabayyana lakumul khaithul abyadlu minal khaithil aswadi minal fajr',
          'translation': '"Dan makan minumlah hingga terang bagimu benang putih dari benang hitam, yaitu fajar." (QS. Al-Baqarah: 187)',
        },
        {
          'type': 'text',
          'content': 'Namun, terdapat beberapa pandangan dari berbagai mazhab mengenai batasan awal dan akhir kesunnahan sahur:\n\n1. Mazhab Syafi\'i\nMenurut pandangan ulama Syafi\'iyah, waktu sahur dimulai sejak pertengahan malam (tengah malam) hingga terbitnya fajar shadiq. Mengakhirkan sahur sangat dianjurkan (sunnah) selama tidak sampai menimbulkan keraguan apakah fajar sudah terbit atau belum. Waktu ideal untuk berhenti makan dan minum menurut mazhab ini adalah pada waktu "Imsak" (sekitar jarak membaca 50 ayat Al-Qur\'an sebelum adzan Subuh) sebagai langkah kehati-hatian (ihtiyath).\n\n2. Mazhab Hanafi\nDalam mazhab Hanafi, waktu utama untuk sahur adalah pada seperenam malam yang terakhir sebelum fajar shadiq. Mereka juga sangat menganjurkan untuk mengakhirkan sahur (ta\'khirus sahur) hingga menjelang terbit fajar, selama masih yakin fajar belum menyingsing.\n\n3. Mazhab Maliki\nUlama dari kalangan Malikiyah berpandangan bahwa sahur sebaiknya dilakukan di sepertiga malam terakhir. Mengakhirkan sahur merupakan sebuah keutamaan. Batas akhirnya adalah keyakinan terbitnya fajar shadiq. Jika seseorang ragu apakah fajar sudah terbit atau belum, makruh hukumnya untuk terus makan dan minum.\n\n4. Mazhab Hambali\nSerupa dengan mayoritas ulama, mazhab Hambali menyepakati bahwa waktu sahur adalah bagian akhir dari malam hingga fajar shadiq terbit. Dianjurkan untuk mengakhirkannya, sama halnya dengan menyegerakan berbuka.\n\nKesimpulan\nMeski terdapat sedikit perbedaan dalam menentukan kapan waktu awal dimulainya sahur, keempat mazhab besar sepakat bahwa waktu paling utama (afdhal) untuk sahur adalah dengan mengakhirkannya hingga menjelang waktu Subuh. Tradisi "Imsak" sejalan dengan anjuran kehati-hatian agar kita tidak terlewat makan hingga fajar telah benar-benar terbit.\n\nWallahu a\'lam bish-shawab.',
        }
      ]
    },
    {
      'title': 'Niat Puasa dalam Tinjauan Empat Mazhab',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Niat adalah rukun utama dalam puasa. Tanpa niat, ibadah puasa seseorang tidak dianggap sah secara syariat. Hal ini didasarkan pada sabda Rasulullah SAW:',
        },
        {
          'type': 'arabic',
          'content': 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ',
          'latin': 'Innamal a\'mâlu bin niyyât',
          'translation': '"Sesungguhnya segala perbuatan itu bergantung pada niatnya." (HR. Bukhari & Muslim)',
        },
        {
          'type': 'text',
          'content': 'Khusus untuk puasa fardhu seperti puasa Ramadhan, ada aturan spesifik mengenai kapan dan bagaimana niat itu harus diucapkan atau diyakini di dalam hati. Rasulullah SAW juga menegaskan dalam hadis lain:',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ لَمْ يُبَيِّتِ الصِّيَامَ قَبْلَ الْفَجْرِ فَلَا صِيَامَ لَهُ',
          'latin': 'Man lam yubayyitish shiyâma qablal fajri falâ shiyâma lah',
          'translation': '"Barangsiapa yang tidak berniat puasa di malam hari sebelum fajar, maka tidak ada puasa baginya." (HR. Abu Dawud, Tirmidzi & Nasa\'i)',
        },
        {
          'type': 'text',
          'content': 'Meskipun kewajiban berniat disepakati oleh seluruh ulama, para imam madzhab memiliki pandangan dan rincian yang berbeda terkait pelaksanaannya:\n\n1. Mazhab Syafi\'i\nDalam pandangan ulama Syafi\'iyah, niat puasa Ramadhan wajib dilakukan pada setiap malam harinya (taqrir / tabyitun niyah) sebelum fajar shadiq terbit. Karena puasa setiap hari dianggap ibadah yang mandiri. Selain itu, niat juga harus menyebutkan secara spesifik (ta\'yin) bahwa ia berniat puasa fardhu bulan Ramadhan.\n\n2. Mazhab Maliki\nUlama Malikiyah memberikan kelonggaran di mana seseorang diperbolehkan berniat di malam pertama bulan Ramadhan untuk puasa sebulan penuh sekaligus. Hal ini mempermudah jika sewaktu-waktu seseorang lupa berniat di malam-malam berikutnya. Namun, jika puasanya terputus karena udzur (seperti sakit atau haid), maka ia wajib memperbarui niatnya saat akan berpuasa kembali.\n\n3. Mazhab Hanafi\nMenurut pandangan Abu Hanifah, niat puasa Ramadhan boleh dilakukan sejak malam hari, dan batas waktunya memanjang hingga sebelum pertengahan siang (zawal), asalkan sejak fajar ia belum melakukan hal-hal yang membatalkan puasa.\n\n4. Mazhab Hambali\nUlama Hambali sependapat dengan mazhab Syafi\'i bahwa niat wajib diperbarui setiap malam sebelum terbitnya fajar. Puasa setiap harinya dinilai sebagai kewajiban yang berdiri sendiri, sehingga butuh niatnya masing-masing.\n\nKesimpulan\nMengingat ketatnya syarat niat di mazhab Syafi\'i, banyak ulama di Indonesia yang menganjurkan agar pada malam pertama Ramadhan, kita berniat puasa sebulan penuh dengan bertaqlid (mengikuti) mazhab Maliki. Hal ini bertujuan sebagai antisipasi jika di pertengahan bulan kita lupa mengucapkan niat puasa di malam hari. Tentu saja, kita tetap dianjurkan untuk terus berniat setiap malamnya.\n\nWallahu a\'lam bish-shawab.',
        }
      ]
    },
    {
      'title': 'Thibbun Nabawi: I\'tikaf untuk Perkuat Imunitas',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Thibbun Nabawi (Pengobatan ala Nabi) mencakup pendekatan preventif (pencegahan) dan kuratif (penyembuhan) baik dari sisi fisik maupun spiritual. Salah satu ibadah di bulan Ramadhan yang memiliki dimensi pengobatan spiritual dan berdampak pada fisik adalah i\'tikaf, terutama pada 10 hari terakhir Ramadhan. Rasulullah SAW bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ اِعْتَكَفَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ',
          'latin': 'Man i\'takafa îmânan wahtisâban ghufira lahu mâ taqaddama min dzanbih',
          'translation': '"Barangsiapa yang beri\'tikaf karena iman dan mengharap pahala, maka akan diampuni dosanya yang telah lalu." (HR. Dailami)',
        },
        {
          'type': 'text',
          'content': 'Secara terminologi fikih, i\'tikaf adalah berdiam diri di masjid dengan niat tertentu. Namun dari perspektif kesehatan modern dan Thibbun Nabawi, i\'tikaf memiliki manfaat luar biasa untuk memperkuat imunitas tubuh melalui beberapa mekanisme:\n\n1. Manajemen Stres (Psychoneuroimmunology)\nI\'tikaf memutus rantai stres kehidupan duniawi. Dengan berfokus pada dzikir, membaca Al-Qur\'an, dan tafakur di lingkungan masjid yang tenang, sistem saraf parasimpatik menjadi lebih aktif. Ini menurunkan hormon kortisol (hormon stres) secara signifikan. Penurunan stres kronis telah terbukti secara ilmiah dapat meningkatkan sel darah putih dan fungsi sistem kekebalan tubuh.\n\n2. Detoksifikasi Digital dan Mental\nSelama i\'tikaf, umat Islam dianjurkan untuk menjauhi perkara yang tidak bermanfaat, termasuk mengurangi interaksi berlebihan dengan gadget dan media sosial. Detoksifikasi ini mengistirahatkan kelelahan mental (mental fatigue), mengembalikan kejernihan pikiran, dan meningkatkan kualitas tidur di waktu-waktu yang diizinkan.\n\n3. Kedamaian Spiritual (Tumaninah)\nKondisi hati yang damai dan berserah diri (tawakkal) memunculkan hormon endorfin dan serotonin yang bertugas menciptakan rasa bahagia dan rileks. Tumaninah atau ketenangan batin ini adalah pilar utama dalam Thibbun Nabawi yang sangat memengaruhi ketahanan fisik terhadap penyakit. Keresahan dan kesedihan adalah sumber penyakit, sedangkan tumaninah adalah sumber penyembuhan.\n\n4. Keteraturan Pola Makan\nBiasanya, orang yang beri\'tikaf sangat menjaga asupan makanan saat berbuka dan sahur agar tidak malas beribadah. Pola makan yang tidak berlebihan (cukup untuk menegakkan tulang punggung) sangat sesuai dengan kaidah Thibbun Nabawi. Perut yang tidak terlalu kenyang akan mengurangi beban organ pencernaan dan meningkatkan energi untuk detoksifikasi sel.\n\nKesimpulan\nI\'tikaf bukan hanya sekadar ibadah ritual untuk mengejar Lailatul Qadar. Dari sudut pandang Thibbun Nabawi, i\'tikaf adalah proses \'karantina spiritual\' yang efektif untuk me-reboot sistem kekebalan tubuh, menurunkan tingkat stres, dan mencapai puncak kesehatan holistik (fisik dan mental) sebelum menyambut hari raya Idul Fitri.\n\nWallahu a\'lam bish-shawab.',
        }
      ]
    },
    {
      'title': 'Ramadhan dan Efek Kesehatan untuk Keharmonisan Pasutri',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Puasa Ramadhan seringkali dikonotasikan sebagai bulan yang penuh pembatasan, termasuk menahan diri dari hubungan suami istri (pasutri) di siang hari. Padahal, dari kacamata medis dan psikologis, pembatasan sementara ini justru memberikan dampak positif yang signifikan bagi keharmonisan pasutri, baik secara fisik maupun emosional. Sebagaimana firman Allah:',
        },
        {
          'type': 'arabic',
          'content': 'أُحِلَّ لَكُمْ لَيْلَةَ الصِّيَامِ الرَّفَثُ إِلَىٰ نِسَائِكُمْ ۚ هُنَّ لِبَاسٌ لَكُمْ وَأَنْتُمْ لِبَاسٌ لَهُنَّ',
          'latin': 'Uhilla lakum lailatash shiyâmir rafatsu ilâ nisâ-ikum, hunna libâsul lakum wa antum libâsul lahun',
          'translation': '"Dihalalkan bagi kamu pada malam hari bulan puasa bercampur dengan istri-istrimu; mereka adalah pakaian bagimu, dan kamu pun adalah pakaian bagi mereka." (QS. Al-Baqarah: 187)',
        },
        {
          'type': 'text',
          'content': 'Di balik larangan berhubungan intim di siang hari dan dihalalkannya di malam hari, terdapat hikmah kesehatan yang memperkuat ikatan pasutri:\n\n1. Rest and Reset (Masa Jeda Fisik)\nMenahan diri di siang hari memberikan waktu istirahat (jeda) bagi organ reproduksi dan sistem endokrin. Proses "puasa" seksual sementara ini terbukti secara ilmiah dapat mereset sensitivitas reseptor dopamin di otak. Akibatnya, ketika pasutri kembali berhubungan di malam hari, kualitas keintiman dan tingkat kepuasan (arousal) akan meningkat tajam layaknya pasangan yang baru menikah (honeymoon effect).\n\n2. Detoksifikasi Emosional dan Pengendalian Ego\nPuasa melatih seseorang untuk mengendalikan hawa nafsu dan amarah. Dalam kehidupan rumah tangga, pengendalian ego adalah kunci keharmonisan. Pasutri yang terbiasa menahan lapar, haus, dan emosi di siang hari cenderung lebih sabar dan empatik terhadap pasangannya. Hal ini mengurangi frekuensi konflik rumah tangga.\n\n3. Peningkatan Hormon Testosteron secara Alami\nBeberapa studi menunjukkan bahwa puasa intermiten (seperti puasa Ramadhan) dapat meningkatkan sensitivitas insulin dan merangsang produksi Luteinizing Hormone (LH), yang pada gilirannya dapat menstabilkan atau bahkan meningkatkan kadar testosteron pada pria setelah berbuka puasa. Kondisi fisik yang lebih bugar setelah detoksifikasi tubuh akan memengaruhi vitalitas.\n\n4. Membangun Keintiman Spiritual (Spiritual Intimacy)\nKeharmonisan pasutri tidak hanya dibangun di atas ranjang. Ramadhan memberikan ruang bagi pasutri untuk membangun keintiman spiritual, seperti shalat Tarawih bersama, tadarus Al-Qur\'an, dan bangun bersama untuk sahur. Ikatan spiritual yang kuat ini akan beresonansi pada kedalaman cinta kasih (mawaddah wa rahmah) dalam hubungan fisik.\n\nKesimpulan\nBulan Ramadhan bukanlah penghalang bagi keharmonisan pasutri, melainkan sebuah madrasah untuk me-recharge kualitas hubungan. Jeda di siang hari dan kebersamaan di malam hari menciptakan ritme biologis dan psikologis yang baru, yang pada akhirnya menguatkan cinta dan kesehatan reproduksi.',
        }
      ]
    },
    {
      'title': 'Tarawih sebagai Sarana Qiyamul Lail di Bulan Ramadhan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Shalat Tarawih adalah salah satu ibadah khas yang hanya ada di bulan Ramadhan. Secara esensial, Tarawih adalah bagian dari Qiyamul Lail (shalat malam) yang dilaksanakan di awal malam setelah shalat Isya. Rasulullah SAW bersabda mengenai keutamaannya:',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ قَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ',
          'latin': 'Man qâma ramadlâna îmânan wahtisâban ghufira lahu mâ taqaddama min dzanbih',
          'translation': '"Barangsiapa yang melaksanakan qiyam Ramadhan (shalat Tarawih) karena iman dan mengharap pahala dari Allah, maka dosa-dosanya yang telah lalu akan diampuni." (HR. Bukhari & Muslim)',
        },
        {
          'type': 'text',
          'content': 'Ulama sepakat bahwa Tarawih hukumnya sunnah muakkadah (sangat dianjurkan) bagi laki-laki maupun perempuan. Melaksanakannya secara berjamaah di masjid memiliki keutamaan tersendiri, meskipun sah juga jika dikerjakan sendirian di rumah. Waktunya membentang dari setelah shalat Isya hingga terbit fajar shadiq (waktu Subuh).\n\nDinamakan Tarawih (bentuk jamak dari tarwihah yang berarti istirahat) karena kaum salaf dahulu beristirahat setiap selesai melaksanakan empat rakaat. Hal ini menunjukkan bahwa shalat ini sejatinya dilakukan dengan tenang, tuma\'ninah, dan tidak terburu-buru, semata-mata untuk meresapi bacaan Al-Qur\'an dan mendekatkan diri kepada Allah SWT.',
        }
      ]
    },
    {
      'title': 'Peluang Wanita Haid dan Nifas Meraih Keutamaan Lailatul Qadar',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Ketika memasuki sepuluh malam terakhir Ramadhan, banyak wanita yang sedang mengalami haid atau nifas merasa bersedih karena tidak bisa melaksanakan shalat, puasa, atau i\'tikaf di masjid. Padahal, Rahmat Allah sangat luas, dan mereka tetap berpeluang besar untuk mendapatkan keutamaan Lailatul Qadar.',
        },
        {
          'type': 'arabic',
          'content': 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
          'latin': 'Innamal a\'mâlu bin niyyâti wa innamâ likullimri-in mâ nawâ',
          'translation': '"Sesungguhnya amalan itu tergantung pada niatnya, dan seseorang akan mendapatkan apa yang ia niatkan." (HR. Bukhari & Muslim)',
        },
        {
          'type': 'text',
          'content': 'Berdasarkan hadis di atas, wanita yang terbiasa beribadah namun terhalang oleh udzur syar\'i (haid/nifas) tetap mendapatkan pahala ibadahnya secara penuh karena niat baiknya. Selain itu, ada banyak amalan mulia yang tetap bisa dilakukan untuk menghidupkan Lailatul Qadar:\n\n1. Memperbanyak Zikir dan Istighfar\nLisan yang basah dengan dzikir (Subhanallah, Alhamdulillah, Laa ilaaha illallah, Allahu Akbar) memiliki kedudukan yang sangat mulia di sisi Allah.\n\n2. Berdoa dengan Sungguh-sungguh\nTerutama membaca doa yang diajarkan Rasulullah SAW kepada Aisyah RA saat mencari Lailatul Qadar: "Allahumma innaka \'afuwwun tuhibbul \'afwa fa\'fu \'anni" (Ya Allah, sesungguhnya Engkau Maha Pemaaf dan menyukai kemaafan, maka maafkanlah aku).\n\n3. Membaca dan Mendengarkan Al-Qur\'an\nMeskipun dilarang menyentuh mushaf langsung (menurut mayoritas ulama), mendengarkan murottal atau membaca terjemahan dan tafsir Al-Qur\'an melalui aplikasi gawai (smartphone) tetap dibolehkan dan mendatangkan pahala yang besar.\n\n4. Bersedekah dan Memberi Makan Orang Berbuka\nMembantu menyiapkan sahur atau berbuka bagi orang yang berpuasa pahalanya sama dengan pahala orang yang berpuasa tersebut tanpa menguranginya sedikitpun.',
        }
      ]
    },
    {
      'title': 'Batas Minimal Menghidupkan Lailatul Qadar',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Menghidupkan malam Lailatul Qadar (Ihya\' Lailatul Qadar) adalah impian setiap mukmin. Namun, tidak semua orang memiliki kemampuan fisik atau kelonggaran waktu untuk beribadah sepanjang malam suntuk. Lantas, adakah batas minimal agar seseorang tetap dihitung telah menghidupkan Lailatul Qadar?',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ صَلَّى الْعِشَاءَ فِي جَمَاعَةٍ فَكَأَنَّمَا قَامَ نِصْفَ اللَّيْلِ وَمَنْ صَلَّى الصُّبْحَ فِي جَمَاعَةٍ فَكَأَنَّمَا صَلَّى اللَّيْلَ كُلَّهُ',
          'latin': 'Man shallal \'isyâ-a fî jamâ\'atin faka-annamâ qâma nishfal lail, wa man shallash shubha fî jamâ\'atin faka-annamâ shallal laila kullah',
          'translation': '"Barangsiapa shalat Isya berjamaah, maka seakan-akan ia telah melaksanakan shalat malam separuh malam. Dan barangsiapa shalat Subuh berjamaah, maka seakan-akan ia telah melaksanakan shalat malam semalam suntuk." (HR. Muslim)',
        },
        {
          'type': 'text',
          'content': 'Berdasarkan hadits di atas dan penjelasan para ulama (seperti Imam Syafi\'i), batas minimal (adnal kamal) untuk mendapatkan keutamaan menghidupkan malam Lailatul Qadar adalah dengan melaksanakan shalat Isya dan shalat Subuh secara berjamaah.\n\nTentu saja, porsi pahalanya akan berbeda dengan mereka yang begadang sepanjang malam untuk shalat sunnah, tilawah, dan zikir. Namun, ini adalah kabar gembira bagi pekerja keras, ibu menyusui, atau orang yang sedang sakit, bahwa mereka tetap bisa meraih kemuliaan malam seribu bulan hanya dengan menjaga shalat wajibnya (Isya dan Subuh) secara berjamaah.',
        }
      ]
    },
    {
      'title': 'Ibadah Anak Kecil Apakah Berpahala?',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Sering kali kita melihat anak-anak kecil yang belum baligh ikut shalat tarawih, berpuasa, atau belajar mengaji di bulan Ramadhan. Sebagian orang tua mungkin bertanya-tanya, apakah ibadah yang dilakukan oleh anak yang belum mukallaf (terbebani hukum syariat) mendapatkan pahala?',
        },
        {
          'type': 'arabic',
          'content': 'رُفِعَ الْقَلَمُ عَنْ ثَلَاثَةٍ: عَنِ النَّائِمِ حَتَّى يَسْتَيْقِظَ، وَعَنِ الصَّبِيِّ حَتَّى يَبْلُغَ، وَعَنِ الْمَجْنُونِ حَتَّى يَعْقِلَ',
          'latin': 'Rufi\'al qalamu \'an tsalâtsatin: \'anin nâ-imi hattâ yastaiqidza, wa \'anish shabiyyi hattâ yablugha, wa \'anil majnûni hattâ ya\'qila',
          'translation': '"Pena (catatan amal) diangkat dari tiga golongan: orang tidur hingga ia bangun, anak kecil hingga ia baligh, dan orang gila hingga ia berakal." (HR. Abu Dawud dan Ibnu Majah)',
        },
        {
          'type': 'text',
          'content': 'Hadis di atas menjelaskan bahwa anak kecil belum diwajibkan untuk menjalankan syariat. Namun, hal ini bukan berarti ibadah mereka tidak dinilai. Mayoritas ulama, termasuk mazhab Syafi\'i, menegaskan bahwa ibadah sunnah maupun ibadah wajib (yang mereka niatkan belajar) yang dilakukan oleh anak kecil (mumayyiz) adalah sah dan mendatangkan pahala.\n\nPahala ibadah tersebut tidak hanya diberikan kepada sang anak sebagai tabungan amal kebaikannya kelak, tetapi pahalanya juga mengalir kepada kedua orang tuanya yang telah mendidik dan mengarahkan mereka. Oleh karena itu, bulan Ramadhan adalah momentum emas bagi orang tua untuk melatih (tarbiyah) anak-anak beribadah, agar kelak saat mereka baligh, ketaatan sudah menjadi karakter dan kebiasaan.',
        }
      ]
    },
    {
      'title': 'Hukum Ludah Tertelan ketika Gusi Berdarah saat Puasa',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Menjaga kebersihan mulut saat puasa terkadang memunculkan permasalahan tersendiri, seperti gusi yang tiba-tiba berdarah. Jika seseorang sedang berpuasa lalu gusinya berdarah, bagaimana hukum puasanya jika darah tersebut bercampur dengan ludah dan tertelan tanpa sengaja?',
        },
        {
          'type': 'arabic',
          'content': 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
          'latin': 'Lâ yukallifullâhu nafsan illâ wus\'ahâ',
          'translation': '"Allah tidak membebani seseorang melainkan sesuai dengan kesanggupannya." (QS. Al-Baqarah: 286)',
        },
        {
          'type': 'text',
          'content': 'Dalam kajian fiqih, darah yang keluar dari gusi tergolong najis. Jika darah tersebut bercampur dengan ludah, maka meludahkannya (membuangnya) adalah suatu keharusan agar puasa tetap sah.\n\nNamun, bagaimana jika tertelan? Ulama memerincinya dalam dua kondisi:\n\n1. Jika Bisa Dihindari\nJika seseorang sadar gusinya berdarah dan ia mampu untuk membuang (meludahkan) darah tersebut atau berkumur, namun ia justru sengaja menelannya bersama ludah, maka puasanya batal. Hal ini karena ia menelan perkara eksternal (ain) yang najis.\n\n2. Jika Sulit Dihindari (Udzur/Masyaqqah)\nJika darah sering keluar karena kondisi medis tertentu, atau darah tersebut tertelan tanpa sengaja sebelum sempat diludahkan, maka hal ini dimaafkan (ma\'fu) dan puasanya tetap sah. Kesulitan (masyaqqah) dalam menghindari sesuatu yang diluar kendali manusia mendatangkan keringanan hukum, sejalan dengan prinsip "kemudahan dalam beragama". Namun, sebisa mungkin ia harus tetap berusaha membersihkan sisa darah di mulutnya.',
        }
      ]
    },
    {
      'title': 'Momentum Nuzulul Quran, Bedakan Istilah Nuzul, Inzal, dan Tanzil',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Peringatan Nuzulul Qur\'an yang sering dirayakan pada malam ke-17 Ramadhan merupakan momen penting untuk menelusuri kembali sejarah turunnya Al-Qur\'an. Dalam kajian Ulumul Qur\'an, proses turunnya Al-Qur\'an menggunakan beberapa istilah yang memiliki makna berbeda, yakni Nuzul, Inzal, dan Tanzil.',
        },
        {
          'type': 'arabic',
          'content': 'شَهْرُ رَمَضَانَ الَّذِي أُنْزِلَ فِيهِ الْقُرْآنُ هُدًى لِلنَّاسِ وَبَيِّنَاتٍ مِنَ الْهُدَىٰ وَالْفُرْقَانِ',
          'latin': 'Syahru ramadlânal ladzî unzila fîhil qur\'ânu hudal lin nâsi wa bayyinâtim minal hudâ wal furqân',
          'translation': '"(Beberapa hari yang ditentukan itu ialah) bulan Ramadhan, bulan yang di dalamnya diturunkan (permulaan) Al-Qur\'an sebagai petunjuk bagi manusia dan penjelasan-penjelasan mengenai petunjuk itu dan pembeda (antara yang hak dan yang bathil)." (QS. Al-Baqarah: 185)',
        },
        {
          'type': 'text',
          'content': 'Para mufassir menjelaskan perbedaan ketiga istilah tersebut sebagai berikut:\n\n1. Inzal (Diturunkan Sekaligus)\nKata "Inzal" (seperti kata *unzila* pada ayat di atas) merujuk pada proses turunnya Al-Qur\'an secara utuh (sekaligus) dari Lauhul Mahfudz ke Baitul Izzah di langit dunia. Peristiwa ini terjadi bertepatan dengan malam Lailatul Qadar. Al-Qur\'an diturunkan lengkap 30 juz sebagai sebuah cetak biru panduan hidup manusia.\n\n2. Tanzil (Diturunkan Berangsur-angsur)\nKata "Tanzil" merujuk pada proses turunnya Al-Qur\'an dari Baitul Izzah di langit dunia kepada Nabi Muhammad SAW melalui perantara Malaikat Jibril. Proses ini berlangsung secara berangsur-angsur (mutawatir) selama kurang lebih 23 tahun sesuai dengan konteks kejadian, pertanyaan, dan kebutuhan umat saat itu.\n\n3. Nuzul (Istilah Umum)\nAdapun "Nuzul" adalah istilah umum (masdar) yang mencakup keseluruhan proses turunnya wahyu tersebut, baik secara sekaligus maupun berangsur-angsur.\n\nMemahami perbedaan ini menambah wawasan kita akan keagungan Al-Qur\'an yang diturunkan melalui fase-fase terencana, membuktikan bahwa kitab ini merupakan wahyu yang benar-benar dijaga kemurniannya oleh Allah SWT.',
        }
      ]
    },
    {
      'title': 'Kisah Perempuan Tunanetra yang Berdoa di Bulan Ramadhan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Bulan Ramadhan adalah bulan dikabulkannya doa. Salah satu kisah inspiratif datang dari seorang perempuan tunanetra di masa salafus shalih yang memanfaatkan malam-malam Ramadhan untuk berdoa memohon kesembuhan matanya kepada Allah SWT.',
        },
        {
          'type': 'arabic',
          'content': 'وَقَالَ رَبُّكُمُ ادْعُونِي أَسْتَجِبْ لَكُمْ',
          'latin': 'Wa qâla rabbukumud\'ûnî astajib lakum',
          'translation': '"Dan Tuhanmu berfirman: Berdoalah kepada-Ku, niscaya akan Kuperkenankan bagimu." (QS. Ghafir: 60)',
        },
        {
          'type': 'text',
          'content': 'Dalam banyak riwayat ulama, dikisahkan ada seorang hamba sahaya perempuan yang kehilangan penglihatannya. Ia tidak memiliki harta maupun tabib untuk mengobati matanya. Namun ia tahu bahwa di bulan Ramadhan, terutama di sepertiga malam terakhir, Allah turun ke langit dunia untuk mengabulkan doa hamba-Nya.\n\nSetiap malam, ia bangun, mendirikan shalat tahajud, dan menangis tersedu-sedu mengadukan kebutaannya kepada Allah. Ia terus berdoa dengan penuh keyakinan tanpa putus asa. Berkat keteguhan imannya, pada suatu pagi di akhir Ramadhan, atas izin Allah penglihatannya pulih kembali dengan sempurna.\n\nKisah ini mengajarkan kita bahwa tidak ada yang mustahil bagi Allah. Bulan Ramadhan adalah waktu terbaik untuk memanjatkan hajat terbesar kita. Syaratnya hanyalah yakin, bersabar, dan tidak tergesa-gesa dalam menanti ijabah dari-Nya.',
        }
      ]
    },
    {
      'title': 'Rasionalisasi Masih Maraknya Kemaksiatan, Padahal Setan Dibelenggu Sepanjang Ramadhan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Salah satu keistimewaan bulan puasa adalah dibelenggunya setan. Namun, realitas di masyarakat menunjukkan bahwa kemaksiatan dan kejahatan tetap saja terjadi di bulan suci ini. Bagaimana kita merasionalkan sabda Nabi tersebut dengan kenyataan yang ada?',
        },
        {
          'type': 'arabic',
          'content': 'إِذَا دَخَلَ شَهْرُ رَمَضَانَ فُتِّحَتْ أَبْوَابُ السَّمَاءِ وَغُلِّقَتْ أَبْوَابُ جَهَنَّمَ وَسُلْسِلَتِ الشَّيَاطِينُ',
          'latin': 'Idzâ dakhala syahru ramadlâna futtihat abwâbus samâ-i wa ghulliqat abwâbu jahannama wa sulsilatish syayâthîn',
          'translation': '"Apabila bulan Ramadhan tiba, pintu-pintu langit dibuka, pintu-pintu neraka ditutup, dan setan-setan dibelenggu." (HR. Bukhari dan Muslim)',
        },
        {
          'type': 'text',
          'content': 'Para ulama seperti Imam Al-Qurthubi dan Ibnu Hajar Al-Asqalani memberikan beberapa penafsiran terkait hadis ini:\n\n1. Setan yang dibelenggu hanyalah setan-setan pembangkang (maradatus syayathin), bukan seluruh jin dan setan. Sehingga godaan-godaan kecil masih tetap ada.\n\n2. Makna "dibelenggu" adalah kiasan (majazi) bahwa ruang gerak setan menjadi sangat sempit karena umat Islam sibuk berpuasa, membaca Al-Qur\'an, dan beribadah. Orang yang berpuasa dengan benar akan melemahkan syahwatnya, yang merupakan jalan utama masuknya setan.\n\n3. Kemaksiatan yang terjadi di bulan Ramadhan bukan murni dari godaan setan eksternal, melainkan berasal dari hawa nafsu (nafs ammarah bis su\') dan kebiasaan buruk (tabiat) manusia itu sendiri yang sudah berakar sebelum Ramadhan.\n\nOleh karena itu, jika seseorang masih gemar bermaksiat di bulan Ramadhan, itu adalah bukti bahwa hawa nafsunyalah yang sebenarnya menjadi musuh terbesar, bukan lagi setan.',
        }
      ]
    },
    {
      'title': 'Menelan Air Saat Berkumur Apakah Membatalkan Puasa?',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Saat berwudhu, disunnahkan untuk berkumur (madhmadhoh) dan memasukkan air ke hidung (istinsyaq). Namun saat sedang berpuasa, kekhawatiran air akan tertelan sering kali muncul.',
        },
        {
          'type': 'arabic',
          'content': 'بَالِغْ فِي الِاسْتِنْشَاقِ إِلَّا أَنْ تَكُونَ صَائِمًا',
          'latin': 'Bâligh fîl istinsyâqi illâ an takûna shâ-imâ',
          'translation': '"Bersungguh-sungguhlah dalam menghirup air ke hidung (istinsyaq), kecuali jika engkau sedang berpuasa." (HR. Abu Dawud dan Tirmidzi)',
        },
        {
          'type': 'text',
          'content': 'Dalam mazhab Syafi\'i, hukum batal atau tidaknya puasa akibat air kumur yang tertelan bergantung pada cara seseorang berkumur:\n\n1. Berkumur Secara Wajar (Sesuai Sunnah)\nJika seseorang berkumur untuk wudhu tanpa berlebih-lebihan (mubalaghah), lalu tanpa sengaja ada air yang tertelan ke tenggorokan, maka puasanya TIDAK BATAL. Hal ini dimaafkan karena berkumur dalam wudhu adalah amalan yang disyariatkan.\n\n2. Berkumur Berlebih-lebihan (Mubalaghah)\nJika seseorang berkumur terlalu kuat atau terlalu ke dalam (mubalaghah) padahal ia ingat sedang berpuasa, dan akhirnya ada air yang tertelan, maka puasanya BATAL. Makruh hukumnya berlebih-lebihan dalam berkumur saat puasa sesuai hadis di atas.\n\n3. Berkumur Bukan untuk Wudhu\nJika seseorang berkumur hanya untuk menyegarkan mulut (karena kepanasan) lalu air tertelan tanpa sengaja, sebagian ulama menilai puasanya batal karena aktivitas berkumur itu sendiri tidak dituntut oleh syariat.',
        }
      ]
    },
    {
      'title': '4 Ayat Al-Quran tentang Puasa Ramadhan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Perintah berpuasa di bulan Ramadhan beserta hukum-hukum rincinya diabadikan oleh Allah SWT secara berurutan dalam Al-Qur\'an, tepatnya dalam Surat Al-Baqarah ayat 183 hingga 187. Berikut adalah ringkasan dari 4 ayat utamanya:',
        },
        {
          'type': 'arabic',
          'content': 'يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ',
          'latin': 'Yâ ayyuhal ladzîna âmanû kutiba \'alaikumush shiyâmu kamâ kutiba \'alal ladzîna min qablikum la\'allakum tattaqûn',
          'translation': '"Hai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa." (QS. Al-Baqarah: 183)',
        },
        {
          'type': 'text',
          'content': '1. Ayat 183 (Kewajiban dan Tujuan Puasa)\nMenegaskan bahwa puasa adalah ibadah wajib peninggalan umat terdahulu, dengan satu tujuan utama: mencapai predikat takwa (muttaqin).\n\n2. Ayat 184 (Keringanan bagi yang Udzur)\nAyat ini memberikan rukhshah (keringanan) bagi orang yang sakit atau sedang dalam perjalanan (musafir) untuk mengganti puasanya di hari lain (qadha). Serta wajibnya membayar fidyah bagi mereka yang sangat berat menjalankannya (seperti lansia).\n\n3. Ayat 185 (Keistimewaan Bulan Ramadhan)\nAyat ini menjelaskan alasan mulianya Ramadhan, yaitu diturunkannya Al-Qur\'an. Allah menegaskan kembali bahwa syariat puasa ini ditujukan untuk memberikan kemudahan, bukan menyulitkan hamba-Nya.\n\n4. Ayat 187 (Hukum-hukum Malam Ramadhan)\nAyat ini turun sebagai penghapus hukum sebelumnya. Allah menghalalkan hubungan suami istri di malam hari bulan puasa, serta mempertegas batas waktu makan sahur, yaitu dari terbenam matahari hingga fajar (benang putih) menyingsing.',
        }
      ]
    },
    {
      'title': 'Tidak Sengaja Makan, Apakah Batal Puasa? Berikut Penjelasannya',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Lupa adalah sifat dasar manusia. Sangat mungkin seseorang yang berpuasa tiba-tiba makan atau minum karena murni terlupa bahwa ia sedang berada di bulan Ramadhan, terutama di hari-hari pertama.',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ نَسِيَ وَهُوَ صَائِمٌ فَأَكَلَ أَوْ شَرِبَ فَلْيُتِمَّ صَوْمَهُ فَإِنَّمَا أَطْعَمَهُ اللَّهُ وَسَقَاهُ',
          'latin': 'Man nasiya wahuwa shâ-imun fa akala au syariba falyutimma shaumahu fa innamâ ath\'amahullâhu wasaqâh',
          'translation': '"Barangsiapa yang lupa sedangkan ia sedang berpuasa, lalu ia makan atau minum, maka sempurnakanlah puasanya. Karena sesungguhnya Allah-lah yang memberinya makan dan minum." (HR. Bukhari dan Muslim)',
        },
        {
          'type': 'text',
          'content': 'Seluruh ulama sepakat berdasarkan hadis shahih di atas bahwa makan dan minum yang murni karena lupa (nisyan), baik sedikit maupun banyak (sampai kenyang sekalipun), TIDAK membatalkan puasa.\n\nOrang yang mengalami hal ini tidak wajib memuntahkan makanan yang sudah terlanjur masuk, dan tidak diwajibkan qadha atas hari itu. Ia hanya perlu berhenti makan seketika setelah ia ingat, membersihkan mulutnya, dan melanjutkan puasanya hingga maghrib.\n\nNamun, jika ada orang lain yang melihat seseorang makan karena lupa, maka orang yang melihat wajib mengingatkannya, karena makan di siang hari bulan Ramadhan adalah kemungkaran secara lahiriah yang harus dicegah.',
        }
      ]
    },
    {
      'title': 'Kisah Dua Perempuan Bergosip Ria saat Puasa Ramadhan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Puasa bukan hanya sekadar menahan lapar dan dahaga, tetapi juga menahan lisan dari ucapan yang haram. Ghibah (bergosip atau menggunjing) adalah salah satu perusak utama pahala puasa.',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ لَمْ يَدَعْ قَوْلَ الزُّورِ وَالْعَمَلَ بِهِ فَلَيْسَ لِلَّهِ حَاجَةٌ فِي أَنْ يَدَعَ طَعَامَهُ وَشَرَابَهُ',
          'latin': 'Man lam yada\' qaulaz zûri wal \'amala bihi falaisa lillâhi hâjatun fî an yada\'a tha\'âmahu wa syarâbah',
          'translation': '"Barangsiapa yang tidak meninggalkan perkataan dusta dan perbuatan buruk, maka Allah tidak butuh ia meninggalkan makan dan minumnya (puasanya)." (HR. Bukhari)',
        },
        {
          'type': 'text',
          'content': 'Dalam sebuah riwayat dari Imam Ahmad, dikisahkan ada dua orang perempuan yang sedang berpuasa di zaman Rasulullah SAW. Keduanya sangat kehausan dan kelelahan hingga hampir mati. Mereka pun meminta izin kepada Nabi untuk membatalkan puasa.\n\nRasulullah SAW memanggil keduanya lalu memberikan sebuah wadah (mangkuk) dan memerintahkan mereka untuk muntah. Mengejutkannya, keluarlah dari mulut mereka gumpalan darah dan potongan daging mentah yang busuk.\n\nNabi SAW lalu bersabda: "Keduanya berpuasa dari apa yang dihalalkan Allah (makan dan minum), namun mereka berbuka dengan apa yang diharamkan Allah. Keduanya duduk sambil membicarakan (menggunjing/ghibah) aib orang lain, maka itulah daging-daging orang yang mereka makan."\n\nKisah ini menjadi peringatan keras bahwa ghibah di bulan Ramadhan mungkin tidak membatalkan hukum sahnya puasa secara fiqih, namun secara mutlak menghapus seluruh pahalanya, menjadikannya puasa yang sia-sia (hanya mendapat lapar dan dahaga).',
        }
      ]
    },
    {
      'title': 'Fiqih Puasa: Suntik dan Infus Apakah Membatalkan?',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Kemajuan ilmu medis memunculkan berbagai metode pengobatan seperti suntik (injeksi) dan infus. Karena benda ini masuk ke dalam tubuh, banyak masyarakat yang ragu apakah hal tersebut membatalkan puasa atau tidak.',
        },
        {
          'type': 'arabic',
          'content': 'وَمَا جَعَلَ عَلَيْكُمْ فِي الدِّينِ مِنْ حَرَجٍ',
          'latin': 'Wa mâ ja\'ala \'alaikum fîd dîni min haraj',
          'translation': '"...dan Dia tidak menjadikan kesukaran untukmu dalam agama." (QS. Al-Hajj: 78)',
        },
        {
          'type': 'text',
          'content': 'Hukum membatalkan puasa bergantung pada apakah zat tersebut masuk melalui rongga tubuh yang terbuka (manfadz maftuh) seperti mulut, hidung, atau telinga, dan apakah zat tersebut mengenyangkan.\n\nBerikut pandangan ulama kontemporer terkait suntik dan infus:\n\n1. Suntikan (Injeksi) Obat\nSuntik yang disuntikkan ke bawah kulit (subkutan), ke otot (intramuskular), atau ke pembuluh darah (intravena) yang tujuannya murni untuk pengobatan (seperti penurun panas, antibiotik, atau vaksin), disepakati TIDAK membatalkan puasa. Hal ini karena obat tidak masuk melalui rongga terbuka dan tidak memberikan efek mengenyangkan.\n\n2. Infus Makanan/Vitamin (Nutrisi)\nCairan infus yang mengandung glukosa, vitamin, atau nutrisi yang ditujukan untuk menggantikan makanan dan minuman bagi pasien, dihukumi MEMBATALKAN puasa menurut mayoritas ulama kontemporer (seperti Majma\' Fiqih Islami). Karena esensi infus nutrisi sangat mirip dengan makan dan minum, yaitu menyuplai energi dan menghilangkan rasa lapar.\n\nKesimpulannya, suntik pengobatan biasa diperbolehkan, sementara infus nutrisi membatalkan puasa dan pasien yang diinfus wajib mengqadha puasanya di hari lain.',
        }
      ]
    },
    {
      'title': 'Hukum Shalat Tarawih Empat Rakaat Satu Salam dalam Mazhab Syafii',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Di sebagian masjid, sering kita jumpai shalat Tarawih dilaksanakan dengan format empat rakaat satu salam. Praktik ini biasanya mendasarkan pada hadis Aisyah RA tentang shalat malam Nabi yang dikerjakan empat-empat. Namun, bagaimana hukumnya dalam tinjauan mazhab Syafi\'i yang dianut mayoritas masyarakat Indonesia?',
        },
        {
          'type': 'arabic',
          'content': 'صَلاَةُ اللَّيْلِ مَثْنَى مَثْنَى',
          'latin': 'Shalâtul laili matsnâ matsnâ',
          'translation': '"Shalat malam itu dua rakaat-dua rakaat." (HR. Bukhari dan Muslim)',
        },
        {
          'type': 'text',
          'content': 'Dalam mazhab Syafi\'i, shalat Tarawih disyariatkan dengan format dua rakaat satu salam (matsna-matsna). Jika seseorang sengaja mengerjakan Tarawih empat rakaat dengan satu salam, maka hukum shalatnya adalah TIDAK SAH (Batal).\n\nImam an-Nawawi dalam kitab *Al-Majmu\'* menjelaskan alasannya:\n1. Hadis Nabi secara spesifik memerintahkan shalat malam dengan dua rakaat.\n2. Shalat Tarawih diqiyaskan dengan shalat fardhu yang memiliki batasan waktu dan rakaat. Menambah rakaat dalam satu salam tanpa landasan khusus dianggap mengubah bentuk ibadah (tala\'ub bil ibadah).\n\nLalu bagaimana memahami hadis Aisyah RA yang berbunyi: "Nabi shalat empat rakaat, jangan tanya bagus dan panjangnya"?\nUlama mazhab Syafi\'i menafsirkan hadis tersebut bukan berarti Nabi shalat empat rakaat sekaligus dengan satu salam. Melainkan, Nabi shalat dua rakaat lalu salam, kemudian dua rakaat lagi lalu salam, lalu beliau beristirahat sebentar (tarwihah). Rangkaian empat rakaat (yang dipisah salam) inilah yang dimaksud Aisyah RA.\n\nOleh karena itu, sangat dianjurkan bagi umat Islam, khususnya yang bermazhab Syafi\'i, untuk mendirikan Tarawih dengan format dua rakaat salam untuk menjaga keabsahan ibadah.',
        }
      ]
    },
    {
      'title': '6 Amalan Perempuan Haid di Bulan Ramadhan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Saat sedang haid di bulan Ramadhan, seorang perempuan diharamkan untuk berpuasa, shalat, dan membaca Al-Qur\'an. Meski begitu, pintu pahala tetap terbuka lebar melalui berbagai amalan lain.',
        },
        {
          'type': 'arabic',
          'content': 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
          'latin': 'Innamal a\'mâlu bin niyyâti wa innamâ likullimri-in mâ nawâ',
          'translation': '"Sesungguhnya amalan itu tergantung pada niatnya, dan seseorang akan mendapatkan apa yang ia niatkan." (HR. Bukhari & Muslim)',
        },
        {
          'type': 'text',
          'content': 'Berikut 6 amalan utama yang bisa dilakukan perempuan haid di bulan Ramadhan:\n\n1. Memperbanyak Zikir dan Doa. Lidah yang basah dengan istighfar, tasbih, tahmid, dan tahlil akan terus mendatangkan pahala tanpa batas.\n\n2. Menyiapkan Hidangan Berbuka dan Sahur. Rasulullah SAW bersabda, "Barangsiapa memberi makan orang yang berpuasa, maka baginya pahala seperti orang yang berpuasa tersebut, tanpa mengurangi pahala orang yang berpuasa itu sedikit pun."\n\n3. Memperbanyak Sedekah. Bersedekah harta atau sekadar membagikan takjil di masjid sangat dianjurkan.\n\n4. Mendengarkan Murottal atau Kajian. Meski tidak membaca langsung, mendengarkan lantunan ayat suci Al-Qur\'an atau majelis ilmu tetap bernilai ibadah.\n\n5. Bershalawat kepada Nabi Muhammad SAW. Shalawat adalah kunci syafaat dan amalan yang tidak pernah ditolak.\n\n6. Menjaga Lisan dan Emosi. Momen haid seringkali membuat emosi tidak stabil. Menahan marah dan menjauhi ghibah adalah amalan mulia.',
        }
      ]
    },
    {
      'title': 'Haid saat Puasa, Bagaimana Ketentuan Qadhanya?',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Perempuan yang mengalami haid atau nifas di bulan Ramadhan mendapat keringanan mutlak untuk tidak berpuasa. Namun, ia memiliki kewajiban untuk menggantinya (qadha) di luar bulan Ramadhan.',
        },
        {
          'type': 'arabic',
          'content': 'كَانَ يُصِيبُنَا ذَلِكَ فَنُؤْمَرُ بِقَضَاءِ الصَّوْمِ وَلَا نُؤْمَرُ بِقَضَاءِ الصَّلَاةِ',
          'latin': 'Kâna yushîbunâ dzâlika fanu-maru biqadlâ-ish shaumi wa lâ nu-maru biqadlâ-ish shalâh',
          'translation': '"Dahulu kami mengalami haid (di zaman Rasulullah), maka kami diperintahkan untuk mengqadha puasa dan tidak diperintahkan untuk mengqadha shalat." (HR. Muslim dari Aisyah RA)',
        },
        {
          'type': 'text',
          'content': 'Ketentuan qadha puasa bagi perempuan haid:\n\n1. Waktu Pelaksanaan. Qadha puasa bisa dilakukan kapan saja setelah bulan Ramadhan (mulai 2 Syawal) hingga menjelang Ramadhan tahun berikutnya.\n\n2. Boleh Dicicil (Terpisah). Qadha puasa tidak wajib dilakukan secara berturut-turut (muwalah). Seseorang boleh mengerjakannya secara selang-seling sesuai kemampuannya.\n\n3. Niat Qadha. Niat puasa qadha wajib dilakukan di malam hari (sebelum terbit fajar), sama seperti puasa Ramadhan, karena ia berstatus sebagai puasa fardhu.\n\n4. Menunda Qadha Hingga Ramadhan Berikutnya. Jika seseorang dengan sengaja menunda qadha puasanya padahal ia mampu, hingga masuk Ramadhan berikutnya, maka ia berdosa. Dalam mazhab Syafi\'i, ia tetap wajib mengqadha puasanya DAN diwajibkan membayar fidyah sebagai denda keterlambatan sebanyak 1 mud (sekitar 675 gram beras) per hari yang ditinggalkan.',
        }
      ]
    },
    {
      'title': 'Hukum Baca Al-Quran dengan Cepat',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Di bulan Ramadhan, banyak umat Islam yang berlomba-lomba untuk mengkhatamkan Al-Qur\'an berkali-kali. Hal ini terkadang membuat seseorang membaca Al-Qur\'an dengan ritme yang sangat cepat (Hadr). Bagaimana hukumnya?',
        },
        {
          'type': 'arabic',
          'content': 'وَرَتِّلِ الْقُرْآنَ تَرْتِيلًا',
          'latin': 'Wa rattilil qur\'âna tartîlâ',
          'translation': '"Dan bacalah Al-Qur\'an itu dengan perlahan-lahan/tartil." (QS. Al-Muzzammil: 4)',
        },
        {
          'type': 'text',
          'content': 'Membaca Al-Qur\'an memiliki beberapa tingkatan kecepatan, dari yang paling lambat (Tahqiq), sedang (Tadwir), hingga yang paling cepat (Hadr). Semuanya diperbolehkan.\n\nNamun, membaca dengan sangat cepat (Hadr) diperbolehkan dengan satu syarat mutlak: HARUS TETAP MENJAGA KAIDAH TAJWID. \n\nSeseorang tidak boleh memotong huruf, mengubah panjang pendek (mad), atau merusak makharijul huruf hanya demi mengejar target khatam. Jika kecepatannya sampai merusak struktur kata atau kaidah tajwid secara signifikan, maka hukumnya menjadi haram.\n\nUlama sepakat bahwa membaca Al-Qur\'an satu juz dengan tartil, perenungan (tadabbur), dan tajwid yang benar jauh lebih afdhal dan disukai Allah daripada membaca tiga juz dengan terburu-buru tanpa penghayatan. Kuantitas itu baik, namun kualitas tilawah adalah yang utama.',
        }
      ]
    },
    {
      'title': 'Hukum Shalat Tahajud setelah Witir di Bulan Ramadhan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Di bulan Ramadhan, umat Islam biasanya melaksanakan shalat Tarawih yang langsung ditutup dengan shalat Witir secara berjamaah di masjid. Lantas, bolehkah seseorang yang sudah shalat Witir bangun lagi di sepertiga malam untuk shalat Tahajud?',
        },
        {
          'type': 'arabic',
          'content': 'لَا وِتْرَانِ فِي لَيْلَةٍ',
          'latin': 'Lâ witrâni fî lailah',
          'translation': '"Tidak ada dua witir dalam satu malam." (HR. Abu Dawud, Tirmidzi, dan Nasa\'i)',
        },
        {
          'type': 'text',
          'content': 'Shalat Witir disebut sebagai "penutup shalat malam". Hal ini sering menimbulkan kerancuan seolah-olah setelah Witir tidak boleh ada shalat lagi.\n\nMayoritas ulama (Jumhur) menegaskan bahwa BOLEH melaksanakan shalat Tahajud meskipun sudah melaksanakan shalat Witir sebelumnya. Syaratnya: ia tidak perlu mengulangi shalat Witir lagi di akhir malamnya, sebagaimana hadis larangan "dua witir dalam satu malam".\n\nJika ia bangun tahajud, ia cukup melaksanakan shalat dua rakaat-dua rakaat sesuai kemampuannya tanpa ditutup witir. \n\nNamun, bagi orang yang sudah terbiasa (istiqamah) bangun malam dan yakin bisa bangun, lebih afdhal baginya untuk menunda shalat Witirnya agar dikerjakan setelah shalat Tahajud, sebagai penutup ibadah malamnya yang sempurna.',
        }
      ]
    },
    {
      'title': 'Doa sesudah Shalat Witir',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Shalat Witir adalah shalat yang sangat dicintai Allah. Setelah menyelesaikan rakaat terakhir dan salam pada shalat Witir, sangat dianjurkan untuk membaca doa khusus yang diajarkan oleh Rasulullah SAW sebelum beranjak.',
        },
        {
          'type': 'arabic',
          'content': 'سُبْحَانَ الْمَلِكِ الْقُدُّوسِ ، سُبْحَانَ الْمَلِكِ الْقُدُّوسِ ، سُبْحَانَ الْمَلِكِ الْقُدُّوسِ',
          'latin': 'Subhânal malikil quddûs (3x, yang ketiga dibaca lebih panjang dan dikeraskan suaranya)',
          'translation': '"Maha Suci Allah Yang Maha Merajai, Yang Maha Suci." (HR. Abu Dawud dan An-Nasa\'i)',
        },
        {
          'type': 'text',
          'content': 'Setelah membaca tasbih di atas sebanyak tiga kali, dilanjutkan dengan membaca doa:\n\n"Allahumma inni a\'udzu bi ridlaka min sakhatika wa bi mu\'afatika min \'uqubatika wa a\'udzu bika minka la uhshi tsana-an \'alaika anta kama atsnaita \'ala nafsik."\n\nArtinya: Ya Allah, sesungguhnya aku berlindung dengan keridhaan-Mu dari kemurkaan-Mu, dan dengan keselamatan-Mu dari siksaan-Mu. Dan aku berlindung kepada-Mu dari ancaman-Mu. Aku tidak mampu menghitung pujian atas-Mu sebagaimana Engkau memuji diri-Mu sendiri.\n\nMembaca doa ini secara rutin seusai Witir merupakan bentuk kepasrahan total seorang hamba yang memohon ampunan di pengujung malam, sebelum berganti hari.',
        }
      ]
    },
    {
      'title': 'Momentum Nuzulul Quran, Bedakan Istilah Nuzul, Inzal, dan Tanzil',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Peringatan Nuzulul Qur\'an yang sering dirayakan pada malam ke-17 Ramadhan merupakan momen penting untuk menelusuri kembali sejarah turunnya Al-Qur\'an. Dalam kajian Ulumul Qur\'an, proses turunnya Al-Qur\'an menggunakan beberapa istilah yang memiliki makna berbeda, yakni Nuzul, Inzal, dan Tanzil.',
        },
        {
          'type': 'arabic',
          'content': 'شَهْرُ رَمَضَانَ الَّذِي أُنْزِلَ فِيهِ الْقُرْآنُ هُدًى لِلنَّاسِ وَبَيِّنَاتٍ مِنَ الْهُدَىٰ وَالْفُرْقَانِ',
          'latin': 'Syahru ramadlânal ladzî unzila fîhil qur\'ânu hudal lin nâsi wa bayyinâtim minal hudâ wal furqân',
          'translation': '"(Beberapa hari yang ditentukan itu ialah) bulan Ramadhan, bulan yang di dalamnya diturunkan (permulaan) Al-Qur\'an sebagai petunjuk bagi manusia dan penjelasan-penjelasan mengenai petunjuk itu dan pembeda (antara yang hak dan yang bathil)." (QS. Al-Baqarah: 185)',
        },
        {
          'type': 'text',
          'content': 'Para mufassir menjelaskan perbedaan ketiga istilah tersebut sebagai berikut:\n\n1. Inzal (Diturunkan Sekaligus)\nKata "Inzal" (seperti kata *unzila* pada ayat di atas) merujuk pada proses turunnya Al-Qur\'an secara utuh (sekaligus) dari Lauhul Mahfudz ke Baitul Izzah di langit dunia. Peristiwa ini terjadi bertepatan dengan malam Lailatul Qadar. Al-Qur\'an diturunkan lengkap 30 juz sebagai sebuah cetak biru panduan hidup manusia.\n\n2. Tanzil (Diturunkan Berangsur-angsur)\nKata "Tanzil" merujuk pada proses turunnya Al-Qur\'an dari Baitul Izzah di langit dunia kepada Nabi Muhammad SAW melalui perantara Malaikat Jibril. Proses ini berlangsung secara berangsur-angsur (mutawatir) selama kurang lebih 23 tahun sesuai dengan konteks kejadian, pertanyaan, dan kebutuhan umat saat itu.\n\n3. Nuzul (Istilah Umum)\nAdapun "Nuzul" adalah istilah umum (masdar) yang mencakup keseluruhan proses turunnya wahyu tersebut, baik secara sekaligus maupun berangsur-angsur.\n\nMemahami perbedaan ini menambah wawasan kita akan keagungan Al-Qur\'an yang diturunkan melalui fase-fase terencana, membuktikan bahwa kitab ini merupakan wahyu yang benar-benar dijaga kemurniannya oleh Allah SWT.',
        }
      ]
    },
    {
      'title': 'Hukum Ludah Tertelan ketika Gusi Berdarah saat Puasa',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Menjaga kebersihan mulut saat puasa terkadang memunculkan permasalahan tersendiri, seperti gusi yang tiba-tiba berdarah. Jika seseorang sedang berpuasa lalu gusinya berdarah, bagaimana hukum puasanya jika darah tersebut bercampur dengan ludah dan tertelan tanpa sengaja?',
        },
        {
          'type': 'arabic',
          'content': 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
          'latin': 'Lâ yukallifullâhu nafsan illâ wus\'ahâ',
          'translation': '"Allah tidak membebani seseorang melainkan sesuai dengan kesanggupannya." (QS. Al-Baqarah: 286)',
        },
        {
          'type': 'text',
          'content': 'Dalam kajian fiqih, darah yang keluar dari gusi tergolong najis. Jika darah tersebut bercampur dengan ludah, maka meludahkannya (membuangnya) adalah suatu keharusan agar puasa tetap sah.\n\nNamun, bagaimana jika tertelan? Ulama memerincinya dalam dua kondisi:\n\n1. Jika Bisa Dihindari\nJika seseorang sadar gusinya berdarah dan ia mampu untuk membuang (meludahkan) darah tersebut atau berkumur, namun ia justru sengaja menelannya bersama ludah, maka puasanya batal. Hal ini karena ia menelan perkara eksternal (ain) yang najis.\n\n2. Jika Sulit Dihindari (Udzur/Masyaqqah)\nJika darah sering keluar karena kondisi medis tertentu, atau darah tersebut tertelan tanpa sengaja sebelum sempat diludahkan, maka hal ini dimaafkan (ma\'fu) dan puasanya tetap sah. Kesulitan (masyaqqah) dalam menghindari sesuatu yang diluar kendali manusia mendatangkan keringanan hukum, sejalan dengan prinsip "kemudahan dalam beragama". Namun, sebisa mungkin ia harus tetap berusaha membersihkan sisa darah di mulutnya.',
        }
      ]
    }
  ];

  final List<Map<String, dynamic>> _khutbahMenu = [
    {
      'title': 'Khutbah Jumat: Pentingnya Pendidikan Keluarga di Bulan Ramadhan untuk Membangun Karakter Anak',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Ramadhan adalah bulan yang penuh berkah dalam Islam, di mana umat Muslim diwajibkan untuk berpuasa, beribadah, dan meningkatkan ketakwaan. Kesempatan bulan Ramadhan dapat dimanfaatkan untuk meningkatkan Pendidikan keluarga. Dimulai dengan latihan mengenalkan anak-anak pada ibadah puasa sejak dini.

Pendidikan keluarga di bulan Ramadhan memiliki peran yang sangat penting dalam membentuk karakter anak-anak ke depannya dan memperkuat hubungan lintas keluarga. Bulan Ramadhan adalah kesempatan untuk menanamkan nilai-nilai moral, spiritual, dan sosial dalam kehidupan sehari-hari keluarga.

Teks Khutbah Jumat berikut ini berjudul "Khutbah Jumat: Pentingnya Pendidikan Keluarga di Bulan Ramadhan untuk Membangun Karakter Anak. Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!

Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلهِ الَّذِيْ أَنْعَمَنَا بِنِعْمَةِ الْاِيْمَانِ وَالْاِسْلَامِ ، وَالصَّلَاةُ وَالسَّلَامُ عَلٰى سَيِّدِنَا مُحَمَّدٍ خَيْرِ الْأَنَامِ، وَعَلٰى اٰلِهِ وَأَصْحَابِهِ الْكِرَامِ، أَشْهَدُ اَنْ لَا اِلٰهَ اِلَّا اللهُ الْمَلِكُ الْقُدُّوْسُ السَّلَامُ وَأَشْهَدُ اَنَّ سَيِّدَنَا وَحَبِيْبَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ صَاحِبُ الشَّرَفِ وَالْإِحْتِرَام. أَمَّا بَعْدُ، فَيَا أَيُّهَا الْمُؤْمِنُوْنَ، اِتَّقُوا اللّٰهَ حَقَّ تُقَاتِهِ وَلَا تَمُوْتُنَّ اِلَّا وَأَنْتُمْ مُسْلِمُوْنَ، وَاشْكُرُوْهُ عَلَى مَا هَدَاكُمْ لِلإِسْلاَمِ، وَأَوْلاَكُمْ مِنَ الْفَضْلِ وَالإِنْعَامِ، وَجَعَلَكُمْ مِنْ أُمَّةِ ذَوِى اْلأَرْحَامِ. قَالَ تَعَالَى: وَأْمُرْ أَهْلَكَ بِٱلصَّلَوٰةِ وَٱصْطَبِرْ عَلَيْهَا ۖ لَا نَسْـَٔلُكَ رِزْقًا ۖ نَّحْنُ نَرْزُقُكَ ۗ وَٱلْعَٰقِبَةُ لِلتَّقْوَىٰ''',
        },
        {
          'type': 'text',
          'content': '''Segala puji dan syukur kita persembahkan kepada Allah swt atas segala karunia dan rahmat-Nya yang senantiasa diberikan kepada kepada hamba hamba-Nya. Shalawat dan salam kita doakan bagi Baginda Rasulullah saw, sumber keteladanan dan manusia paling mulia di muka bumi.

Yang kami muliakan seluruh jamaah Jumat

Ramadhan merupakan momentum yang tepat untuk menanamkan pendidikan kepada keluarga. Di antaranya adalah qudwah dari orang tua, mengenalkan Allah yang Maha Rahman dan Rahim. Hal inilah yang telah dipraktikkan oleh Lukmanul Hakim kepada anaknya. Allah swt berfirman dalam surat Luqman ayat 13:''',
        },
        {
          'type': 'arabic',
          'content': '''وَإِذْ قَالَ لُقْمَـٰنُ لِٱبْنِهِۦ وَهُوَ يَعِظُهُۥ يَـٰبُنَىَّ لَا تُشْرِكْ بِٱللَّهِ ۖ إِنَّ ٱلشِّرْكَ لَظُلْمٌ عَظِيمٌۭ''',
          'translation': '''Dan (ingatlah) ketika Lukman berkata kepada anaknya, ketika dia memberi pelajaran kepadanya, “Wahai anakku! Janganlah engkau mempersekutukan Allah, sesungguhnya mempersekutukan (Allah) adalah benar-benar kezaliman yang besar.''',
        },
        {
          'type': 'text',
          'content': '''Dengan mengenalkan Allah Sang Khaliq semanjak dini menjadikan anak-anak dapat saling berkasih sayang, menyadari bahwa dirinya adalah makhluk yang lemah yang ciptakan oleh Sang Khaliq yang Maha Rahman dan Rahim.

Ramadhan sebagai bulan Al-Quran juga menjadi kesempatan keluarga untuk kembali mendekatkan diri dengan Al-Quran. Menghidupkan tradisi membaca Al-Qur'an bersama di rumah, Tradisi membaca Al-Quran dan mengkhatamkanya telah dilakukan oleh para ulama kita terdahulu.

Sebagai penyemangat, Imam As-Syafi’i mengkhatamkan Alquran 60 kali selama Ramadhan. Mengkhatamkan sekali saja bacaan Al-Quran di bulan Ramadhan bersama keluarga adalah qudwah yang mulia dan luar biasa.

Kaum Muslimin yang dirahmati Allah
Ramadhan mesti menjadikan kita dan keluarga semakin bersemangat dalam beribadah, termasuk Shalat Tarawih dengan mengajak anak-anak turut serta, baik di masjid maupun di rumah. Perhatian untuk menjaga shalat di tengah keluarga telah Allah perintahkan sebagaimana firman Allah dalam surat Thaha ayat 132:''',
        },
        {
          'type': 'arabic',
          'content': '''وَأْمُرْ أَهْلَكَ بِٱلصَّلَوٰةِ وَٱصْطَبِرْ عَلَيْهَا ۖ لَا نَسْـَٔلُكَ رِزْقًا ۖ نَّحْنُ نَرْزُقُكَ ۗ وَٱلْعَٰقِبَةُ لِلتَّقْوَىٰ''',
          'translation': '''Dan perintahkanlah kepada keluargamu mendirikan shalat dan bersabarlah kamu dalam mengerjakannya. Kami tidak meminta rezeki kepadamu, Kamilah yang memberi rezeki kepadamu. Dan akibat (yang baik) itu adalah bagi orang yang bertakwa.''',
        },
        {
          'type': 'text',
          'content': '''Selain itu orang tua dapat mengajarkan anak-anak untuk peduli kepada sesama dengan memberikan sedekah, makanan untuk buka puasa, atau membantu orang yang membutuhkan. Salah satu momen yang dapat mempererat hubungan keluarga adalah makan sahur dan berbuka puasa bersama.

Kesempatan emas ini dapat digunakan untuk berkumpul, berbagi cerita, serta menciptakan suasana kebersamaan di rumah. Sudah seyogianya kita mengajak keluarga untuk mencari keberkahan di bulan ini dengan  berdoa bersama setelah shalat atau menjelang berbuka. Anak-anak mesti terus dilatih dalam ibadah kepada Allah, termasuk dalam ibadah puasa. Inilah akhlak yang telah diwariskan para sahabat, sebagaimana disebutkan dalam hadits riwayat Imam Al-Bukhari:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنِ الرُّبَيِّعِ بِنْتِ مُعَوِّذٍ، قَالَتْ: أَرْسَلَ النَّبِيُّ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ غَدَاةَ عَاشُورَاءَ إِلَى قُرَى الأَنْصَارِ: مَنْ أَصْبَحَ مُفْطِرًا، فَلْيُتِمَّ بَقِيَّةَ يَوْمِهِ وَمَنْ أَصْبَحَ صَائِمًا، فَليَصُمْ، قَالَتْ: فَكُنَّا نَصُومُهُ بَعْدُ، وَنُصَوِّمُ صِبْيَانَنَا، وَنَجْعَلُ لَهُمُ اللُّعْبَةَ مِنَ العِهْنِ، فَإِذَا بَكَى أَحَدُهُمْ عَلَى الطَّعَامِ أَعْطَيْنَاهُ ذَاكَ حَتَّى يَكُونَ عِنْدَ الإِفْطَارِ''',
          'translation': '''“Diriwayatkan dari Ar-Rubayyi’ binti Muawwidz, ia berkata: 'Nabi Muhammad saw memberi arahan pada pagi Hari Asyura kepada masyarakat Anshar:  'Barangsiapa telah makan atau minum maka hendaknya ia sempurnakan sisa harinya (dengan menahan) dan barangsiapa yang masih berpuasa maka teruskanlah.' ''',
        },
        {
          'type': 'text',
          'content': '''Ar-Rubayyi’ berkata: 'Saat itu kami semua berpuasa, dan melatih anak-anak kami berpuasa. Kami membuat mainan dari kapas. Jika salah satu dari mereka menangis meminta makanan, kami memberikan mainan itu hingga datang waktu buka puasa'.”

Kaum Muslimin yang dimuliakan Allah

Mari bersemangat membiasakan anak anak dalam ibadah shalat, berpuasa dan juga dekat dengan kegiatan sosial seperti memberikan takjil, mengajak anak dalam membagikan makanan berbuka, membantu orang tua yang kurang mampu menjadi pembelajaran bagi anak-anak tentang pentingnya gotong royong dan menolong sesama.

Nasehat Luqman kepada anaknya agar selalu berbuat kebaikan, terekam dalam Firman Allah surat Luqman ayat 17:''',
        },
        {
          'type': 'arabic',
          'content': '''يَـٰبُنَىَّ أَقِمِ ٱلصَّلَوٰةَ وَأْمُرْ بِٱلْمَعْرُوفِ وَٱنْهَ عَنِ ٱلْمُنكَرِ وَٱصْبِرْ عَلَىٰ مَآ أَصَابَكَ ۖ إِنَّ ذَٰلِكَ مِنْ عَزْمِ ٱلْأُمُورِ''',
          'translation': '''Wahai anakku! Laksanakanlah shalat dan suruhlah (manusia) berbuat yang ma’ruf dan cegahlah (mereka) dari yang mungkar dan bersabarlah terhadap apa yang menimpamu. Sesungguhnya yang demikian itu termasuk perkara yang penting.''',
        },
        {
          'type': 'text',
          'content': '''Dari sini pendidikan keluarga  di bulan Ramadhan memiliki peran yang sangat penting dalam membentuk karakter anak-anak ke depannya. Mari memanfaatkan bulan Ramadhan untuk menanamkan Pendidikan kepada keluarga khusus anak-anak kita, generasi masa depan.

Semoga Ramadhan ini dapat menjadikan keluarga kita sebagai keluarga yang diridhai Allah dan dicintai Rasulullah saw. Amin.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ الله لِي وَلَكُمْ فِى اْلقُرْآنِ اْلعَظِيْمِ، وَنَفَعَنِي وَإِيَّاكُمْ بِمَافِيْهِ مِنْ آيَةِ وَذِكْرِ الْحَكِيْمِ وَتَقَبَّلَ اللهُ مِنَّا وَمِنْكُمْ تِلاَوَتَهُ وَإِنَّهُ هُوَ السَّمِيْعُ العَلِيْمُ، وَأَقُوْلُ قَوْلِي هَذَا فَأسْتَغْفِرُ اللهَ العَظِيْمَ إِنَّهُ هُوَ الغَفُوْرُ الرَّحِيْم''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ ِللهِ عَلىَ إِحْسَانِهِ وَالشُّكْرُ لَهُ عَلىَ تَوْفِيْقِهِ وَاِمْتِنَانِهِ. أَشْهَدُ أَنْ لاَ اِلَهَ إِلاَّ اللهُ وَاللهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ وَأَشْهَدُ أنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ الدَّاعِى إلىَ رِضْوَانِهِ. اَللّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وِعَلَى اَلِهِ وَأَصْحَابِهِ وَسَلِّمْ تَسْلِيْمًا كِثيْرًا. أَمَّا بَعْدُ، فَياَ اَيُّهَا النَّاسُ، اِتَّقُوا اللهَ فِيْمَا أَمَرَ وَانْتَهُوْا عَمَّا نَهَى وَاعْلَمُوْا أَنَّ اللهَ أَمَرَكُمْ بِأَمْرٍ بَدَأَ فِيْهِ بِنَفْسِهِ وَثَـنَى بِمَلآ ئِكَتِهِ بِقُدْسِهِ، وَقَالَ تَعاَلَى: إِنَّ اللهَ وَمَلآئِكَتَهُ يُصَلُّوْنَ عَلىَ النَّبِى، يآ اَيُّهَا الَّذِيْنَ آمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا. اَللّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلِّمْ وَعَلَى آلِ سَيِّدِناَ مُحَمَّدٍ وَعَلَى اَنْبِيآئِكَ وَرُسُلِكَ وَمَلآئِكَةِ اْلمُقَرَّبِيْنَ، وَارْضَ اللّهُمَّ عَنِ اْلخُلَفَاءِ الرَّاشِدِيْنَ أَبِى بَكْرٍ وَعُمَر وَعُثْمَان وَعَلِى وَعَنْ بَقِيَّةِ الصَّحَابَةِ وَالتَّابِعِيْنَ وَتَابِعِي التَّابِعِيْنَ لَهُمْ بِاِحْسَانٍ اِلَىيَوْمِ الدِّيْنِ، وَارْضَ عَنَّا مَعَهُمْ بِرَحْمَتِكَ يَا أَرْحَمَ الرَّاحِمِيْنَ. اَللّهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَاْلمُؤْمِنَاتِ وَاْلمُسْلِمِيْنَ وَاْلمُسْلِمَاتِ اَلاَحْيآءُ مِنْهُمْ وَاْلاَمْوَاتِ. اَللّهُمَّ أَعِزَّ اْلإِسْلاَمَ وَاْلمُسْلِمِيْنَ وَأَذِلَّ الشِّرْكَ وَاْلمُشْرِكِيْنَ وَانْصُرْ عِبَادَكَ اْلمُوَحِّدِيَّةَ وَانْصُرْ مَنْ نَصَرَ الدِّيْنَ وَاخْذُلْ مَنْ خَذَلَ اْلمُسْلِمِيْنَ وَ دَمِّرْ أَعْدَاءَ الدِّيْنِ وَاعْلِ كَلِمَاتِكَ إِلَى يَوْمَ الدِّيْنِ. اَللّهُمَّ ادْفَعْ عَنَّا اْلبَلاَءَ وَاْلوَبَاءَ وَالزَّلاَزِلَ وَاْلمِحَنَ وَسُوْءَ اْلفِتْنَةِ وَاْلمِحَنَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا اِنْدُونِيْسِيَّا خآصَّةً وَسَائِرِ اْلبُلْدَانِ اْلمُسْلِمِيْنَ عآمَّةً يَا رَبَّ اْلعَالَمِيْنَ. رَبَّنَا آتِناَ فِى الدُّنْيَا حَسَنَةً وَفِى اْلآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ. رَبَّنَا ظَلَمْنَا اَنْفُسَنَا وَاإنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُوْنَنَّ مِنَ اْلخَاسِرِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَاللهِ! إِنَّ اللهَ يَأْمُرُنَا بِاْلعَدْلِ وَاْلإِحْسَانِ وَإِيْتآءِ ذِي اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشآءِ وَاْلمُنْكَرِ وَاْلبَغْي يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ وَاذْكُرُوا اللهَ اْلعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلىَ نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللهِ أَكْبَرْ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Azmi Abubakar, Penyuluh Agama Islam asal Aceh.''',
        },
      ]
    },
    {
      'title': 'Khutbah Jumat: Ini Amal dengan Pahala Terbaik bagi Orang Puasa Ramadhan',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Allah Swt memberikan pahala yang besar kepada setiap hambanya yang mengerjakan puasa Ramadhan. Bahkan hanya diri-Nya saja yang secara pasti mengetahui jumlah ganjaran tersebut. Namun ternyata di sisi lain, Allah menyiapkan balasan terbaik bagi orang-orang yang berpuasa sembari mengingat Allah Swt.

Naskah Khutbah Jumat berjudul, “Khutbah Jumat: Ini Amal dengan Pahala Terbaik bagi Orang Puasa Ramadhan”, mengajak kaum Muslimin untuk memaksimalkan potensi ibadah dengan selalu mengingat Allah selama bulan suci Ramadhan berlangsung.

Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''إِنَّ الْحَمْدَ لِلّٰهِ، نَحْمَدُهُ وَنَسْتَعِيْنُهُ وَنَسْتَغْفِرُهُ وَنَعُوْذُ بِاللّٰهِ مِنْ شُرُوْرِ أَنْفُسِنَا وَمِنْ سَيِّئَاتِ أَعْمَالِنَا، مَنْ يَهْدِهِ اللّٰهُ فَلَا مُضِلَّ لَهُ وَمَنْ يُضْلِلْ فَلَا هَادِيَ لَهُ. أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ. اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ أَجْمَعِيْنَ. اَمَّا بَعْدُ، فَيَا اَيُّهَا الْمُسْلِمُوْنَ، اتَّقُوا اللّٰهَ وَقُوْلُوْا قَوْلًا سَدِيْدًاۙ يُّصْلِحْ لَكُمْ اَعْمَالَكُمْ وَيَغْفِرْ لَكُمْ ذُنُوْبَكُمْۗ وَمَنْ يُّطِعِ اللّٰهَ وَرَسُوْلَهٗ فَقَدْ فَازَ فَوْزًا عَظِيْمًا. فَقَدْ قَالَ اللّٰهُ تَعَالَى  فِي كِتَابِهِ الْكَرِيْمِ: يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوْا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَۙ''',
        },
        {
          'type': 'text',
          'content': '''Jamaah kaum Muslimin yang dirahmati Allah
Khatib berpesan bagi diri sendiri dan jamaah sekalian, mari kita tingkatkan ketakwaan kepada Allah swt dengan sebenar-benarnya takwa dan selalu berusaha untuk berkata baik. Harapannya, Allah akan memperbaiki seluruh amal ibadah dan mengampuni segala dosa yang telah kita kerjakan selama hidup di dunia ini. Sebagaimana firman-Nya dalam Al-Qur’an Surat Al-Ahzab ayat 70-71:''',
        },
        {
          'type': 'arabic',
          'content': '''يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوا اتَّقُوا اللّٰهَ وَقُوْلُوْا قَوْلًا سَدِيْدًاۙ يُّصْلِحْ لَكُمْ اَعْمَالَكُمْ وَيَغْفِرْ لَكُمْ ذُنُوْبَكُمْۗ وَمَنْ يُّطِعِ اللّٰهَ وَرَسُوْلَهٗ فَقَدْ فَازَ فَوْزًا عَظِيْمًا''',
          'translation': '''Wahai orang-orang yang beriman, bertakwalah kamu kepada Allah dan ucapkanlah perkataan yang benar. Niscaya Dia (Allah) akan memperbaiki amal-amalmu dan mengampuni dosa-dosamu. Siapa yang menaati Allah dan Rasul-Nya, sungguh, dia menang dengan kemenangan yang besar.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah kaum Muslimin yang dirahmati Allah

Sungguh, Allah swt telah menjadikan bulan suci Ramadhan sebagai momentum terbaik untuk memperbaiki kualitas dan menambah kuantitas amal saleh yang kita kerjakan. Sebab selama sebulan penuh, Allah menurunkan kepada para hambanya keberkahan yang sangat melimpah. Ganjaran pahala ditingkatkan, pintu surga dibukakan, gerbang neraka dikuncikan dan setan dibelenggu agar tidak dapat mengganggu manusia.

Apalagi terkhusus dalam ibadah puasa Ramadhan, Allah swt memberikan ganjaran pahala yang besar bagi siapa saja yang mengerjakannya dengan penuh keikhlasan dan mengharapkan ridha-Nya. Sebagaimana hadits qudsi yang diriwayatkan oleh Imam Al-Bukhari, bersumber dari Abu Hurairah ra:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللهُ عَنْهُ، عَنِ النَّبِيِّ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ قَالَ: كُلُّ ‌عَمَلِ ‌ابْنِ ‌آدَمَ لَهُ إِلَّا الصَّوْمَ، فَإِنَّهُ لِي وَأَنَا أَجْزِي بِهِ، وَلَخُلُوفُ فَمِ الصَّائِمِ أَطْيَبُ عِنْدَ اللَّهِ مِنْ رِيحِ الْمِسْكِ''',
          'translation': '''"Dari Abu Hurairah Ra, dari Nabi Muhammad Saw, Ia bersabda, “(Allah berfirman) Setiap perbuatan keturunan Adam itu diperuntukkan bagi dirinya kecuali puasa, karena ibadah tersebut untukku dan aku sendiri yang akan memberikan ganjarannya. Sungguh perubahan aroma mulut orang yang berpuasa lebih harum di sisi Allah dibandingkan dengan parfum.” (HR Al-Bukhari).''',
        },
        {
          'type': 'text',
          'content': '''Jamaah kaum Muslimin yang dirahmati Allah

Selain karena keagungan bulan suci Ramadhan dengan segala keberkahan yang dimilikinya dan ibadah puasa dengan ganjaran besar yang menyertainya, ternyata Allah Swt masih menyediakan alternatif ibadah lain yang tidak kalah istimewa untuk orang-orang Islam selama bulan Ramadhan berlangsung. Yakni, dengan selalu berusaha mengingat Allah swt.

Disebutkan bahwa siapa saja yang mengerjakannya akan masuk ke dalam golongan orang-orang terbaik yang menjalankan ibadah puasa Ramadhan, sebagaimana penjelasan Nabi Muhammad saw ketika ditanya oleh seorang laki-laki:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنْ سَهْلِ بْنِ مُعَاذِ بْنِ أَنَسٍ، عَنْ أَبِيهِ، عَنْ رَسُولِ اللهِ أَنَّ رَجُلًا سَأَلَهُ فَقَالَ: ‌أَيُّ ‌الْمُجَاهِدِينَ ‌أَعْظَمُ ‌أَجْرًا؟ قَالَ: أَكْثَرُهُمْ لِلَّهِ ذِكْرًا ، قَالَ: وَأَيُّ الصَّائِمِينَ أَعْظَمُ لِلَّهِ أَجْرًا؟ قَالَ: أَكْثَرُهُمْ لِلَّهِ ذِكْرًا ، ثُمَّ ذَكَرَ الصَّلَاةَ وَالزَّكَاةَ وَالْحَجَّ وَالصَّدَقَةَ، كُلُّ ذَلِكَ رَسُولُ اللهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ يَقُولُ: أَكْثَرُهُمْ لِلَّهِ ذِكْرًا''',
          'translation': '''"Dari Sahl bin Mu’adz bin Anas, dari bapaknya, dari Rasulullah Saw, bahwasanya ada seorang laki-laki yang bertanya kepadanya: Orang berjihad di jalan Allah seperti apa yang memperoleh ganjaran pahala paling besar? Rasul menjawab, mereka yang paling banyak mengingat Allah.''',
        },
        {
          'type': 'text',
          'content': '''Laki-laki itu bertanya lagi, lalu, orang berpuasa seperti apa yang mendapatkan pahala yang paling banyak? Rasul menjawab, mereka yang paling banyak mengingat Allah. Kemudian laki-laki tersebut bertanya lagi tentang shalat, zakat, haji dan sedekah, setiap pertanyaannya selalu dijawab oleh Rasulullah, (bahwa orang yang meraih pahala paling banyak, ialah) mereka yang paling banyak mengingat Allah swt." (HR At-Thabarani).

Jamaah kaum Muslimin yang dirahmati Allah

Secara tegas juga telah disebutkan, orang-orang yang senantiasa mengingat Allah swt di manapun mereka berada akan diberikan ampunan dan pahala yang besar. Sebagaimana secara jelas dalam Al-Qur’an surat Al-Ahzab ayat 35, Allah berfirman yang artinya:

“Laki-laki dan perempuan yang banyak mengingat (nama) Allah, untuk mereka Allah telah menyiapkan ampunan dan pahala yang besar.”

Demikianlah, mari kita maksimalkan segala potensi amal baik selama bulan suci Ramadhan ini dengan selalu mengingat Allah swt dalam setiap aktivitas yang sedang dijalankan, sebagai bentuk ikhtiar guna memperoleh pahala yang banyak dan mempermudah meraih predikat insan yang bertakwa.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللهُ لِيْ وَلَكُمْ فِي الْقُرْآنِ الْعَظِيْمِ، وَنَفَعَنِيْ وَإِيَّاكُمْ بِمَا فِيْهِ مِنَ اْلآيَاتِ وَالذِّكْرِ الْحَكِيْمِ. أَقُوْلُ قَوْلِيْ هَذَا وَأَسْتَغْفِرُ اللهَ لِيْ وَلَكُمْ وَلِلْمُسْلِمِيْنَ فَاسْتَغْفِرُوْهُ إِنَّهُ هُوَ الْغَفُوْرُ الرَّحِيْمُ''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ عَلىَ إِحْسَانِهِ، وَالشُّكْرُ لَهُ عَلَى تَوْفِيْقِهِ وَامْتِنَانِهِ. أَشْهَدُ أَنْ لَا اِلَهَ إِلاَّ اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ الدَّاعِى إلَى رِضْوَانِهِ. اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى اٰلِهِ وَاَصْحَابِهِ وَسَلِّمْ تَسْلِيْمًا كَثِيْرًا. أَمَّا بَعْدُ، فَيَا أَيُّهَا المُسْلِمُوْنَ، اِتَّقُوْا اللّٰهَ فِيْمَا أَمَرَ وَانْتَهُوْا عَمَّا نَهَى وَاعْلَمُوْا أَنَّ اللّٰهَ أَمَرَكُمْ بِأَمْرٍ بَدَأَ فِيْهِ بِنَفْسِهِ وَثَـنَّى بِمَلآئِكَتِهِ بِقُدْسِهِ وَقَالَ تَعَالَى: إِنَّ اللّٰهَ وَمَلآئِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّ، يَآ اَيُّهَا الَّذِيْنَ آمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا. اللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَّى اللّٰهُ عَلَيْهِ وَسَلَّمَّ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ وَعَلَى اَنْبِيَآئِكَ وَرُسُلِكَ وَمَلَآئِكَةِ اْلمُقَرَّبِيْنَ، وَارْضَ اللّٰهُمَّ عَنِ اْلخُلَفَاءِ الرَّاشِدِيْنَ أَبِى بَكْرٍ وَعُمَرَ وَعُثْمَانَ وَعَلِيِّ وَعَنْ بَقِيَّةِ الصَّحَابَةِ وَالتَّابِعِيْنَ وَتَابِعِيْ التَّابِعِيْنَ لَهُمْ بِاِحْسَانٍ اِلَى يَوْمِ الدِّيْنِ وَارْضَ عَنَّا مَعَهُمْ بِرَحْمَتِكَ يَا اَرْحَمَ الرَّاحِمِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَاْلمُؤْمِنَاتِ وَاْلمُسْلِمِيْنَ وَاْلمُسْلِمَاتِ اَلاَحْيَآءِ مِنْهُمْ وَاْلاَمْوَاتِ. اللّٰهُمَّ أَعِزَّ اْلإِسْلَامَ وَاْلمُسْلِمِيْنَ وَأَذِلَّ الشِّرْكَ وَاْلمُشْرِكِيْنَ وَانْصُرْ عِبَادَكَ اْلمُوَحِّدِيَّةَ وَانْصُرْ مَنْ نَصَرَ الدِّيْنَ وَاخْذُلْ مَنْ خَذَلَ اْلمُسْلِمِيْنَ وَ دَمِّرْ أَعْدَاءَ الدِّيْنِ وَاعْلِ كَلِمَاتِكَ إِلَى يَوْمِ الدِّيْنِ. اللّٰهُمَّ ادْفَعْ عَنَّا اْلبَلاَءَ وَاْلوَبَاءَ وَالزَّلاَزِلَ وَالمِحَنَ وَسُوْءَ الفِتَنِ وَالمِحَنِ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا اِنْدُونِيْسِيَّا خَآصَّةً وَسَائِرِ اْلبُلْدَانِ اْلمُسْلِمِيْنَ عَآمَّةً يَا رَبَّ اْلعَالَمِيْنَ. رَبَّنَا ظَلَمْنَا اَنْفُسَنَا وَاِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُوْنَنَّ مِنَ اْلخَاسِرِيْنَ. رَبَّنَا آتِنَا فِى الدُّنْيَا حَسَنَةً وَفِى اْلآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللّٰهِ! إِنَّ اللّٰهَ يَأْمُرُ بِاْلعَدْلِ وَاْلإِحْسَانِ وَإِيْتآءِ ذِيْ اْلقُرْبٰى وَيَنْهَى عَنِ اْلفَحْشآءِ وَاْلمُنْكَرِ وَاْلبَغْيِ يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ وَاذْكُرُوْا اللّٰهَ اْلعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلَى نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللّٰهِ أَكْبَرُ وَ اللّٰهُ يَعْلَمُ مَا تَصْنَعُوْنَ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Muhaimin Yasin, Alumnus Pondok Pesantren Ishlahul Muslimin Lombok Barat dan Pegiat Kajian Keislaman''',
        },
      ]
    },
    {
      'title': 'Khutbah Jumat: Melihat Tabiat Buruk Manusia dalam Al-Quran',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Pepatah mengatakan, jika tidak tahu penyakit, maka kita sulit menemukan obatnya. Demikian halnya dengan sifat dan tabiat yang menimpa diri manusia. Jika belum mampu mengidentifikasi sifat dan tabiat buruk tersebut, bagaimana kita bisa mengatasinya.

Maka khutbah Jumat kali ini, “Melihat Tabiat Buruk Manusia dalam Al-Quran,” berusaha menguraikan sebagian tabiat buruk yang diungkap oleh Al-Quran. Dengan harapan, setelah mengetahui dan menyadarinya, kita lebih mudah mengobatinya. Untuk mencetak, silakan klik fitur download warna merah di desktop pada bagian atas naskah khutbah ini.

Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ للهِ الَّذِي بِنِعْمَتِهِ اهْتَدَى الْمُهْتَدُوْنَ، وَبِعَدْلِهِ ضَلَّ الضَّالُّوْنَ. أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ. وَسُبْحَانَ اللهِ رَبِّ الْعَرْشِ عَمَّا يَصِفُوْنَ. وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ وَخَلِيْلُهُ الصَّادِقُ الْمَأْمُوْنِ. اَللَّهُمَّ صَلِّ عَلَى عَبْدِكَ وَرَسُوْلِكَ مُحَمَّدٍ وَعَلَى آلِهِ وَأَصْحَابِهِ الَّذِيْنَ هُمْ بِهَدْيِهِ مُسْتَمْسِكُوْنَ، وَسَلِّمْ تَسْلِيْمًا كَثِيْرًا.''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ، فَيَا أَيُّهَا النَّاسُ، اِتَّقُوا اللهَ حَقَّ تُقَاتِهِ. وَسَارِعُوا إِلَى مَغْفِرَتِهِ، قَالَ اللهُ تَعَالَى فِي الْقُرْآنِ الْعَظِيْمِ  أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ، بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ. إِنَّ ٱلۡإِنسَٰنَ خُلِقَ هَلُوعًا، إِذَا مَسَّهُ ٱلشَّرُّ جَزُوعا، وَإِذَا مَسَّهُ ٱلۡخَيۡرُ مَنُوعًا،صَدَقَ اللهُ الْعَظِيْمُ''',
        },
        {
          'type': 'text',
          'content': '''Sidang Jumah yang dirahmati Allah

Pertama marilah kita panjatkan puji dan syukur ke hadirat Allah SWT. Dzat yang tak henti-hentinya melimpahkan karunia dan nikmat-Nya kepada kita semua. Shalawat teriring salam semoga tercurah kepada Baginda Alam, Habibana Muhammad SAW, juga kepada para sahabat, para tabiin, tabi’ tabiin-nya, hingga kepada kita semua selaku umatnya.

Tak lupa melalui mimbar yang mulia ini, khatib berwasiat khusus kepada diri sendiri, umum kepada jamaah Jumat sekalian, marilah kita sama-sama meningkatkan keimanan dan ketakwaan kepada Allah. Sebab, hanya dengan bekal iman dan takwa kita bisa lebih memaksimalkan ketaatan kita kepada-Nya dan menjauhkan diri dari segala bentuk larangan-Nya.

Sidang Jumah yang dirahmati Allah

Selaku manusia kita terkadang tidak sadar akan tabiat asli dan kelemahan diri kita sendiri. Akibatnya, kita tak bisa lepas dari tabiat dan kelemahan itu. Padahal, jauh-jauh hari, Allah telah menggambarkan bagaimana sifat, tabiat, dan kelemahan tersebut.

Di antara sifat dan tabiat manusia yang diungkap Allah dalam surah Al-Ma’arij ayat 19-21 adalah:''',
        },
        {
          'type': 'arabic',
          'content': '''إِنَّ ٱلۡإِنسَٰنَ خُلِقَ هَلُوعًا، إِذَا مَسَّهُ ٱلشَّرُّ جَزُوعٗا، وَإِذَا مَسَّهُ ٱلۡخَيۡرُ مَنُوعًا''',
          'translation': '''“Sesungguhnya manusia diciptakan dengan sifat keluh kesah. Apabila ditimpa keburukan (kesusahan), ia berkeluh kesah. Apabila mendapat kebaikan (harta), ia amat kikir,” (QS. Al-Ma’arij [70]: 19-21).''',
        },
        {
          'type': 'text',
          'content': '''Lantas, siapa yang dimaksud dengan “manusia” pada ayat tersebut? Menurut Al-Qurthubi, maksud manusia dalam ayat itu adalah manusia yang beriman, mengingat pada ayat ke-22-nya, disebutkan “kecuali orang-orang yang shalat.”

Orang yang shalat dalam konteks ini tentu orang yang beriman. Sementara makna kufur pada Tafsir al-Qurthubi, kufur dalam pengertian kufur nikmat dan tidak bersyukur. Dan sifat ini tidak hanya dimiliki orang yang kafir, karena dalam tubuh orang mukmin sendiri pun masih kerap dijumpai. Lihat: Tafsir Al-Quthubi, terbitan Darul Kutub, Kairo Tahun 1964, Jilid 2, hal. 289.

Sidang Jumah yang dirahmati Allah

Setidaknya ada tiga sifat yang disebutkan dalam ayat di atas, yaitu halu’a, jazu’a, dan manu’a:

Pertama, manusia memiliki sifat halu’a, yakni sifat ingkar, tak pernah kenyang, mudah bosan, dan tak sabar, sebagaimana tafsir ayat:''',
        },
        {
          'type': 'arabic',
          'content': '''إِنَّ ٱلۡإِنسَٰنَ خُلِقَ هَلُوعًا''',
        },
        {
          'type': 'text',
          'content': '''Mengutip pendapat Adh-Dhahak, Al-Qurthubi dalam Tafsirnya menyebutkan, makna kata halu’a di sana adalah ‘kufur’ dalam arti ingkar, tidak syukur, dan dan tidak mengakui nikmat Allah.

Lebih lanjut Al-Qurthubi menjelaskan, secara bahasa, menurut Mujahid dan Qatadah, kata halu’a artinya keinginan yang menggebu gebu dan keluhan terburuk. Ada pula yang memaknai kata halu’a dengan tidak sabar jika menginginkan kebaikan atau keburukan, sehingga mudah melakukan sesuatu yang tak pantas.

Kemudian menurut Ikrimah, halu’a artinya ‘mudah bosan’ dan ‘mudah lelah’, sedangkan menurut Adh-Dhahak, artinya bisa juga tidak pernah kenyang.

Sidang Jumah yang dirahmati Allah

Kedua, manusia memiliki sifat jazu’a, artinya suka mengeluh, terutama saat ditimpa keburukan, sebagaimana tafsir ayat:''',
        },
        {
          'type': 'arabic',
          'content': '''إِذَا مَسَّهُ ٱلشَّرُّ جَزُوعٗا''',
        },
        {
          'type': 'text',
          'content': '''Pada ayat berikutnya, Allah menjelaskan sifat manusia lainnya, yakni memiliki sifat jazu’a. Menurut Tsa’lab, penjelasan sifat jazu’a sendiri adalah, ketika ditimpa keburukan, manusia suka mengeluh, mengadu, protes, tidak syukur, dan tidak bersabar.

Jadi sampai di sini, manusia itu memiliki sifat bawaan: kufur, ingkar, suka mengeluh, resah, gundah, galau, mudah bosan, tidak sabar, terutama di saat mengebu-gebunya keinginan dan harapan. Ia terbelenggu oleh keinginannya sendiri. Akibatnya, jika keinginan itu tidak tercapai, ia mudah frustasi dan menyalahkan siapa saja.

Ketiga, manusia memiliki sifat manu’a, yaitu ketika diberi kebaikan, ia kikir, pelit, dan tidak syukur.''',
        },
        {
          'type': 'arabic',
          'content': '''وَإِذَا مَسَّهُ ٱلۡخَيۡرُ مَنُوعًا''',
        },
        {
          'type': 'text',
          'content': '''Masih menurut Tsa’lab, jika mendapat kebaikan, nikmat, atau anugerah, manusia suka kikir, tidak mau berbagi, bahkan tidak ingat kepada yang menganugerahinya.

Walhasil, seperti yang ditegaskan Ibnu Kaisan, manusia itu tercipta dalam keadaan gemar menyukai apa yang disenangi dan diridainya serta menjauhi apa yang tidak disukai dan dibencinya. Padahal, Allah memerintah untuk menginfakkan apa yang disukainya dan bersabar menghadapi perkara yang tidak disukai. Sehingga tak heran, menurut Abu Ubaidah, jika ditimpa kebaikan, manusia itu tidak mau bersyukur, serta ditimpa kesusahan tidak mau bersabar.

Manusia terkadang lupa, dirinya hanya bisa berkeinginan, yang menentukan tetaplah Allah. Sebesar apa pun keinginan, keputusannya tetap harus sesuai dengan kehendak Allah. Sekuat apa pun pun usaha, tidak akan mampu menembus benteng takdir. Demikian seperti yang diungkapkan oleh Syekh Ibnu ‘Athaillah dalam Hikam-nya.''',
        },
        {
          'type': 'arabic',
          'content': '''سَوَابِقُ الْهِمَمِ لَا تَخْرِقُ أَسْوَارَ الْأَقْدَارِ''',
          'translation': '''“Menggebunya keinginan tidak akan mampu menerobos benteng takdir.” (Lihat: Syarah Al-Hikam, Syekh Muhammad bin Ibrahim, [T.tp: Thaha Putra, t.t]. halaman 6).''',
        },
        {
          'type': 'text',
          'content': '''Obat dari semua tabiat dan sifat buruk itu adalah berpegang pada apa yang sudah diterangkan Allah dalam ayat berikutnya, yaitu:''',
        },
        {
          'type': 'arabic',
          'content': '''إِلَّا ٱلۡمُصَلِّينَ، ٱلَّذِينَ هُمۡ عَلَىٰ صَلَاتِهِمۡ دَآئِمُونَ، وَٱلَّذِينَ فِيٓ أَمۡوَٰلِهِمۡ حَقّٞ مَّعۡلُومٞ، لِّلسَّآئِلِ وَٱلۡمَحۡرُومِ''',
          'translation': '''“…kecuali orang-orang yang melaksanakan shalat, mereka yang tetap setia melaksanakan shalatnya, dan orang-orang yang dalam hartanya disiapkan bagian tertentu, bagi orang (miskin) yang meminta dan yang tidak meminta,” (QS. Al-Ma’arij [70]: 22-30).''',
        },
        {
          'type': 'text',
          'content': '''Masih ada beberapa ayat lanjutan ayat di atas, namun secara ringkas Allah memberikan penawar atas semua sifat dan tabiat buruk kita di atas, yaitu (1) shalat dengan istiqamah, (2) menyisihkan sebagian harta bagi orang-orang yang tak mampu, (3) membenarkan hari pembalasan, (4) merasa tidak aman atas siksaan Allah, (5) menjaga kemaluan kecuali kepada istri.

Sidang Jumah yang dirahmati Allah

Demikian tabiat buruk kita sebagai manusia. Karena itu, marilah kita berusaha menjauhi sifat-sifat tersebut dengan bersungguh-sungguh mengambil penawarnya. Semoga kita termasuk orang-orang yang berpuasa dan mampu menjauhi semua sifat buruk itu.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللهُ لِيْ وَلَكُمْ فِي الْقُرْآنِ الْعَظِيْمِ، وَنَفَعَنِيْ وَإِيَّاكُمْ بِمَا فِيْهِ مِنَ اْلآيَاتِ وَالذِّكْرِ الْحَكِيْمِ، وَتَقَبَّلَ اللهُ مِنِّيْ وَمِنْكُمْ تِلاَوَتَهُ، إِنَّهُ هُوَ السَّمِيْعُ الْعَلِيْمُ، أَقُوْلُ قَوْلِيْ هَذَا وَأَسْتَغْفِرُ اللهَ الْعَظِيْمَ لِيْ وَلَكُمْ وَلِسَائِرِ الْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ فَاسْتَغْفِرُوْهُ إِنّهُ هُوَ الْغَفُوْرُ الرّحِيْمُ''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلَّهِ الَّذِيْ أَمَرَنَا بِاْلاِتِّحَادِ وَاْلاِعْتِصَامِ بِحَبْلِ اللهِ الْمَتِيْنِ. أَشْهَدُ أَنْ لَا إِلٰهَ إِلاَّ اللهُ وَحْدَهُ لاَشَرِيْكَ لَهُ، إِيَّاهُ نَعْبُدُ وَإِيَّاهُ نَسْتَعِيْنُ. وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ، اَلْمَبْعُوْثُ رَحْمَةً لِلْعَالَمِيْنَ. اِتَّقُوا اللهَ مَا اسْتَطَعْتُمْ وَسَارِعُوْا إِلَى مَغْفِرَةِ رَبِّ الْعَالَمِيْنَ. إِنَّ اللهَ وَمَلاَئِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّ، يَاأَيُّهَا الَّذِيْنَ ءَامَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا. اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَأَصْحَابِهِ أَجْمَعِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ وَالْمُسْلِمِيْنَ وَ الْمُسْلِمَاتِ اَلاَحْيَاءِ مِنْهُمْ وَالْاَمْوَاتْ إِنَّكَ سَمِيْعٌ قَرِيْبٌ مُجِيْبُ الدَّعَوَاتِ وَيَا قَاضِيَ الْحَاجَاتِ بِرَحْمَتِكَ يَا اَرْحَمَ الرَّحِمِيْنَ.   اَللّٰهُمَّ يَا مُيَسِّرَ كُلِّ عَسِيْرٍ ، وَيَا جَابِرَ كُلِّ كَسِيْرٍ، وَيَا صَاحِبَ كُلِّ فَرِيْدٍ، وَيَا مُغْنِيَ كُلِّ فَقِيْرٍ، وَيَا مُقَوِّيَ كُلِّ ضَعِيْفٍ، وَيَا مَأْمَنَ كُلِّ مَخِيْفٍ، يَسِّرْ عَلَيْنَا كُلَّ عَسِيْرٍ، فَتَيْسِيْرُ الْعَسِيْرِ عَلَيْكَ يَسِيْرُ، رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ، إِنَّ اللهَ يَأْمُرُ بِالْعَدْلِ وَاْلإِحْسَانِ وَإِيتَآئِ ذِي الْقُرْبَى وَيَنْهَى عَنِ الْفَحْشَآءِ وَالْمُنكَرِ وَالْبَغْيِ يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ. فَاذْكُرُوا اللهَ الْعَظِيْمَ يَذْكُرْكُمْ وَادْعُوْهُ يَسْتَجِبْ لَكُمْ وَلَذِكْرُ اللهِ أَكْبَرُ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz M. Tatam Wijaya, Penyuluh dan Petugas KUA Sukanagara-Cianjur, Jawa Barat.''',
        },
      ]
    },
    {
      'title': 'Khutbah Bahasa Sunda: Ngahontal Darajat Takwa Ngalangkungan Puasa',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Di balik perintah Allah selalu tersimpan keutamaan, kemuliaan, rahasia, dan hikmah yang sangat mendalam. Demikian halnya dalam perintah melaksanakan ibadah puasa yang di dalamnya terdapat berbagai kemulian, salah satunya adalah mencapai derajat takwa.

Maka khutbah Jumat bahasa Sunda ini berjudul, “Khutbah Bahasa Sunda: Ngahontal Darajat Takwa Ngalangkungan Puasa”. Untuk mencetak khutbah ini, silakan klik fitur download berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ ِللهِ الَّذِي هَدَانَا لِلْإِسْلَامِ وَأَرْسَلَ إِلَيْنَا نَبِيَّهُ مُحَمَّدًا أَفْضَلَ الْأَنَامِ، وَفَصَّلَ أَحْكَامَ الصَّلَاةِ وَالصِّيَامِ، وَأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ الْمَلِكُ الْعَلَّامُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ أَفْضَلُ مَنْ صَلَّى لِرَبِّهِ وَصَامَ، اَللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِهِ وَأَصْحَابِهِ البَرَرَةِ الْكِرَامِ، وَسَلِّمْ تَسْلِيْماً كَثِيْرًا مَا دَامَتِ اللَّيَالِي وَالْأَيَّامُ''',
        },
        {
          'type': 'arabic',
          'content': '''أمَّا بَعْدُ، فَيَاعِبَادَ الرَّحْمٰنِ، فَإنِّي أُوْصِيْكُمْ وَنَفْسِي بِتَقْوَى اللهِ المَنَّانِ، الْقَائِلِ فِي كِتَابِهِ الْقُرْآنِ: أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ ، بِسۡمِ اللَّهِ الرَّحۡمَٰنِ الرَّحِيمِ ، يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ، صَدَقَ اللهُ الْعَظِيْمُ''',
        },
        {
          'type': 'text',
          'content': '''Sidang Jumah anu dimulyakeun ku Alloh

Ucapan syukur sareng alhamdulillah hayu urang jantenkeun pamuka khutbah. Sholawat sinareng salam mugia salamina sing dikucurkeun ka Jungjunan urang sadayana, miwah kulawarginana, para sahabatna, para tabiin, dugika urang sadayana salaku umatna.

Salajengna, ngalangkungan mimbar anu mulya ieu, khotib umajak ka sadayana ahli Jumah anu sami hadir, hayu urang satekah polah ningkatkeun kaimanan oge katakwaan ka Alloh swt, margi mung ukur modal takwa, urang sadayana tiasa janten hamba anu salamet dunya rawuh akherat.

Sidang Jumah anu dimulyakeun ku Alloh

Sakumaha kauninga, harepan tina ibadah puasa anu ku urang dilakonan teh nyaeta ngahontal darajat takwa. Hal ieu sakumaha anu ditetelakeun dina ayat suci Al-Quran anu parantos masyhur:''',
        },
        {
          'type': 'arabic',
          'content': '''يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ''',
        },
        {
          'type': 'text',
          'content': '''Hartosna, “He jalma-jalma anu iman, diwajibkeun ka aranjeun puasa sakumaha tos diwajibkeun ka jalmi-jalmi samemeh aranjeun supaya aranjeun takwa,” (QS. Al-Baqarah [2]: 183).

Ngalangkungan ieu ayat, urang uninga yen parentah puasa teh ditujukeun ka jalma-jalma anu iman. Salajengnya, salah sawios anu hoyong dihontal ngalangkungan puasa teh nyaeta takwa. Teras naon hubungan ari iman sareng takwa. Salah sawios hadits parantos netelakeun:''',
        },
        {
          'type': 'arabic',
          'content': '''الْإِيمَانُ ‌عُرْيَانٌ، وَلِبَاسُهُ التَّقْوَى''',
        },
        {
          'type': 'text',
          'content': '''Hartosna, “Ari iman teh saperti sataranjang, maka anggoannana teh nyaeta takwa,” (HR. Ibnu Abi Syaibah).

Numutkeun ieu hadits, takwa teh kalintang pentingna keur ngabunian sareng ngagindingan kaimanan urang. Ku penting-pentingna takwa, Alloh malihan kiat mulak-malik istilah takwa ieu dugika 15 kali dina Al-Qur’an.

Ieu  nunjukkan yen di antara tetekon pokok dina Islam teh nyaeta ayana takwa dina diri urang. Ku hal sakitu, teu heran takwa janten salah sawios ukuran luhur sareng henteuna darajat hiji hamba, sakumaha ditandeskeun dina Al-Qur’an:''',
        },
        {
          'type': 'arabic',
          'content': '''إِنَّ أَكْرَمَكُمْ عِنْدَ اللّٰهِ أَتْقَاكُمْ إِنَّ اللّٰهَ عَلِيمٌ خَبِيرٌ''',
        },
        {
          'type': 'text',
          'content': '''Hartosna, “Saenya-enyana anu paling mulya di antara aranjeun di payuneun Alloh nyaeta jalmi anu paling takwa,” (QS Al-Hujurat [49]: 13).

Sababaraha abad kapengker Kangjeng Rosul oge kantos ngabocorkeun yen seuseurna pangeusi surga teh jalmi-jalmi anu takwa, sakumaha dawuhanana:''',
        },
        {
          'type': 'arabic',
          'content': '''سُئِلَ رَسُوْلُ اللهِ عَنْ أَكْثَرِ مَا يُدْخِلُ النَّاسَ اَلْجَنَّةَ؟ قَالَ: تَقْوَى اللهِ وَحُسْنُ الْخُلُقِ''',
        },
        {
          'type': 'text',
          'content': '''Hartosna, “Kangjeng Rosul kantos ditaros perkawis hal anu paling seueur nyebabkeun jalmi lebet ka surga. Mantenna ngawaler, ‘Takwa ka Alloh sareng akhlak anu sae,’” (HR Ahmad).

Salajengna, kumaha ari takwa? Takwa teh numutkeun ta’rifan anu masyhur mah nyaeta satia satuhu kana sagala rupi parentah Alloh oge nebihan kana sagala rupi panyegah-Na. Ta’rifan nu sanes nguningakeun, takwa teh ngaraos sieun, ati-ati tur waspada bisi ngareumpak larangan Alloh, oge leres-leres ngajalankeun naon sagala rupi tugas ti Mantenna.

Sidang Jumah anu dimulyakeun ku Alloh

Supados urang leres-leres janten pribadi takwa, tipayun urang kedah uninga sabab-sabab katakwaan eta. Ngalangkungan sabab-sabab tadi, Insyaalloh urang bakal gampil naratas jalan katakwaan. Dina leresan ieu sabab-sabab takwa teh parantos diuningakeun ku Syekh Hasan dina kitabna Taisirul Khalaq fi ‘Ilmil Akhlak, nyaeta:

1. Ngangken kahinaan diri

Ku cara ngangken kalemahan sareng kahinaan diri, urang Insyaalloh bakal tiasa napak dina jalan katakwaan. Sanes kanten urang ngangken kahinaan diri, urang oge kedah ngangken mulya tur agungna Allah. Ku cara kitu, urang bakal ngaraos isin lamun sombong sareng ngaraos mulya di payuneun Alloh anu maha mulya.

2. Salawasna emut kana kasaean Alloh

Ku cara eling kana kasaean Alloh, Insyaalloh urang bakal tiasa nyorang jalan katakwaan. Urang sing emut, yen Alloh mah teu pandang bulu, bade ka ahli toat, atanapi ka ahli ma’siat, kanu syukur atanapi kanu kufur, Mantenna mah tetep maha welas tur maha asih. Mantenna tetep ngarezekian. Ku cara kitu, Insyaalloh urang bakal ngaraos isin kana kasaean Alloh, sedengkeun urang ngaraos masih leleda dina ibadah sareng kumaula ka Mantenna.

3. Emut kana maot

Sanes kanten ti dua sabab di luhur, emut kana maot oge janten sabab urang digampilkeun ngalacak jalan katakwan. Ku cara emut kana maot, urang bakal janten pribadi anu ati-ati, sumanget kana ibadah, geuwat kana migawe tobat, sieun ku panyegah Alloh, sareng istiqomah dina milari ridho Mantenna. Naon sababna? Sabab di dunya hirup moal lana jeung salilana, hiji mangsa mah bakal mulang ka alam baqa. 
    
Sidang Jumah anu dimulyakeun ku Alloh

Tah ngalangkungan ibadah puasa ieu, mudah-mudahan we urang sing tiasa ngahontal darajat takwa, anu mana darajat takwa ieu teh, bakal tiasa ngengingkeun rupi-rupi kamulyaan di dunya rawuh di akherat.

Malihan dina perkawis ieu, Imam Al-Ghazali dina kitab Minhajul Abidin, Terbitan Maktabah Muhammad bin Ahmad, Surabaya kaca 104-105, parantos ngawincik 40 kautamaan anu baris dikengingkeun ku jalmi anu takwa: 20 di antawisna dipasihkeun di alam dunya sareng 20 di akherat.

Sababaraha kamulyaan keur jalmi takwa anu dipasihkeun di alam dunya, numutkeun Imam Al-Ghazali, di antawisna nyaeta (1) diangkat kasusahna ku Alloh, (2) digampilkeun milik rezekina, (3) sapapaosna kenging pitulung Alloh, (4) sapapaosna kenging katenangan ti Alloh, (5) bakal dipaparin kabarokahan dina sagala rupi widang kahirupannana, (6) hatena bakal dicaangkeun ku cahaya, hikmah, sareng elmu Alloh.

Salah sawios ayat anu masyhur keur jalmi anu takwa di dunya nyaeta:''',
        },
        {
          'type': 'arabic',
          'content': '''وَمَنْ يَتَّقِ اللّٰهَ يَجْعَلْ لَهُ مَخْرَجًا ، وَيَرْزُقْهُ مِنْ حَيْثُ لَا يَحْتَسِبُ''',
        },
        {
          'type': 'text',
          'content': '''Hartosna, “Sing saha jalma anu takwa ka Allah maka Mantenna bakal muka jalan kaluar ka eta jalma, oge Mantenna bakal maparin rezeki ti arah anu teu disangka-sangkana,” (QS. Ath-Thalaq [65]:2-3).

Sedengkeun kamulyaan keur jalmi takwa di akherat, numutkeun Al-Ghazali, di antawisna, (1) bakal diringankeun ku Alloh nalika mayunan sakaratul maot, (2) bakal disalametkeun tina patarosan sareng fitnah kubur, (3) bakal diselamatkeun tina huru-hara Kiamat, (4) bakal dipasihan balesan anu ageung, nyaeta surga kani’matan anu abadi.

Sidang Jumah anu dimulyakeun ku Alloh

Mugia wae urang sadayana sing kalebet jalmi-jalmi saum anu ngengingkeun darajat takwa, saenya-enyana Alloh sasarengan sareng jalmi takwa sareng jalmi-jalmi anu sapapaosna midamel kasaean.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللهُ لِيْ وَلَكُمْ فِيْ هَذَا الْيَوْمِ الْكَرِيْمِ، وَنَفَعَنِيْ وَاِيَّاكُمْ بِمَا فِيْهِ مِنَ الصَّلَاةِ وَالصَّدَقَةِ وَتِلَاوَةِ الْقُرْاَنِ وَجَمِيْعِ الطَّاعَاتِ، وَتَقَبَّلَ مِنِّيْ وَمِنْكُمْ جَمِيْعَ أَعْمَالِنَا إِنَّهُ هُوَ الْحَكِيْمُ الْعَلِيْمُ، أَقُوْلُ قَوْلِيْ هَذَا وَأَسْتَغْفِرُ اللهَ لِيْ وَلَكُمْ، فَاسْتَغْفِرُوْهُ، اِنَّهُ هُوَ الْغَفُوْرُ الرَّحِيْمُ''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ حَمْدًا كَمَا أَمَرَ. أَشْهَدُ أَنْ لَااِلَهَ اِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، اِلَهٌ لَمْ يَزَلْ عَلَى كُلِّ شَيْءٍ وَكِيْلًا. وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ وَحَبِيْبُهُ وَخَلِيْلُهُ، أَكْرَمُ الْأَوَّلِيْنَ وَالْأَخِرِيْنَ، اَلْمَبْعُوْثُ رَحْمَةً لِلْعَالَمِيْنَ. اَللّهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلىَ أَلِهِ وَأَصْحَابِهِ وَمَنْ كَانَ لَهُمْ مِنَ التَّابِعِيْنَ، صَلَاةً دَائِمَةً بِدَوَامِ السَّمَوَاتِ وَالْأَرْضِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ: فَيَا أَيُّهَا الْحَاضِرُوْنَ اتَّقُوا اللّٰهَ حَقَّ تُقَاتِهِ وَذَرُوْا الْفَوَاحِشَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ. وَحَافِظُوْا عَلَى الطَّاعَةِ وَحُضُوْرِ الْجُمْعَةِ وَالْجَمَاعَةِ وَالصَّوْمِ وَجَمِيْعِ الْمَأْمُوْرَاتِ وَالْوَاجِبَاتِ، وَاعْلَمُوْا أَنَّ اللهَ أَمَرَكُمْ بِأَمْرٍ بَدَأَ بِنَفْسِهِ. وَثَنَى بِمَلَائِكَةِ الْمُسَبِّحَةِ بِقُدْسِهِ، إِنَّ اللّٰهَ وَمَلائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيماً، اَللّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى أَلِ سَيِّدِنَا مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلَى أَلِ سَيِّدِنَا اِبْرَاهِيْمَ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى أَلِ سَيِّدِنَا مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلَى أَلِ سَيِّدِنَا اِبْرَاهِيْمَ فِيْ العَالَمِيْنَ اِنَّكَ حَمِيْدٌ مَجِيْدٌ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّهُمَّ اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ اَلْأَحْيَاءِ مِنْهُمْ وِالْأَمْوَاتِ، اَللَّهُمَّ ادْفَعْ عَنَّا الْبَلَاءَ وَالْغَلَاءَ وَالْوَبَاءَ وَالْفَحْشَاءَ وَالْمُنْكَرَ وَالْبَغْيَ وَالسُّيُوْفَ الْمُخْتَلِفَةَ وَالشَّدَائِدَ وَالْمِحَنَ، مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ، مِنْ بَلَدِنَا هَذَا خَاصَةً وَمِنْ بُلْدَانِ الْمُسْلِمِيْنَ عَامَةً، اِنَّكَ عَلَى كُلِّ شَيْءٍ قَدِيْرٌ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ، اِنَّ اللهَ يَأْمُرُ بِالْعَدْلِ وَالْاِحْسَانِ وَاِيْتَاءِ ذِيْ الْقُرْبَى وَيَنْهَى عَنِ الْفَحْشَاءِ وَالْمُنْكَرِ وَالْبَغْيِ، يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ، فَاذْكُرُوْا اللهَ الْعَظِيْمَ يَذْكُرُكُمْ وَلَذِكْرُ اللهِ أَكْبَرُ''',
        },
        {
          'type': 'text',
          'content': '''M. Tatam Wijaya, Penyuluh dan Petugas KUA Sukanagara-Cianjur, Jawa Barat.''',
        },
      ]
    },
    {
      'title': 'Khutbah Jumat: Ramadhan, Bulan Turunnya Kitab Suci',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Keagungan bulan Ramadhan tidak hanya terletak pada ibadah yang dilipatgandakan, tetapi juga pada perannya sebagai bulan turunnya wahyu. Maka, kesadaran akan hal ini bisa menjadikan Ramadhan lebih bermakna, bisa mendorong setiap manusia untuk lebih giat dalam membaca Al-Qur’an.

Naskah khutbah Jumat berikut ini dengan judul, “Khutbah Jumat: Ramadhan, Bulan Turunnya Kitab Suci.” Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ الَّذِي هَدَانَا لِطَرِيْقِهِ الْقَوِيْمِ، وَفَقَّهَنَا فِي دِيْنِهِ الْمُسْتَقِيْمِ. أَشْهَدُ أَنْ لَا إِلٰهَ إلَّا اللّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ شَهَادَةً تُوَصِّلُنَا إِلىَ جَنَّاتِ النَّعِيْمِ، وَتَكُوْنُ سَبَبًا لِلنَّظْرِ إِلَى وَجْهِهِ الْكَرِيْمِ. وَأَشْهَدُ أَنَّ سَيِّدَنَا وَنَبِيَّنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ السَّيِّدُ السَّنَدُ الْعَظِيْمُ، اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَأَصْحَابِهِ أُوْلِى الْفَضْلِ الْجَسِيْمِ. أَمَّا بَعْدُ: فَيَا عِبَادَ الْكَرِيْمِ، فَإِنِّي أُوْصِيكُمْ بِتَقْوَى اللَّهِ الْحَكِيْمِ، الْقَائِلِ فِي كِتَابِهِ الْقُرْآنِ الْعَظِيْمِ: شَهْرُ رَمَضَانَ الَّذِي أُنْزِلَ فِيهِ الْقُرْآنُ هُدىً لِلنَّاسِ وَبَيِّنَاتٍ مِنَ الْهُدَى وَالْفُرْقَانِ''',
        },
        {
          'type': 'text',
          'content': '''Ma’asyiral Muslimin jamaah Jumat yang dirahmati Allah

Puji syukur alhamdulillahi rabbil alamin, mari senantiasa kita ucapkan melalui lisan dan kita aplikasikan dalam kehidupan sehari-hari melalui gerakan, atas segala nikmat dan karunia yang telah Allah berikan kepada kita semua tanpa terhitung jumlahnya, terutama nikmat agung berupa dipertemukannya kembali dengan bulan yang penuh kemuliaan, yaitu bulan Ramadhan. Semoga di bulan yang singkat ini, kita benar-benar bisa meraih segala manfaat, keutamaan, dan keberkahan yang ada di dalamnya.

Shalawat serta salam senantiasa kita haturkan kepada junjungan kita, Nabi Muhammad, Allahumma shalli wa sallim ‘ala Sayyidina Muhammad wa ‘ala alihi wa shahbihi. Sosok teladan yang sempurna, insan yang jujur, sabar, dan penuh kebijaksanaan. Semoga kita semua yang hadir dalam pelaksanaan shalat Jumat ini termasuk ke dalam golongan umatnya yang berhak mendapatkan syafaatnya kelak di hari kiamat. Amin ya rabbal alamin.

Selanjutnya, sudah menjadi tugas kami untuk senantiasa mengingatkan para jamaah shalat Jumat agar terus berusaha meningkatkan keimanan dan ketakwaan kepada Allah SWT. Caranya adalah dengan terus istiqamah dalam menjalankan setiap kewajiban serta menjauhi segala larangan-Nya.

Ketakwaan merupakan bekal utama yang akan kita bawa menuju akhirat, sebab pada hakikatnya, dunia ini adalah ladang untuk menanam, sedangkan akhirat adalah tempat kita memanen hasil dari apa yang telah kita tanam. Allah SWT berfirman dalam Al-Qur’an:''',
        },
        {
          'type': 'arabic',
          'content': '''وَتَزَوَّدُوا فَإِنَّ خَيْرَ الزَّادِ التَّقْوَى وَاتَّقُونِ يَا أُولِي الأَلْبَابِ''',
          'translation': '''“Bawalah bekal, karena sesungguhnya sebaik-baik bekal adalah takwa. Dan bertakwalah kepada-Ku wahai orang-orang yang mempunyai akal sehat.” (QS Al-Baqarah [2]: 197).''',
        },
        {
          'type': 'text',
          'content': '''Ma’asyiral Muslimin jamaah Jumat yang dirahmati Allah

Bulan Ramadhan merupakan bulan yang sangat mulia dan penuh berkah. Ramadhan dikenal dengan bulan penuh rahmat, ampunan, dan hidayah. Hidayah yang dimaksud adalah petunjuk dari Allah, yang dapat kita jadikan pedoman menuju jalan yang benar. Pada bulan Ramadhan ini, petunjuk itu Allah turunkan kepada kita semua, yang kita kenal dengan Al-Qur’an.

Allah menurunkan Al-Qur’an secara keseluruhan dari Lauhul Mahfudz ke langit pertama, yang dikenal dengan nama Baitul Izzah,  Allah kemudian memerintahkan malaikat Jibril untuk menurunkannya secara bertahap, ayat demi ayat, sesuai dengan keadaan dan kebutuhan umat pada saat itu. Allah SWT berfirman dalam Al-Qur’an:''',
        },
        {
          'type': 'arabic',
          'content': '''شَهْرُ رَمَضَانَ الَّذِي أُنْزِلَ فِيهِ الْقُرْآنُ هُدًى لِّلنَّاسِ وَبَيِّنَاتٍ مِّنَ الْهُدَى وَالْفُرْقَانِ''',
          'translation': '''“Bulan Ramadan adalah (bulan) yang di dalamnya diturunkan Al-Qur’an sebagai petunjuk bagi manusia dan penjelasan-penjelasan mengenai petunjuk itu serta pembeda (antara yang hak dan yang batil).” (QS Al-Baqarah [2]: 185).''',
        },
        {
          'type': 'text',
          'content': '''Dengan demikian, sangat tepat bagi kita jika pada bulan ini kita jadikan sebagai momentum untuk lebih giat dan lebih semangat dalam membaca Al-Qur’an, memahami dan menjalani apa yang tertulis dalam kitab suci tersebut. Selain karena membaca Al-Qur’an sangat dianjurkan di bulan Ramadhan, namun juga sebagai bentuk kecintaan kita kepadanya yang Allah turunkan pada bulan mulia ini.

Ma’asyiral Muslimin jamaah Jumat yang dirahmati Allah

Namun ternyata bulan Ramadhan tidak hanya menjadi bulan diturunkannya Al-Qur’an saja, namun juga menjadi saksi diturunkannya semua kitab-kitab suci yang diterima oleh para Nabi sebelum Nabi Muhammad. Nabi Musa menerima kitab Taurat pada bulan Ramadhan, begitu juga dengan Nabi Daud dan Nabi Isa.

Penjelasan di atas sebagaimana dicatat oleh Imam Abu Jarir at Thabari dalam kitab Jami’ul Bayan fi Ta’wilil Qur’an, jilid III, halaman 446. Dalam kitab tersebut ditegaskan:''',
        },
        {
          'type': 'arabic',
          'content': '''نُزِلَتْ صُحُفُ إِبْرَاهِيْمَ أَوَّلَ لَيْلَةٍ مِنْ شَهْرِ رَمَضَانَ، وَأُنْزِلَتِ التَّوْرَاةُ لِسِتٍّ مَضَيْنِ مِنْ رَمَضَانَ، وَأُنْزِلَ الْإِنْجِيْلُ لِثَلاَثَ عَشَرَةَ خَلَتْ، وَأُنْزِلَ الْقُرْآنُ لِأَرْبَعٍ وَعِشْرِيْنَ مِنْ رَمَضَانَ''',
          'translation': '''Shuhuf Nabi Ibrahim diturunkan pada malam pertama bulan Ramadhan. Taurat diturunkan pada tanggal enam Ramadhan. Injil diturunkan pada tanggal tiga belas Ramadhan. Dan Al-Qur’an diturunkan pada tanggal dua puluh empat Ramadhan.''',
        },
        {
          'type': 'text',
          'content': '''Oleh sebab itu, bulan Ramadhan tidak hanya menjadi bulan diturunkannya kitab suci Al-Qur’an saja, namun juga menjadi saksi diturunkannya kitab-kitab suci yang lain sebelum Al-Qur’an, seperti suhuf Nabi Ibrahim, kitab Taurat kepada Nabi Musa, kitab Injil kepada Nabi Isa, serta kitab suci Al-Qur’an kepada Nabi Muhammad saw.

Ma’asyiral Muslimin jamaah Jumat yang dirahmati Allah

Lantas, apa sebenarnya hikmah atau hubungan diturunkannya kitab-kitab suci tersebut bertepatan dengan bulan mulia ini? Perlu kita ketahui bahwa Ramadhan dan kitab suci memiliki hubungan yang sangat erat. Ketika kita berpuasa, kita merasakan betapa lemahnya diri kita, betapa kita membutuhkan pertolongan Allah, dan betapa kita harus bergantung sepenuhnya kepada-Nya. Pada saat itulah, kita membuka hati untuk menerima cahaya Ilahi yang datang melalui Al-Qur'an.

Oleh sebab itu, Imam Fakhruddin ar-Razi dalam kitab Tafsir Mafatihul Ghaib, jilid V, halaman 252, mengatakan bahwa ketika bulan Ramadhan dikhususkan sebagai bulan turunnnya Al-Qur’an, maka sudah seharusnya juga menjadi bulan yang dikhususkan untuk berpuasa, karena keduanya memiliki hubungan yang sangat erat,''',
        },
        {
          'type': 'arabic',
          'content': '''فَثَبَتَ أَنَّ بَيْنَ الصَّوْمِ وَبَيْنَ نُزُولِ الْقُرْآنِ مُنَاسِبَةٌ عَظِيمَةٌ فَلَمَّا كَانَ هَذَا الشَّهْرُ مُخْتَصًّا بِنُزُولِ الْقُرْآنِ، وَجَبَ أَنْ يَكُونَ مُخْتَصًّا بِالصَّوْمِ''',
          'translation': '''Maka sangat tepat, bahwa antara puasa dan turunnya Al-Qur’an memiliki hubungan yang sangat agung. Sehingga, ketika bulan (Ramadhan) ini dikhususkan dengan turunnya Al-Qur’an, maka sudah sepatutnya ia juga dikhususkan dengan ibadah puasa.''',
        },
        {
          'type': 'text',
          'content': '''Ma’asyiral Muslimin jamaah Jumat yang dirahmati Allah

Demikian adanya khutbah Jumat kali ini, yang membahas tentang bulan Ramadhan sebagai saksi diturunkannya semua kitab suci, bulan yang penuh kemuliaan dan keberkahan. Semoga khutbah ini membawa manfaat dan kebaikan bagi kita semua, menjadi wasilah untuk meningkatkan ketakwaan, dan mengantarkan kita pada ampunan serta rahmat-Nya. Amin ya Rabbal ‘alamin.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللهُ لِيْ وَلَكُمْ، وَنَفَعَنِيْ وَاِيَاكُمْ بِمَا فِيْهِ مِنَ اْلآيَاتِ وَالذِّكْرِ الْحَكِيْمِ، وَتَقَبَّلَ مِنِّيْ وَمِنْكُمْ جَمِيْعَ أَعْمَالِنَا إِنَّهُ هُوَ الْحَكِيْمُ الْعَلِيْمُ. أَقُوْلُ قَوْلِيْ هَذَا وَأَسْتَغْفِرُ اللهَ لِيْ وَلَكُمْ وَلِلْمُسْلِمِيْنَ فَاسْتَغْفِرُوْهُ اِنَّهُ هُوَ الْغَفُوْرُ الرَّحِيْمُ''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ للهِ حَمْدًا كَمَا أَمَرَ. أَشْهَدُ أَنْ لَاإِلٰهَ اِلَّا الله وَحْدَهُ لَا شَرِيْكَ لَهُ، اِلَهٌ لَمْ يَزَلْ عَلَى كُلِّ شَيْءٍ وَكِيْلًا. وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ وَحَبِيْبُهُ وَخَلِيْلُهُ، أَكْرَمِ الْأَوَّلِيْنَ وَالْأَخِرِيْنَ، اَلْمَبْعُوْثِ رَحْمَةً لِلْعَالَمِيْنَ. اللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلىَ أَلِهِ وَأَصْحَابِهِ وَمَنْ كَانَ لَهُمْ مِنَ التَّابِعِيْنَ، صَلَاةً دَائِمَةً بِدَوَامِ السَّمَوَاتِ وَالْأَرْضِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ: فَيَا أَيُّهَا الْحَاضِرُوْنَ اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ وَذَرُوْا الْفَوَاحِشَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ. وَحَافِظُوْا عَلَى الطَّاعَةِ وَحُضُوْرِ الْجُمْعَةِ وَالْجَمَاعَةِ وَالصَّوْمِ وَجَمِيْعِ الْمَأْمُوْرَاتِ وَالْوَاجِبَاتِ. وَاعْلَمُوْا أَنَّ اللهَ أَمَرَكُمْ بِأَمْرٍ بَدَأَ بِنَفْسِهِ. وَثَنَى بِمَلَائِكَةِ الْمُسَبِّحَةِ بِقُدْسِهِ. إِنَّ اللَّهَ وَمَلائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيماً''',
        },
        {
          'type': 'arabic',
          'content': '''اللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلَى آلِ سَيِّدِنَا اِبْرَاهِيْمَ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلَى آلِ سَيِّدِنَا اِبْرَاهِيْمَ فِيْ العَالَمِيْنَ اِنَّكَ حَمِيْدٌ مَجِيْدٌ. اللّٰهُمَّ اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ اَلْأَحْيَاءِ مِنْهُمْ وِالْأَمْوَاتِ. اللّٰهُمَّ ادْفَعْ عَنَّا الْبَلَاءَ وَالْغَلَاءَ وَالْوَبَاءَ وَالْفَحْشَاءَ وَالْمُنْكَرَ وَالْبَغْيَ وَالسُّيُوْفَ الْمُخْتَلِفَةَ وَالشَّدَائِدَ وَالْمِحَنَ، مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ، مِنْ بَلَدِنَا هَذَا خَاصَةً وَمِنْ بُلْدَانِ الْمُسْلِمِيْنَ عَامَةً، اِنَّكَ عَلَى كُلِّ شَيْءٍ قَدِيْرٌ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ، اِنَّ اللهَ يَأْمُرُ بِالْعَدْلِ وَالْاِحْسَانِ وَاِيْتَاءِ ذِيْ الْقُرْبَى وَيَنْهَى عَنِ الْفَحْشَاءِ وَالْمُنْكَرِ وَالْبَغْيِ، يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ. فَاذْكُرُوْا اللهَ الْعَظِيْمَ يَذْكُرُكُمْ وَلَذِكْرُ اللهِ أَكْبَرُ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Sunnatullah, Pengajar di Pondok Pesantren Al-Hikmah Darussalam Durjan Kokop Bangkalan Jawa Timur, dan alumnus Program Kepenulisan Turots Ilmiah Maroko.''',
        },
      ]
    },
    {
      'title': 'Khutbah Jumat Sunda: Ngengingkeun Lailatul Qadar di Panungtung Ramadhan',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Lailatul Qadar merupakan malam mulia dan istimewa. Salah satu keutamaannya lebih baik dari 1000 bulan, bahkan Al-Qur\'an pun turun pada malam tersebut. Sungguh luar biasa bagi siapa pun yang mendapatkannya. Dan menurut pendapat yang unggul, waktu terjadinya adalah 10 malam terakhir di bulan Ramadan.''',
        },
        {
          'type': 'text',
          'content': '''Maka khutbah Jumat bahasa Sunda ini berjudul, "Khutbah Jumat Sunda: Ngengingkeun Lailatul Qadar di Panungtung Ramadhan". Untuk mencetak khutbah ini, silakan klik fitur download berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!''',
        },
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ الَّذِيْ أَنْزَلَ عَلَى عَبْدِهِ الْكِتَابَ وَلَمْ يَجْعَلْ لَهُ عِوَجًا، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، شَهَادَةً تَرْفَعُ الصَّادِقِيْنَ إِلَى مَنَازِلِ الْمُقَرَّبِيْنَ دَرَجًا. وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ الَّذِيْ وَضَعَ اللهُ بِرِسَالَتِهِ عَنِ الْمُكَلَّفِيْنَ حَرَجًا. اَللَّهُمَّ صَلِّ عَلَى عَبْدِكَ وَرَسُوْلِكَ مُحَمَّدٍ وَعَلَى آلِهِ وَأَصْحَابِهِ خَيْرِ الْأَنَامِ طَرِيْقَةً وَأَهْدَاهُمْ مَنْهَجًا، وَسَلِّمْ تَسْلِيْمًا كَثِيْرًا''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ، فَيَا أَيُّهَا النَّاسُ، اِتَّقُوا اللهَ حَقَّ تَقْوَاهُ، وَسَارِعُوا إِلَى مَغْفِرَتِهِ وَرِضَاهُ. قَالَ اللهُ تَعَالَى فِي الْقُرْآنِ الْعَظِيْمِ وَهُوَ أَصْدَقُ الْقَائِلِيْنَ ، أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ ، بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ، إِنَّا أَنْزَلْنَاهُ فِي لَيْلَةِ الْقَدْرِ، وَمَا أَدْرَاكَ مَا لَيْلَةُ الْقَدْرِ، لَيْلَةُ الْقَدْرِ خَيْرٌ مِنْ أَلْفِ شَهْرٍ، صَدَقَ اللهُ الْعَظِيْمُ''',
        },
        {
          'type': 'text',
          'content': '''Sidang Jumah anu mulya 
Tipayun, hayu urang sami-sami manjatkeun puji kalih syukur ka Alloh swt. Sholawat miwah salam mugia salamina sing dilimpahkeun ka jungjunan Alam, ya\'ne Kangjeng Nabi Muhammad saw. Sholawat kalih salam oge mugia dikucurkeun ka kulawargina miwah para sahabatna, tabi\'in kalih tabia\'atna, dugika ka urang sadayana salaku umatna.''',
        },
        {
          'type': 'text',
          'content': '''Sateuacan ngalajengkeun khutbah, sakumaha biasa khotib seja ngadugikeun wasiat takwa khusus ka diri khotib pribadi, umum ka ahli jum\'ah sadayana. Sabab, ukur katakwaan sareng kaimanan anu janten ukuran kamulyaan hiji hamba di payuneun Pangerannana.''',
        },
        {
          'type': 'text',
          'content': '''Sidang Jumah anu mulya''',
        },
        {
          'type': 'text',
          'content': '''Dina waktos ieu urang tos lebet kana 10 dinten terakhir sasih Ramadhan. Numutkeun sababaraha katerangan, 10 wengi terakhir teh mangrupikeun waktos anu utama dibanding waktos sanesna. Salah sawiosna jalaran aya wengi anu kalintang istimewana nyaeta anu disebat Lailatul Qadar. Hal ieu dumasar kana dawuhan Kangjeng Rosul:''',
        },
        {
          'type': 'arabic',
          'content': '''تَحَرَّوْا ‌لَيْلَةَ ‌الْقَدْرِ فِي الْعَشْرِ الأَوَاخِرِ مِنْ رَمَضَانَ''',
          'translation': '''Hartosna, "Pilari ku aranjeun malem Lailatul Qadar dina sapuluh dinten terakhir sasih Romadhon," (HR Imam Bukhari).''',
        },
        {
          'type': 'text',
          'content': '''Sareng deui Lailatul Qadar teh wengi anu langkung mulya tibatan sarebu sasih. Di lebet ning eta wengi para malaikat kalebet malaikat Jibril lalungsur kalayan widi nu Maha Suci ngatur sagala rupi urusan. Maka kasalametan teh lungsur dugika meletek fajar. Kitu pisan numutkeun penjelasan surah Al-Qadr:''',
        },
        {
          'type': 'arabic',
          'content': '''إِنَّآ أَنزَلۡنَٰهُ فِي لَيۡلَةِ ٱلۡقَدۡرِ ، وَمَآ أَدۡرَىٰكَ مَا لَيۡلَةُ ٱلۡقَدۡرِ ، لَيۡلَةُ ٱلۡقَدۡرِ خَيۡرٞ مِّنۡ أَلۡفِ شَهۡرٍ''',
          'translation': '''Hartosna, "Saenya-enyana Kaula tos nurunkeun (Al-Quran) dina Lailatul Qadar. Naha anjeun terang naon ari Lailatul Qadar.? Lailatul Qadar  teh leuwih hade tibatan sarebu bulan," (QS Al-Qadr [97]: 1-3).''',
        },
        {
          'type': 'text',
          'content': '''Upami nitenan kana kautamian wengi Lailatul Qadar anu neme, 1000 sasih teh sami sareng 83 taun 4 sasih. Hal ieu kalintang poharana kaunggulan anu tiasa dihontal ku urang salaku umatna Kangjeng Rosul. Leres-leres ieu janten kadeudeuh Alloh swt. Sanaos yuswa Kangjeng Rosul parondok, tapi masalah dina kautamian mah tiasa ngabanding ka umat kapungkur anu yuswana paranjang.''',
        },
        {
          'type': 'text',
          'content': '''Sidang Jumah anu mulya''',
        },
        {
          'type': 'text',
          'content': '''Sajabi ti eta, Lailatul Qadar teh dilebetkeun wengi istimewa margi janten wengian dilungsurkeun Al-Quran ti Lauhul Mahfudz ka Baitul \'Izzah (langit dunya), nu janten pituduh keur sadaya manusa, ngandung rupi-rupi penjelasan, oge janten pangbeda antawis hak sareng batil. Hal ieu saluyu sareng dawuhan Alloh swt:''',
        },
        {
          'type': 'arabic',
          'content': '''شَهْرُ رَمَضَانَ الَّذِي أُنْزِلَ فِيْهِ الْقُرْآنُ هُدًى لِلنَّاسِ وَبَيِّنَاتٍ مِنَ الْهُدَى وَالْفُرْقَانِ''',
          'translation': '''Hartosna, "Bulan Romadhon, nyaeta bulan anu di jerona diturunkeun Al-Qur\'an salaku pituduh keur manusa sareng penjelasan-penjelasan perkawis pituduh eta sarta pangbeda (antara perkara hak sareng batil)," (QS Al-Baqarah [2]: 185).''',
        },
        {
          'type': 'text',
          'content': '''Sidang Jumah anu mulya''',
        },
        {
          'type': 'text',
          'content': '''Keutamaan sanesna dina wengian Lailatul Qadar teh dihapuntenna dosa-dosa anu tos ti payun salami urang ngama\'murkeunna ku mangrupi-rupi ibadah, sapertos netepan, i\'tikaf, dzikir, sareng sajabina.  Kitu di antawisna sakumaha anu didugikeun ku Kangjeng Rosul.''',
        },
        {
          'type': 'arabic',
          'content': '''مَنْ قَامَ لَيْلَةَ الْقَدْرِ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ''',
          'translation': '''Hartosna, "Sing saha jalma anu ngadeg (ibadah) dina wengian Lailatulqoadar karana arah-arah iman sareng miharep pahala, maka dihampura dosa-dosana anu tos kaliwat," (HR Imam Bukhari).''',
        },
        {
          'type': 'text',
          'content': '''Salajengna iraha ari waktos anu tangtos kajantenan Lailatul Qadar?  Ibnu Hajar dina kitab Fathul Bari juz 5 kaca 569 nyebatkeun waktos Lailatul Qadar teh dina 10 dinten terakhir Romadhon.''',
        },
        {
          'type': 'text',
          'content': '''Kaol ieu didukung ku hadits riwayat Imam Ahmad anu ngawinciik, yen hadirna Lailatul Qadar teh 10 wengi terakhir, tepatna dina wengi-wengi anu ganjil:''',
        },
        {
          'type': 'arabic',
          'content': '''هِيَ فِي شَهْرِ رَمَضَانَ، فَالْتَمِسُوهَا ‌فِي ‌الْعَشْرِ ‌الْأَوَاخِرِ، فَإِنَّهَا وَتْرٌ''',
          'translation': '''Hartosna, "Lailatul Qadar teh dina sasih Romadhon tepatna dina sapuluh wengi terakhir, eta teh wengi ganjil," (HR Imam Ahmad).''',
        },
        {
          'type': 'text',
          'content': '''Aya oge kaol anu ngetang kajantenan waktos Lailatul Qadar ku ningal dinten kahiji Romadhon. Syaikh Ahmad bin Muhammad As-Showi dina kitab Tafsir Shawi, jilid 4, kaca 337 nguningakeun, upami ngawitan Romadhon dina dintena Saptu, sakumaha dina Romadhon ayeuna, maka Lailatul Qadarna gubrag dina wengi 23.''',
        },
        {
          'type': 'text',
          'content': '''Teras dina kitab Bajuri jilid I, kaca 304 disebatkeun, upami ngawitan Romadhon dinten Saptu, maka Lailatul Qadarna dina wengi ka 21. Nanging perbentenan ieu teh teu leupas tina pangalaman para ulama anu ngalamannana.''',
        },
        {
          'type': 'text',
          'content': '''Aya deui kaol anu nguningakeun, yen Lailaul Qodar mah dirahasiakeun ku Alloh. Pokona mah dina salami sasih Romadhon. Hal ieu oge teu leupas tina hikmah anu ageung. Salah sawiosna supados sadayana jalmi mu\'min leres-leres ngama\'murkeun sadayana wengi dina sasih Romadhon.''',
        },
        {
          'type': 'text',
          'content': '''Nanging anu paling kiat di antawis sababaraha kaol anu neme, numutkeun Ibnu Hajar, nyaeta kaol anu nyebatkeun Lailatul Qadar teh tumiba dina wengi ganjil 10 wengi terakhir Ramadhan. Anapon gubragna Lailatul Qadar dina satiap taun teh benten-benten.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah Jumah anu mulya''',
        },
        {
          'type': 'text',
          'content': '''Ningal kana kautamian Lailatul Qadar anu luar biasa, maka tos sakedahna urang leres-leres milari sareng ngengingkeunnana. Urang sing kabita ku kaistimewaannana. Mugia urang sadayana janten jalmi anu dipilih ku Alloh ngengingkeun kautamian eta wengi. Amin.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللهُ لِيْ وَلَكُمْ فِي الْقُرْآنِ الْعَظِيْمِ، وَنَفَعَنِيْ وَإِيَّاكُمْ بِمَا فِيْهِ مِنَ اْلآيَاتِ وَالذِّكْرِ الْحَكِيْمِ، وَتَقَبَّلَ اللهُ مِنِّيْ وَمِنْكُمْ تِلاَوَتَهُ، إِنَّهُ هُوَ السَّمِيْعُ الْعَلِيْمُ، أَقُوْلُ قَوْلِيْ هَذَا وَأَسْتَغْفِرُ اللهَ الْعَظِيْمَ لِيْ وَلَكُمْ وَلِسَائِرِ الْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ فَاسْتَغْفِرُوْهُ إِنّهُ هُوَ الْغَفُوْرُ الرّحِيْمُ''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ الَّذِيْ أَمَرَنَا بِاْلاِتِّحَادِ وَاْلاِعْتِصَامِ بِحَبْلِ اللهِ الْمَتِيْنِ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَاشَرِيْكَ لَهُ، إِيَّاهُ نَعْبُدُ وَإِيَّاهُ نَسْتَعِيْنُ. وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ، اَلْمَبْعُوْثُ رَحْمَةً لِلْعَالَمِيْنَ. اِتَّقُوا اللهَ مَا اسْتَطَعْتُمْ وَسَارِعُوْا إِلَى مَغْفِرَةِ رَبِّ الْعَالَمِيْنَ. إِنَّ اللهَ وَمَلاَئِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّ، يَاأَيُّهَا الَّذِيْنَ ءَامَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا ، اللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ، وَعَلَى اٰلِهِ وَصَحْبِهِ أَجْمَعِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللَّهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ وَالْمُسْلِمِيْنَ وَ الْمُسْلِمَاتِ اَلاَحْيَاءِ مِنْهُمْ وَالْاَمْوَاتِ إِنَّكَ سَمِيْعٌ قَرِيْبٌ مُجِيْبُ الدَّعَوَاتِ وَيَا قَاضِيَ الْحَاجَاتِ بِرَحْمَتِكَ يَا اَرْحَمَ الرَّحِمِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّهُمَّ إِنَّا نَسْأَلُكَ إِيْمَانًا كَامِلًا وَيَقِيْنًا صَادِقًا وَرِزْقًا وَاسِعًا وَقَلْبًا خَاشِعًا وَلِسَانًا ذَاكِرًا وَحَلَالًا طَيِّبًا وَتَوْبَةً نَصُوْحًا. رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ، إِنَّ اللهَ يَأْمُرُ بِالْعَدْلِ وَاْلإِحْسَانِ وَإِيتَآئِ ذِي الْقُرْبَى وَيَنْهَى عَنِ الْفَحْشَآءِ وَالْمُنكَرِ وَالْبَغْيِ يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ، فَاذْكُرُوا اللهَ الْعَظِيْمَ يَذْكُرْكُمْ وَادْعُوْهُ يَسْتَجِبْ لَكُمْ وَلَذِكْرُ اللهِ أَكْبَرُ''',
        },
        {
          'type': 'text',
          'content': '''M. Tatam Wijaya, Penyuluh dan Petugas KUA Sukanagara-Cianjur, Jawa Barat.''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat Bahasa Jawa: Kautaman Maos Al-Quran ing Wulan Ramadhan',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Di Bulan Ramadhan, kita banyak menjumpai kegiatan membaca Al-Qur\'an secara berkelompok, baik di masjid, mushola, dan rumah-rumah. Orang-orang sering menyebut kegiatan tersebut dengan istilah tadarusan. Selain karena ingin mengharapkan keberkahan pahala di Bulan Ramadhan, tadarusan memiliki banyak keutamaan. Apa saja keutamaannya?''',
        },
        {
          'type': 'text',
          'content': '''Teks Khutbah Bahasa Jawa berikut ini berjudul "Khutbah Jumat Bahasa Jawa: Kautaman Maos Al-Quran ing Wulan Ramadhan". Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ. اَلْحَمْدُ لِلّٰهِ الَّذِيْ حَمْدًا يُوَافِيْ نِعَمَهُ وَيُكَافِئُ مَزِيْدَهُ، يَا رَبَّنَا لَكَ الْحَمْدُ كَمَا يَنْبَغِيْ لِجَلَالِ وَجْهِكَ وَلِعَظِيْمِ سُلْطَانِكَ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ وَصَفِيُّهُ وَخَلِيْلُهُ، خَيْرُ نَبِيٍّ أَرْسَلَهُ اللّٰهُ إِلَى الْعَالَمِ كُلِّهِ بَشِيْرًا وَنَذِيْرًا. اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى أَلِ سَيِّدِنَا مُحَمَّدٍ صَلَاةً وَسَلَامًا مُتَلَازِمَيْنِ إِلَى يَوْمِ الدِّيْنِ. أَمَّا بَعْدُ، فَيَا أَيُّهَا الْحَاضِرُوْنَ، اِتَّقُوا اللّٰهَ حَقَّ تُقَاتِهِ وَلَا تَمُوْتُنَّ اِلَّا وَأَنْتُمْ مُسْلِمُوْنَ.  قَالَ اللّٰهُ تَعَالَى فِي الْقُرْاٰنِ الْعَظِيْمِ، أَعُوْذُ بِاللّٰهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ، بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ:  شَهْرُ رَمَضَانَ الَّذِيْٓ اُنْزِلَ فِيْهِ الْقُرْاٰنُ هُدًى لِّلنَّاسِ وَبَيِّنٰتٍ مِّنَ الْهُدٰى وَالْفُرْقَانِۚ فَمَنْ شَهِدَ مِنْكُمُ الشَّهْرَ فَلْيَصُمْهُۗ وَمَنْ كَانَ مَرِيْضًا اَوْ عَلٰى سَفَرٍ فَعِدَّةٌ مِّنْ اَيَّامٍ اُخَرَۗ يُرِيْدُ اللّٰهُ بِكُمُ الْيُسْرَ وَلَا يُرِيْدُ بِكُمُ الْعُسْرَۖ وَلِتُكْمِلُوا الْعِدَّةَ وَلِتُكَبِّرُوا اللّٰهَ عَلٰى مَا هَدٰىكُمْ وَلَعَلَّكُمْ تَشْكُرُوْنَ''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Wonten ing pambuka sidang khutbah ingkang minulya punika, kepareng khatib ngaturaken pepeling kagem kita sedaya. Manggaha kita tansah ningkataken takwa kita, kelawan nindaake perintahe Gusti saha nebihi sedaya awisane. Mugi-mugi kita kalebet golongan ingkang angsal Ridha saking Gusti Allah ta\'ala.''',
        },
        {
          'type': 'arabic',
          'content': '''وَتَزَوَّدُوا فَإِنَّ خَيْرَ الزَّادِ التَّقْوَى وَاتَّقُونِ يَا أُولِي الأَلْبَابِ''',
          'translation': '''Artosipun, "Pada (gawa) sanguha sira kabeh, mangka setuhune luwih bagus-baguse sangu, yaiku takwa marang Allah. Lan padha takwaha sira kabeh ing Ingsun (Allah), hei wong kang padha duweni akal," (QS Al Baqarah: 197).''',
        },
        {
          'type': 'text',
          'content': '''Jamaah sidang Jumat ingkang minulya''',
        },
        {
          'type': 'text',
          'content': '''Alhamdulillah, wonten ing wekdal menika kita taksih pinaringan kenikmatan saking Gusti, saget kepanggih kalian wulan Ramadhan. Mugi-mugi ing wulan punika kita pinaringan sehat wal afiat saget nglampahi sedaya amal ibadah kanthi raos bungah lan istiqamah.''',
        },
        {
          'type': 'text',
          'content': '''Salah setunggale amal ibadah ingkang kathah ketingal ing wulan Ramadhan, inggih punika tadarus Al-Qur\'an, utawi kegiatan maos Al-Qur\'an, sahe niku dilampahi piyambakan utawi sesarengan kalian para warga. Wonten ing masjid, langgar, lan mushala, ten pundi-pundi sami ngawontenaken tadarus Al-Qur\'an.''',
        },
        {
          'type': 'text',
          'content': '''Sedaya punika, kajaba kepengin angsal berkah lan ganjaran ing wulan Ramadhan, pancen antarane Al-Qur\'an lan Ramadhan punika dados perkawis ingkang sampun gathuk. Sampun kita mangertosi, bilih Nabi kita, Kanjeng Nabi Muhammad saw, pikantuk mu\'jizat ingkang ageng saking Allah ta\'ala, inggih punika kitab suci Al-Qur\'an.''',
        },
        {
          'type': 'text',
          'content': '''Kitab Al-Qur\'an dipunturunaken Allah ta\'ala datheng Kanjeng Nabi, kanthi perantara Malaikat Jibril, nalika Kanjeng Nabi khalwat ten Gua Hira, wonten ing Wulan Ramadhan. Pramila Wulan Ramadhan punika dipunsebutaken dados wulan ingkang dipunwajibaken ibadah pasa, ugi dados wulan tumurune Al-Qur\'an. Gusti Allah sampun paring dhawuh ing Al-Qur\'an Surat Al-Baqarah ayat 185:''',
        },
        {
          'type': 'arabic',
          'content': '''شَهْرُ رَمَضَانَ الَّذِيْٓ اُنْزِلَ فِيْهِ الْقُرْاٰنُ هُدًى لِّلنَّاسِ وَبَيِّنٰتٍ مِّنَ الْهُدٰى وَالْفُرْقَانِۚ فَمَنْ شَهِدَ مِنْكُمُ الشَّهْرَ فَلْيَصُمْهُ''',
          'translation': '''Artosipun, "Ibadah pasa iku ana ing wulan Ramadhan, ingkang sakjerone wulan mau Al-Qur\'an diturunaken (saking Lauhil Mahfudh). Kanggo nudhuhaken marang menungsa, lan dadi tandha terang saking pitudhuhe Allah ta\'ala. Lan saking kang ambeda\'ake (antarane haq lan bathil). Mangka sapa wonge hadlir (tinemu) ana ing wulan Ramadhan, dheweke kudu pasa …" (QS Al-Baqarah: 185).''',
        },
        {
          'type': 'text',
          'content': '''Jamaah sidang Jumat ingkang minulya''',
        },
        {
          'type': 'text',
          'content': '''Kegiatan tadarusan punika kathah sanget kautamanipun. Dipun terangaken Kanjeng Nabi Muhammad saw ing salah setunggale hadits ingkang dipun riwayataken saking sahabat Abu Hurairah ra:''',
        },
        {
          'type': 'arabic',
          'content': '''وَمَا اجْتَمَعَ قَوْمٌ فِي بَيْتٍ مِنْ بُيُوْتِ اللهِ يَتْلُوْنَ كِتَابَ اللهِ وَيتَدَارَسُوْنَهَ بَيْنَهُمْ إِلاَّ نَزَلَتْ عَلَيْهِمُ السَّكِيْنَةُ وَغَشِيَتْهُمُ الرَّحْمَةُ''',
          'translation': '''Artosipun, "Ora ana (ganjaran liya) kanggo wong kang padha kumpul ana ing omah-omahe Gusti Allah kanthi maca utawi nyinauni Al-Qur\'an, kejaba bakal dipunturunaken katentreman lan rahmat." (HR Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Saking hadits punika, kautaman tumrape kaum kang padha tadarus Al-Qur\'an inggih punika, ingkang pertama Gusti Allah bakal maringi sakinah (rasa tentrem) saha rahmat. Bilih rahmat utawi welas asihipun Gusti menika jembar sanget.''',
        },
        {
          'type': 'text',
          'content': '''Contonipun saking penjelasan sifat welas asihe Gusti Allah inggih punika Ar-Rahman lan Ar-Rahim. Wonten ing Tafsir Al-Ibriz dipun terangake ana ing surat Al-Fatihah ayat 3, bilih Gusti Allah iku persifatan welas asih maring sekabehane makhluk, luwih-luwih marang menungsa kang wis nyata diparingi nikmat wujud kanthi akal lan anggota badan kang sampurna lan nikmat liya-liyane meneh kang gedhe lan lembut.''',
        },
        {
          'type': 'arabic',
          'content': '''الرَّحْمٰنِ الرَّحِيْمِۙ''',
          'translation': '''Artosipun, "Kang Maha Welas ana ing (dunya lan akhirat) tur Maha Asih (ana ing akhirat blaka)," (QS Al-Fatihah: 3).''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Lajeng kautaman tumrape kaum kang kersa tadarus Al-Qur\'an, saking hadist riwayat Imam Muslim, inggih punika:''',
        },
        {
          'type': 'arabic',
          'content': '''وَحَفَّتْهُمُ الْمَلاَئِكَةُ وَذَكَرَهُمُ اللهُ فِيْمَنْ عِنْدَهُ''',
          'translation': '''Artosipun, "Lan bakal padha dikepung dening para malaikat lan Gusti Allah bakal ngalembana marang dhéwéké ana satengahé para malaikat kang mapan ing sakiwa tengené."''',
        },
        {
          'type': 'text',
          'content': '''Pramila, mangga kita sedaya ampun nilar ngamalke tadarus Al-Qur\'an, langkung-langkung ing wulan Ramadhan punika, sedaya amal ibadah bakal diganjar kanthi matikel-tikel.''',
        },
        {
          'type': 'text',
          'content': '''Kangge mungkasi khutbah punika, mangga kita tansah dedunga mugi kita sedaya lan keluarga kita, saget nglampahi ibadah ing wulan Ramadhan kanthi iman kang jejeg, awak kang sehat wal afiat, saha raos bungah lan istiqamah. Amin ya Rabbal Alamin.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللّٰهُ لِيْ وَلَكُمْ فِيْ الْقُرْآنِ الْكَرِيْمِ، وَنَفَعَنِيْ وَإِيَّاكُمْ بِمَا فِيْهِ مِنَ الذِّكْرِ الْحَكِيْمِ، وَتَقَبَّلَ مِنِّيْ وَمِنْكُمْ تِلَاوَتَهُ إِنَّهُ هُوَ الْغَفُوْرُ الرَّحِيْمُ، فَاعْتَبِرُوْا يَآ أُوْلِى اْلأَلْبَابِ لَعَلَّكُمْ تُفْلِحُوْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ الَّذِي هَدَانَا لِهَذَا وَمَا كُنَّا لِنَهْتَدِيَ لَوْلَا أَنْ هَدَانَا اللّٰهُ. أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنْ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ لَا نَبِيَّ بَعْدَهُ. اَللّٰهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ المُجَاهِدِيْنَ الطَّاهِرِيْنَ. أَمَّا بَعْدُ، فَيَا آيُّهَا الحَاضِرُوْنَ، أُوْصِيْكُمْ وَإِيَّايَ بِتَقْوَى اللّٰهِ وَطَاعَتِهِ لَعَلَّكُمْ تُفْلِحُوْنَ. يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ وَلَا تَمُوتُنَّ إِلَّا وَأَنْتُمْ مُسْلِمُونَ، وَتَزَوَّدُوا فَإِنَّ خَيْرَ الزَّادِ التَّقْوَى. فَقَدْ قَالَ اللّٰهُ تَعَالَى فِي كِتَابِهِ الْكَرِيْمِ، أَعُوْذُ بِاللّٰهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ، بِسْمِ اللّٰهِ الرَّحْمَنِ الرَّحِيْمِ: وَالْعَصْرِ. إِنَّ الْإِنْسَانَ لَفِي خُسْرٍ. إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْر. إِنَّ اللَّهَ وَمَلَائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيمًا. اللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى سَيِّدِنَا إِبْرَاهِيمَ وَعَلَى آلِ سَيِّدِنَا إِبْرَاهِيمَ، وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى سَيِّدِنَا إِبْرَاهِيمَ وَعَلَى آلِ سَيِّدِنَا إِبْرَاهِيمَ، فِى الْعَالَمِينَ إِنَّكَ حَمِيدٌ مَجِيدٌ. اَللّٰهُمَّ اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ. اَللّٰهُمَّ ادْفَعْ عَنَّا الْغَلَاءَ وَالْوَبَاءَ وَالطَّاعُوْنَ وَالْاَمْرَاضَ وَالْفِتَنَ مَا لَا يَدْفَعُهُ غَيْرُكَ عَنْ بَلَدِنَا هٰذَا اِنْدُوْنِيْسِيَّا خَاصَّةً وَعَنْ سَائِرِ بِلَادِ الْمُسْلِمِيْنَ عَامَّةً يَا رَبَّ الْعَالَمِيْنَ. رَبَّنَا اٰتِنَا فِي الدُّنْيَا حَسَنَةً وَ فِي الْاٰخِرَةِ حَسَنَةً وَ قِنَا عَذَابَ النَّارِ

عٍبَادَ اللّٰهِ، إِنَّ اللّٰهَ يَأْمُرُ بِاْلعَدْلِ وَاْلإِحْسَانِ وَإِيْتاءِ ذِي اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشاءِ وَاْلمُنْكَرِ وَاْلبَغْيِ يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ، وَاذْكُرُوا اللّٰهَ اْلعَظِيْمَ يَذْكُرْكُمْ، وَاشْكُرُوْهُ عَلىَ نِعَمِهِ يَزِدْكُمْ، وَلَذِكْرُ اللّٰهِ أَكْبَرْ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Ajie Najmuddin, Pengurus MWCNU Banyudono Boyolali''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Nuzulul Qur\'an dan Anjuran Memperbanyak Tadarus',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Bulan Ramadhan merupakan bulan yang memiliki banyak keistimewaan di dalamnya. Pada bulan yang mulia ini, tercatat banyak peristiwa bersejarah dalam Islam terjadi. Salah satunya ialah peristiwa turunnya Al-Qur\'an secara global dari Lauhul Mahfudz menuju Baitul Izzah di langit dunia sebagai bentuk pengagungan terhadap Al-Qur\'an. Momen turunnya Al-Qur\'an pada bulan ini menjadikan bulan Ramadhan memiliki nama lain yaitu Bulan Al-Qur\'an.''',
        },
        {
          'type': 'text',
          'content': '''Naskah khutbah Jumat berikut ini dengan judul, "Nuzulul Qur\'an dan Anjuran Memperbanyak Tadarus." Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!''',
        },
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''الْحَمْدُ للهِ. الْحَمْدُ للهِ الَّذِيْ حَمْدًا يُوَافِيْ نِعَمَهُ وَيُكَافِئُ مَزِيْدَهُ, يَا رَبَّنَا لَكَ الْحَمْدُ كَمَا يَنْبَغِيْ لِجَلَالِ وَجْهِكَ وَلِعَظِيْمِ سُلْطَانِكَ سُبْحَانَكَ اَللّٰهُمَّ لَا أُحْصِيْ ثَنَاءَكَ عَلَيْكَ أَنْتَ كَمَا أَثْنَيْتَ عَلَى نَفْسِكَ، وَأَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ وَصَفِيُّهُ وَخَلِيْلُهُ، خَيْرُ نَبِيٍّ أَرْسَلَهُ اللهُ إِلَى الْعَالَمِ كُلِّهِ بَشِيْرًا وَنَذِيْرًا. اَللّٰهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى أَلِ سَيِّدِنَا مُحَمَّدٍ صَلَاةً وَسَلَامًا مُتَلَازِمَيْنِ إِلَى يَوْمِ الدِّيْنِ أَمَّا بَعْدُ, فَيَاأَيُّهَا الْحَاضِرُوْنَ اِتَّقُوا اللهَ حَقَّ تُقَاتِهِ وَلَا تَمُوْتُنَّ اِلَّا وَأَنْتُمْ مُسْلِمُوْنَ 
قَالَ اللهُ تَعَالَى فِي الْقُرْاٰنِ الْعَظِيْمِ. أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ: شَهْرُ رَمَضَانَ الَّذِيْٓ اُنْزِلَ فِيْهِ الْقُرْاٰنُ هُدًى لِّلنَّاسِ وَبَيِّنٰتٍ مِّنَ الْهُدٰى وَالْفُرْقَانِۚ فَمَنْ شَهِدَ مِنْكُمُ الشَّهْرَ فَلْيَصُمْهُۗ وَمَنْ كَانَ مَرِيْضًا اَوْ عَلٰى سَفَرٍ فَعِدَّةٌ مِّنْ اَيَّامٍ اُخَرَۗ يُرِيْدُ اللّٰهُ بِكُمُ الْيُسْرَ وَلَا يُرِيْدُ بِكُمُ الْعُسْرَۖ وَلِتُكْمِلُوا الْعِدَّةَ وَلِتُكَبِّرُوا اللّٰهَ عَلٰى مَا هَدٰىكُمْ وَلَعَلَّكُمْ تَشْكُرُوْنَ''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat yang dimuliakan Allah''',
        },
        {
          'type': 'text',
          'content': '''Segala puji bagi Allah yang telah memberikan kita berbagai macam kenikmatan sehingga kita dapat memenuhi panggilan-Nya untuk menunaikan shalat Jumat. Nikmat yang harus digunakan dalam rangka memenuhi syariat yang telah ditetapkan-Nya.''',
        },
        {
          'type': 'text',
          'content': '''Shalawat beserta salam, mari kita haturkan bersama kepada Nabi Muhammad SAW, juga kepada para keluarganya, sahabatnya, dan semoga melimpah kepada kita semua selaku umatnya. Amin ya Rabbal \'alamin.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat yang dimuliakan Allah''',
        },
        {
          'type': 'text',
          'content': '''Bulan Ramadhan merupakan bulan mulia, penuh rahmat dan ampunan. Pada bulan yang mulia ini, tercatat banyak peristiwa bersejarah dalam Islam terjadi. Salah satu peristiwa yang tercatat dalam sejarah Islam di antaranya ialah bulan Ramadhan merupakan bulan diturunkannya Al-Qur\'an. Allah berfirman dalam surat Al-Baqarah ayat 185:''',
        },
        {
          'type': 'arabic',
          'content': '''شَهْرُ رَمَضَانَ الَّذِيْٓ اُنْزِلَ فِيْهِ الْقُرْاٰنُ هُدًى لِّلنَّاسِ وَبَيِّنٰتٍ مِّنَ الْهُدٰى وَالْفُرْقَانِۚ''',
          'translation': '''Artinya, "Bulan Ramadan adalah (bulan) yang di dalamnya diturunkan Al-Qur\'an sebagai petunjuk bagi manusia dan penjelasan-penjelasan mengenai petunjuk itu serta pembeda (antara yang hak dan yang batil)." (QS Al-Baqarah: 185)''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat yang dimuliakan Allah''',
        },
        {
          'type': 'text',
          'content': '''Syekh Nawawi al-Bantani dalam tafsirnya Marah Labid (juz I, halaman 61) menjelaskan bahwa ayat ini menerangkan fase pertama turunnya Al-Qur\'an.''',
        },
        {
          'type': 'text',
          'content': '''Saat itu, Jibril membawa Al-Qur\'an secara keseluruhan pada malam Lailatul Qadar, tanggal 24 Ramadhan, dari Lauhul Mahfudz ke langit dunia. Lalu, Jibril menyerahkannya kepada malaikat safarah (pencatat), yang kemudian menuliskannya di lembaran-lembaran. Lembaran-lembaran itu lalu disimpan di satu tempat di langit yang disebut Baitul Izzah.''',
        },
        {
          'type': 'text',
          'content': '''Setelah itu, Jibril menurunkan Al-Qur\'an kepada Rasulullah SAW secara bertahap selama 23 tahun, sepanjang masa kenabian. Turunnya ayat-ayat ini sesuai dengan kebutuhan, kadang satu ayat, dua ayat, tiga ayat, atau bahkan satu surat utuh.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat yang dimuliakan Allah''',
        },
        {
          'type': 'text',
          'content': '''Al-Qur\'an adalah kitab suci yang diturunkan kepada Nabi Muhammad SAW sebagai petunjuk bagi umat manusia. Kitab ini memiliki banyak keistimewaan. Selain menjadi kitab samawi terakhir, Al-Qur\'an juga merupakan satu-satunya kitab yang turun dalam dua fase.''',
        },
        {
          'type': 'text',
          'content': '''Syekh Manna Al-Qathan dalam kitabnya Mabahits fi Ulumil Qur\'an (halaman 96) menjelaskan bahwa, sebagaimana dituturkan oleh Ibnu Abbas dan disepakati mayoritas ulama, Al-Qur\'an mengalami dua fase turunnya.''',
        },
        {
          'type': 'text',
          'content': '''Fase pertama disebut fase inzali, yaitu turunnya Al-Qur\'an secara global dari Lauhul Mahfudz ke Baitul Izzah di langit dunia sebagai bentuk pengagungan terhadap Al-Qur\'an.''',
        },
        {
          'type': 'text',
          'content': '''Fase kedua disebut tanzili, yaitu turunnya Al-Qur\'an secara bertahap kepada Nabi Muhammad SAW selama 23 tahun, sesuai dengan peristiwa yang terjadi dan mempertimbangkan sebab turunnya ayat.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat yang dimuliakan Allah''',
        },
        {
          'type': 'text',
          'content': '''Dalam riwayat lain disebutkan bahwa bulan Ramadhan juga menjadi waktu di mana Nabi Muhammad SAW mendaras Al-Qur\'an bersama Malaikat Jibril. Karena itu, umat Islam sangat dianjurkan untuk memperbanyak membaca Al-Qur\'an di bulan yang mulia ini, dengan niat meneladani Nabi Muhammad SAW.''',
        },
        {
          'type': 'text',
          'content': '''Momen turunnya Al-Qur\'an serta semangat Nabi dalam mendarasnya inilah yang kemudian membuat Ramadhan juga disebut sebagai Syahru Nuzulil Qur\'an wa Tilawatih (bulan turunnya Al-Qur\'an dan bulan membacanya).''',
        },
        {
          'type': 'text',
          'content': '''Dalam sebuah hadits dijelaskan bahwa di bulan Ramadhan, Nabi Muhammad SAW menjadi lebih dermawan, dan setiap hari bertemu Jibril untuk membaca Al-Qur\'an. Seperti halnya puasa, Al-Qur\'an juga akan memberikan syafaat di hari kiamat. Salah satunya dalam hadits riwayat Ibnu Abbas yang artinya sebagai berikut:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنِ ابْنِ عَبَّاسٍ رَضِيَ اللَّهُ عَنْهُمَا، قَالَ: كَانَ رَسُولُ اللَّهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ ‌أَجْوَدَ ‌النَّاسِ، وَكَانَ أَجْوَدُ مَا يَكُونُ فِي رَمَضَانَ حِينَ يَلْقَاهُ جِبْرِيلُ، وَكَانَ جِبْرِيلُ يَلْقَاهُ فِي كُلِّ لَيْلَةٍ مِنْ رَمَضَانَ، فَيُدَارِسُهُ القُرْآنَ، فَلَرَسُولُ اللَّهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ حِينَ يَلْقَاهُ جِبْرِيلُ أَجْوَدُ بِالخَيْرِ مِنَ الرِّيحِ المُرْسَلَةِ''',
          'translation': '''Artinya: "Dari Ibnu Abbas RA, berkata, \'Rasulullah saw merupakan orang yang paling dermawan dan ia sangat dermawan saat bertemu malaikat Jibril. Jibril menemuinya setiap malam pada bulan Ramadhan dan membaca Al-Qur\'an dengan Nabi Muhammad SAW. Sungguh Rasulullah saw ketika bertemu Jibril sangat dermawan dengan kebaikan dibandingkan angin yang berhembus\'." (HR. Bukhari).''',
        },
        {
          'type': 'text',
          'content': '''Kesimpulannya, di bulan Ramadhan kali ini, mari kita tingkatkan kualitas ibadah kita kepada Allah SWT, salah satunya dengan memperbanyak tadarus Al-Qur\'an. Kita bisa menjalankan program one day one juz (satu hari satu juz) atau program lain yang membantu kita membiasakan diri membaca Al-Qur\'an. Semoga ini menjadi langkah awal untuk terus membaca Al-Qur\'an, bahkan setelah Ramadhan berakhir.''',
        },
        {
          'type': 'text',
          'content': '''Dengan begitu, kita telah memanfaatkan bulan Ramadhan sebaik mungkin untuk memperbaiki diri dan mempererat hubungan kita sebagai hamba dengan Allah SWT. Semoga kita termasuk orang-orang yang benar-benar memanfaatkan bulan suci ini dan menjadi bagian dari mereka yang disebut dalam firman-Nya sebagai orang-orang yang bertakwa.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللهُ لِيْ وَلَكُمْ فِي الْقُرْاٰنِ الْعَظِيْمِ وَنَفَعَنِي وَاِيَّاكُمْ بِمَا فِيْهِ مِنَ الْاٰيَاتِ وَالذِّكْرِ الْحَكِيْمِ وَتَقَبَّلَ مِنِّيْ وَمِنْكُمْ تِلَاوَتَهُ اِنَّهُ هُوَ السَّمِيْعُ الْعَلِيْمُ. وَأَسْتَغْفِرُ اللهَ الْعَظِيْمَ لِيْ وَلَكُمْ وَلِسَائِرِ الْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ فَيَا فَوْزَ الْمُسْتَغْفِرِيْنَ وَيَا نَجَاةَ التَّائِبِيْنَ''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''الْحَمْدُ للهِ الَّذِيْ أَنْعَمَنَا بِنِعْمَةِ الْاِيْمَانِ وَالْاِسْلَامِ. وَالصَّلَاةُ وَالسَّلَامُ عَلٰى سَيِّدِنَا مُحَمَّدٍ خَيْرِ الْأَنَامِ. وَعَلٰى اٰلِهِ وَأَصْحَابِهِ الْكِرَامِ. أَشْهَدُ اَنْ لَا اِلٰهَ اِلَّا اللهُ الْمَلِكُ الْقُدُّوْسُ السَّلَامُ وَأَشْهَدُ اَنَّ سَيِّدَنَا وَحَبِيْبَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ صَاحِبُ الشَّرَفِ وَالْإِحْتِرَامِ''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ. فَيَاأَيُّهَا النَّاسُ أُوْصِيْكُمْ وَنَفْسِيْ بِتَقْوَى اللهِ فَقَدْ فَازَ الْمُتَّقُوْنَ. فَقَالَ اللهُ تَعَالَى اِنَّ اللهَ وَ مَلَائِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّ يٰأَيُّهَا الَّذِيْنَ أٰمَنُوْا صَلُّوْا عَلَيْهِ وَ سَلِّمُوْا تَسْلِيْمًا''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلٰى سَيِّدِنَا مُحَمَّدٍ وَ عَلٰى أٰلِ سَيِّدِنَا مُحَمَّدٍ كَمَا صَلَّيْتَ عَلٰى سَيِّدِنَا اِبْرَاهِيْمَ وَبَارِكْ عَلٰى سَيِّدِنَا مُحَمَّدٍ وَعَلٰى أٰلِ سَيِّدِنَا مُحَمَّدٍ كَمَا بَارَكْتَ عَلٰى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلٰى أٰلِ سَيِّدِنَا اِبْرَاهِيْمَ فْي الْعَالَمِيْنَ اِنَّكَ حَمِيْدٌ مَجِيْدٌ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ وَارْضَ عَنِ الْخُلَفَاءِ الرَّاشِدِيْنَ. وَعَنْ اَصْحَابِ نَبِيِّكَ اَجْمَعِيْنَ. وَالتَّابِعِبْنَ وَتَابِعِ التَّابِعِيْنَ وَ تَابِعِهِمْ اِلٰى يَوْمِ الدِّيْنِ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ. اَللّٰهُمَّ ادْفَعْ عَنَّا الْغَلَاءَ وَالْوَبَاءَ وَالطَّاعُوْنَ وَالْاَمْرَاضَ وَالْفِتَنَ مَا لَا يَدْفَعُهُ غَيْرُكَ عَنْ بَلَدِنَا هٰذَا اِنْدُوْنِيْسِيَّا خَاصَّةً وَعَنْ سَائِرِ بِلَادِ الْمُسْلِمِيْنَ عَامَّةً يَا رَبَّ الْعَالَمِيْنَ. رَبَّنَا اٰتِنَا فِي الدُّنْيَا حَسَنَةً وَ فِي الْاٰخِرَةِ حَسَنَةً وَ قِنَا عَذَابَ النَّارِ. عِبَادَ اللهِ اِنَّ اللهَ يَأْمُرُ بِالْعَدْلِ وَالْاِحْسَانِ وَيَنْهَى عَنِ الْفَحْشَاءِ وَالْمُنْكَرِ. يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ. فَاذْكُرُوا اللهَ الْعَظِيْمَ يَذْكُرْكُمْ. وَ اشْكُرُوْهُ عَلٰى نِعَمِهِ يَزِدْكُمْ. وَلَذِكْرُ اللهِ اَكْبَرُ''',
        },
        {
          'type': 'text',
          'content': '''Alwi Jamalulel Ubab, Alumni Khas Kempek Cirebon dan Mahad Aly Jakarta''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Nuzulul Qur\'an dan Perintah Membaca',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Al-Qur\'an turun kepada Nabi Muhammad Saw dengan misi untuk memperbaiki tatanan kehidupan manusia. Bukan tanpa sebab, ternyata reformasi tersebut dimulai dengan memperkuat literasi umat. Hal ini dibuktikan dengan diturunkannya QS. Al-\'Alaq ayat 1-5 yang secara umum mengajak semua orang untuk membaca.''',
        },
        {
          'type': 'text',
          'content': '''Naskah Khutbah Jumat yang berjudul, "Khutbah Jumat: Nuzulul Qur\'an dan Perintah Membaca" ini mengajak kaum muslimin untuk mengingat dan mendalami makna di balik turunnya Al-Qur\'an untuk yang pertama kalinya.''',
        },
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''‌اَلْحَمْدُ ‌لِلّٰهِ ‌الَّذِيْ أَنْزَلَ عَلَى عَبْدِهِ الْكِتَابَ وَلَمْ يَجْعَلْ لَهُ عِوَجًا قَيِّمًا لِيُنْذِرَ بَأْسًا شَدِيْدًا مِنْ لَدُنْهُ وَيُبَشِّرَ الْمُؤْمِنِيْنَ، وَأَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ، اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى اٰلِهِ وَصَحْبِهِ أَجْمَعِيْنَ اَمَّا بَعْدُ، فَيَااَيُّهَا الْمُسْلِمُوْنَ، اِتَّقُوْا اللّٰهَ وَاعْلَمُوْٓا اَنَّكُمْ اِلَيْهِ تُحْشَرُوْنَ فَقَدْ قَالَ اللّٰهُ تَعَالَى  فِي كِتَابِهِ الْكَرِيْمِ اِقْرَأْ بِاسْمِ رَبِّكَ الَّذِيْ خَلَقَۚ، خَلَقَ الْاِنْسَانَ مِنْ عَلَقٍۚ، اِقْرَأْ وَرَبُّكَ الْاَكْرَمُۙ، الَّذِيْ عَلَّمَ بِالْقَلَمِۙ، عَلَّمَ الْاِنْسَانَ مَا لَمْ يَعْلَمْۗ''',
        },
        {
          'type': 'text',
          'content': '''Jamaah kaum muslimin yang dirahmati Allah
Puji dan syukur mari kita panjatkan ke hadirat Allah SWT yang tak henti-hentinya melimpahkan berbagai karunia dan kenikmatan kepada kita semua. Shalawat dan salam semoga selalu tercurahkan kepada Baginda Nabi Muhammad SAW, juga kepada para sahabat, para tabiin, tabi\' tabiin-nya, hingga kepada kita semua selaku umatnya.''',
        },
        {
          'type': 'text',
          'content': '''Khatib berpesan bagi diri sendiri dan jamaah sekalian, mari bersama-sama kita tingkatkan ketakwaan kepada Allah Swt. Sebab kelak di hari kiamat, kita akan dikumpulkan dalam keadaan menghadap-Nya. Sebagaimana dalam Al-Qur\'an Surat Al-Baqarah ayat 203 disebutkan:''',
        },
        {
          'type': 'arabic',
          'content': '''وَاتَّقُوْا اللّٰهَ وَاعْلَمُوْٓا اَنَّكُمْ اِلَيْهِ تُحْشَرُوْنَ''',
          'translation': '''Artinya: "Bertakwalah kepada Allah dan ketahuilah bahwa hanya kepada-Nya kamu akan dikumpulkan."''',
        },
        {
          'type': 'text',
          'content': '''Jamaah kaum muslimin yang dirahmati Allah''',
        },
        {
          'type': 'text',
          'content': '''Kita tentu masih mengingat peristiwa bersejarah ketika Nabi Muhammad Saw. menerima wahyu pertama dari Tuhannya. Peristiwa ini memberikan pelajaran yang sangat berharga. Saat itu, Nabi yang sedang beruzlah tiba-tiba didatangi malaikat Jibril yang membawa risalah dari Allah Swt.''',
        },
        {
          'type': 'text',
          'content': '''Kita tentu masih mengingat peristiwa bersejarah ketika Nabi Muhammad Saw menerima wahyu pertama dari Tuhannya. Peristiwa ini tentu memberikan pelajaran berharga. Saat itu, Nabi yang sedang uzlah tiba-tiba didatangi malaikat Jibril yang membawa risalah dari Allah Swt.''',
        },
        {
          'type': 'text',
          'content': '''Tiba-tiba Jibril berkata, "Bacalah!" sedangkan Nabi Muhammad Saw yang sedang tertidur menjadi bangun dan bingung dibuatnya. Sehingga Nabi menjawab seruan tersebut dengan berkata, "Apa yang akan aku baca?" dialog ini berlangsung lama dengan beberapa kali pengulangan kalimat yang sama. Sampai pada akhirnya, Jibril membacakan QS. Al-Alaq ayat 1-5.''',
        },
        {
          'type': 'text',
          'content': '''Sebagaimana hal ini diabadikan oleh Ibnu Hisyam dalam kitab Sirahnya, jilid 1, halaman 220-221:''',
        },
        {
          'type': 'arabic',
          'content': '''قَالَ رَسُولُ اللّٰهِ صَلَّى اللّٰهُ عَلَيْهِ وَسَلَّمَ: فَجَاءَنِي جِبْرِيْلُ وَأَنَا نَائِمٌ بِنَمَطِ مِنْ دِيبَاجٍ فِيْهِ كِتَابٌ فَقَالَ اِقْرَأْ قَالَ قُلْتُ: مَا أَقْرَأُ؟ قَالَ ‌فَغَتَّنِي ‌بِهِ ‌حَتَّى ‌ظَنَنْتُ ‌أَنَّهُ ‌الْمَوْتُ ثُمَّ أَرْسَلَنِيْ، فَقَالَ اِقْرَأْ قَالَ قُلْتُ: مَا أَقْرَأُ؟ قَالَ ‌فَغَتَّنِيْ ‌بِهِ ‌حَتَّى ‌ظَنَنْتُ ‌أَنَّهُ ‌الْمَوْتُ. ثُمَّ أَرْسَلَنِي، فَقَالَ اِقْرَأْ قَالَ قُلْتُ: مَاذَا أَقْرَأُ؟ قَالَ ‌فَغَتَّنِيْ ‌بِهِ ‌حَتَّى ‌ظَنَنْتُ ‌أَنَّهُ ‌الْمَوْتُ ثُمَّ أَرْسَلَنِي، فَقَالَ اِقْرَأْ قَالَ فَقُلْتُ: مَاذَا أَقْرَأُ؟ مَا أَقُوْلُ ذَلِكَ إِلَّا افْتِدَاءً مِنْهُ أَنْ يَعُودَ لِي بِمِثْلِ مَا صَنَعَ بِي، فَقَالَ {اقْرَأْ بِاسْمِ رَبّكَ الَّذِي خَلَقَ خَلَقَ الْإِنْسَانَ مِنْ عَلَقٍ اِقْرَأْ وَرَبُّكَ الْأَكْرَمُ الَّذِيْ عَلَّمَ بِالْقَلَمِ عَلَّمَ الْإِنْسَانَ مَا لَمْ يَعْلَمْ} [العلق: 1 – 5] قَالَ فَقَرَأَتُهَا ثُمّ انْتَهَى، فَانْصَرَفَ''',
          'translation': '''Artinya: "Rasulullah Saw bersabda: Jibril mendatangiku saat aku sedang tertidur dengan selimut yang terbuat dari sutera. Jibril tiba-tiba berkata, "Bacalah!", aku menjawab, "Apa yang akan aku baca?" Ketika itu Jibril memelukku sehingga aku mengira bahwa ia adalah malaikat maut, setelah itu dia melepasku.''',
        },
        {
          'type': 'text',
          'content': '''Selanjutnya Jibril kembali berkata, "Bacalah!" Nabi melanjutkan ceritanya, aku menjawab, "Apa yang akan aku baca?" Jibril memelukku lagi sehingga aku mengira bahwa ia adalah malaikat maut, setelah itu dia melepasku.''',
        },
        {
          'type': 'text',
          'content': '''Setelahnya Jibril mengulangi perkataannya, "Bacalah!" Nabi melanjutkan, aku menjawab, "Apa yang akan aku baca?" Jibril memelukku lagi untuk yang sekian kalinya sehingga aku mengira bahwa ia adalah malaikat maut, setelah itu dia melepasku kembali.''',
        },
        {
          'type': 'text',
          'content': '''Kemudian Jibril mengulang perkataannya untuk yang keempat kalinya, "Bacalah!" Nabi melanjutkan kisahnya dengan berkata, aku menjawab, "Apa yang akan aku baca?" Nabi berkata lagi, "Tidaklah aku mengatakan hal demikian, kecuali semata-mata untuk merespons apa yang Jibril lakukan kepadaku."''',
        },
        {
          'type': 'text',
          'content': '''Sehingga pada akhirnya Jibril berkata, "Bacalah dengan (menyebut) nama Tuhanmu yang menciptakan! Dia menciptakan manusia dari segumpal darah. Bacalah! Tuhanmu-lah Yang Maha mulia, yang mengajar (manusia) dengan pena. Dia mengajarkan manusia apa yang tidak diketahuinya." (QS. Al-\'Alaq [96]: 1-5) Nabi bercerita, lalu aku mengikuti bacaan tersebut dan Setelahnya Jibril pergi.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah kaum muslimin yang dirahmati Allah
Bukan tanpa sebab, ternyata Allah Swt menurunkan wahyu pertama berupa perintah sebagai landasan utama dalam membangun aspek fundamental yang diperlukan untuk mewujudkan reformasi masyarakat. Salah satu caranya ialah dengan menanamkan kesadaran tentang keberadaan Tuhan yang dapat dicapai melalui proses membaca.''',
        },
        {
          'type': 'text',
          'content': '''Melalui penguatan literasi dan peningkatan spiritual dapat mengantarkan peradaban manusia yang semula berada dalam kehidupan jahiliah, berkembang, dan berubah menjadi zaman pencerahan dengan datangnya cahaya Islam.''',
        },
        {
          'type': 'text',
          'content': '''Dengan sering membaca, manusia diharapkan bisa bertransformasi menjadi makhluk yang lebih baik. Nasiruddin al-Baidhawi dalam kitab Anwaruttanzil wa Asrarutta\'wil, jilid 5, halaman 325, menjelaskan bahwa QS. Al-Alaq ayat 1-2 menggambarkan tentang perintah Allah Swt kepada Nabi Muhammad Saw dan manusia  secara umum untuk membaca Al-Qur\'an, berupaya menyebut nama Allah saat memulai membacanya serta menampilkan hikmah luar biasa tentang proses penciptaan manusia yang berasal dari segumpal darah.''',
        },
        {
          'type': 'text',
          'content': '''Selanjutnya, dalam ayat 3-5 menggambarkan tentang keistimewaan Allah Swt yang telah memerintahkan hambanya untuk membaca, memberikan ilmu pengetahuan dan mengajarkan apa yang tidak mereka ketahui.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah kaum muslimin yang dirahmati Allah''',
        },
        {
          'type': 'text',
          'content': '''Tidak ada yang kebetulan di dunia ini, semua peristiwa yang terjadi merupakan ketetapan Allah yang dihiasi dengan pelajaran berharga untuk kehidupan manusia yang lebih baik.''',
        },
        {
          'type': 'text',
          'content': '''Berkenaan dengan sejarah turunnya wahyu pertama dalam Nuzulul Qur\'an, mengajarkan kita tentang urgensi membaca sebagai wasilah awal untuk mengubah peradaban umat manusia.''',
        },
        {
          'type': 'text',
          'content': '''Oleh karenanya, mari mengalokasikan waktu agar bisa menyempatkan diri untuk membaca guna menambah ilmu, pahala dan kedekatan bersama tuhan, khususnya dengan membaca Al-Qur\'an.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللّٰهُ لِيْ وَلَكُمْ فِي الْقُرْآنِ الْعَظِيْمِ، وَنَفَعَنِيْ وَإِيَّاكُمْ بِمَا فِيْهِ مِنَ اْلآيَاتِ وَالذِّكْرِ الْحَكِيْمِ. أَقُوْلُ قَوْلِيْ هَذَا وَأَسْتَغْفِرُ اللّٰهَ لِيْ وَلَكُمْ وَلِلْمُسْلِمِيْنَ فَاسْتَغْفِرُوْهُ إِنَّهُ هُوَ الْغَفُوْرُ الرَّحِيْمُ''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ عَلَى إِحْسَانِهِ وَالشُّكْرُ لَهُ عَلَى تَوْفِيْقِهِ وَامْتِنَانِهِ، وَأَشْهَدُ أَنْ لَا اِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ الدَّاعِى إلَى رِضْوَانِهِ، اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى اٰلِهِ وَاَصْحَابِهِ وَسَلِّمْ تَسْلِيْمًا كَثِيْرًا أَمَّا بَعْدُ فَيَا أَيُّهَا المُسْلِمُوْنَ اِتَّقُوْا اللّٰهَ فِيْمَا أَمَرَ وَانْتَهُوْا عَمَّا نَهَى''',
        },
        {
          'type': 'arabic',
          'content': '''وَاعْلَمُوْا أَنَّ اللّٰهَ أَمَرَكُمْ بِأَمْرٍ بَدَأَ فِيْهِ بِنَفْسِهِ وَثَـنَّى بِمَلآئِكَتِهِ بِقُدْسِهِ، وَقَالَ تَعَالَى إِنَّ اللّٰهَ وَمَلآئِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّ يَآ اَيُّهَا الَّذِيْنَ آمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا، اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَّى اللّٰهُ عَلَيْهِ وَسَلَّمَ وَعَلَى اٰلِ سَيِّدِنَا مُحَمَّدٍ وَعَلَى اَنْبِيَآئِكَ وَرُسُلِكَ وَمَلَآئِكَةِ المُقَرَّبِيْنَ وَارْضَ اللّٰهُمَّ عَنِ اْلخُلَفَاءِ الرَّاشِدِيْنَ أَبِى بَكْرٍ وَعُمَرَ وَعُثْمَانَ وَعَلِيِّ وَعَنْ بَقِيَّةِ الصَّحَابَةِ وَالتَّابِعِيْنَ وَتَابِعِيْ التَّابِعِيْنَ لَهُمْ بِاِحْسَانٍ اِلَى يَوْمِ الدِّيْنِ وَارْضَ عَنَّا مَعَهُمْ بِرَحْمَتِكَ يَا اَرْحَمَ الرَّاحِمِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ وَاْلمُسْلِمِيْنَ وَالْمُسْلِمَاتِ اَلاَحْيَآءِ مِنْهُمْ وَاْلاَمْوَاتِ اَللّٰهُمَّ أَعِزَّ الْإِسْلَامَ وَاْلمُسْلِمِيْنَ وَأَذِلَّ الشِّرْكَ وَاْلمُشْرِكِيْنَ وَانْصُرْ عِبَادَكَ الْمُوَحِّدِيَّةَ وَانْصُرْ مَنْ نَصَرَ الدِّيْنَ وَاخْذُلْ مَنْ خَذَلَ اْلمُسْلِمِيْنَ وَ دَمِّرْ أَعْدَاءَ الدِّيْنِ وَاعْلِ كَلِمَاتِكَ إِلَى يَوْمِ الدِّيْنِ. اَللّٰهُمَّ ادْفَعْ عَنَّا الْبَلَاءَ وَالْوَبَاءَ وَالزَّلاَزِلَ وَالْمِحَنَ وَسُوْءَ الْفِتَنِ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا اِنْدُوْنِيْسِيَّا خَآصَّةً وَسَائِرِ الْبُلْدَانِ الْمُسْلِمِيْنَ عَآمَّةً يَا رَبَّ الْعَالَمِيْنَ. رَبَّنَا ظَلَمْنَا اَنْفُسَنَا وَ اِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُوْنَنَّ مِنَ الْخَاسِرِيْنَ. رَبَّنَا آتِنَا فِى الدُّنْيَا حَسَنَةً وَفِى الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللّٰهِ، إِنَّ اللّٰهَ يَأْمُرُ بِالْعَدْلِ وَالْإِحْسَانِ وَإِيْتآءِ ذِيْ اْلقُرْبٰى وَيَنْهَى عَنِ اْلفَحْشَآءِ وَالْمُنْكَرِ وَالْبَغْيِ يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ وَاذْكُرُوْا اللّٰهَ اْلعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلَى نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللّٰهِ أَكْبَرُ وَ اللّٰهُ يَعْلَمُ مَا تَصْنَعُوْنَ''',
        },
        {
          'type': 'text',
          'content': '''Muhaimin Yasin, Alumnus Pondok Pesantren Ishlahul Muslimin Lombok Barat dan Pegiat Kajian Keislaman''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Ramadhan, Bulan Peduli Lingkungan dan Sosial',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Bulan Ramadhan merupakan momentum spesial untuk peningkatan kualitas pribadi di antaranya adalah kepedulian terhadap lingkungan dan orang lain. Pada momentum Ramadhan kali ini banyak sekali hal yang bisa kita jadikan pemicu untuk terus menguatkan kepedulian terhadap lingkungan di antaranya adalah bencana banjir dan meningkatkan kesalehan sosial dengan membantu mereka yang terdampak.''',
        },
        {
          'type': 'text',
          'content': '''Teks Khutbah Jumat berikut ini berjudul "Khutbah Jumat: Ramadhan, Bulan Peduli Lingkungan dan Sosial". Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!''',
        },
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ. اَلْحَمْدُ لِلّٰهِ الَّذِيْ حَمْدًا يُوَافِيْ نِعَمَهُ وَيُكَافِئُ مَزِيْدَهُ، يَا رَبَّنَا لَكَ الْحَمْدُ كَمَا يَنْبَغِيْ لِجَلَالِ وَجْهِكَ وَلِعَظِيْمِ سُلْطَانِكَ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ وَصَفِيُّهُ وَخَلِيْلُهُ، خَيْرُ نَبِيٍّ أَرْسَلَهُ اللّٰهُ إِلَى الْعَالَمِ كُلِّهِ بَشِيْرًا وَنَذِيْرًا. اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى اَلِ سَيِّدِنَا مُحَمَّدٍ صَلَاةً وَسَلَامًا مُتَلَازِمَيْنِ إِلَى يَوْمِ الدِّيْنِ. أَمَّا بَعْدُ، فَيَا أَيُّهَا الْحَاضِرُوْنَ، اِتَّقُوا اللّٰهَ حَقَّ تُقَاتِهِ وَلَا تَمُوْتُنَّ اِلَّا وَأَنْتُمْ مُسْلِمُوْنَ  قَالَ اللّٰهُ تَعَالَى فِي الْقُرْاٰنِ الْعَظِيْمِ، أَعُوْذُ بِاللّٰهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ، بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ: ظَهَرَ الْفَسَادُ فِى الْبَرِّ وَالْبَحْرِ بِمَا كَسَبَتْ اَيْدِى النَّاسِ لِيُذِيْقَهُمْ بَعْضَ الَّذِيْ عَمِلُوْا لَعَلَّهُمْ يَرْجِعُوْنَ''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah,''',
        },
        {
          'type': 'text',
          'content': '''Marilah kita senantiasa meningkatkan ketakwaan kita kepada Allah SWT dengan menjalankan segala perintah-Nya dan menjauhi segala larangan-Nya. Salah satu bentuk ketakwaan yang sering kita abaikan adalah kepedulian terhadap lingkungan hidup. Padahal, Islam mengajarkan kita untuk menjaga alam sebagai bentuk amanah dari Allah.''',
        },
        {
          'type': 'text',
          'content': '''Di bulan Ramadhan ini, kita bukan hanya dilatih untuk menahan lapar dan dahaga, tetapi juga melatih diri untuk menjadi pribadi yang shaleh secara personal dan soleh secara sosial. Kesolehan kita harus bisa terwujudkan dalam wujud mampu memberi kemaslahatan bagi diri dan lingkungan. Tidak merusak lingkungan setelah Allah menciptakannya dengan sangat sempurna. Allah SWT berfirman dalam Al-Qur\'an:''',
        },
        {
          'type': 'arabic',
          'content': '''وَلَا تُفْسِدُوْا فِى الْاَرْضِ بَعْدَ اِصْلَاحِهَا وَادْعُوْهُ خَوْفًا وَّطَمَعًاۗ اِنَّ رَحْمَتَ اللّٰهِ قَرِيْبٌ مِّنَ الْمُحْسِنِيْنَ ۝٥٦''',
          'translation': '''Artinya: "Dan janganlah kamu membuat kerusakan di muka bumi setelah Allah memperbaikinya." (QS. Al-A\'raf: 56)''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah,''',
        },
        {
          'type': 'text',
          'content': '''Saat ini, kita melihat dan merasakan sendiri bahwa intensitas hujan tinggi terjadi di bulan Ramadhan. Kondisi ini telah menyebabkan bencana banjir terjadi di berbagai daerah di negeri kita. Banyak saudara kita yang terdampak, kehilangan tempat tinggal, harta benda, bahkan nyawa. Ini menjadi pengingat bagi kita semua bahwa menjaga lingkungan adalah bagian dari ibadah dan amanah yang harus kita laksanakan.''',
        },
        {
          'type': 'text',
          'content': '''Banyak faktor yang menyebabkan bencana ini, salah satunya adalah ulah kita sendiri yang tidak menjaga alam dengan baik. Penebangan pohon secara liar, pembuangan sampah sembarangan, serta pembangunan yang tidak memperhatikan keseimbangan ekosistem menjadi penyebab utama bencana banjir dan longsor.''',
        },
        {
          'type': 'text',
          'content': '''Padahal Rasulullah SAW telah mengingatkan dalam sabdanya untuk benar-benar merawat lingkungan dengan contoh menanam pohon. Selain sebagai penjaga kelestarian lingkungan melalui resapan airnya dan oksigen yang bermanfaat bagi udara di bumi, menanam pohon juga merupakan ibadah yang masuk dalam kategori sedekah. Rasulullah SAW bersabda:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنْ جَابِرٍ، قَالَ: قَالَ رَسُولُ اللهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ: مَا مِنْ مُسْلِمٍ يَغْرِسُ غَرْسًا إِلَّا كَانَ مَا أُكِلَ مِنْهُ لَهُ صَدَقَةً، وَمَا سُرِقَ مِنْهُ لَهُ صَدَقَةٌ، وَمَا أَكَلَ السَّبُعُ مِنْهُ فَهُوَ لَهُ صَدَقَةٌ، وَمَا أَكَلَتِ الطَّيْرُ فَهُوَ لَهُ صَدَقَةٌ، وَلَا يَرْزَؤُهُ أَحَدٌ إِلَّا كَانَ لَهُ صَدَقَةٌ''',
          'translation': '''Artinya: "Jabir berkata bahwa Rasulullah Saw bersabda, Tidaklah seorang muslim menanam pohon kecuali buah yang dimakannya menjadi sedekah, yang dicuri menjadi sedekah, yang dimakan binatang buas adalah sedekah, yang dimakan burung adalah sedekah, dan tidak diambil seseorang kecuali menjadi sedekah," (HR. Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Maka, bulan Ramadhan ini mengingatkan kita untuk menjadikannya momentum lebih peduli terhadap lingkungan. Puasa mengajarkan kita untuk menahan diri dari tindakan yang merugikan, termasuk dalam merusak lingkungan. Mari kita mulai dari hal-hal kecil seperti membuang sampah pada tempatnya, mengurangi penggunaan plastik, serta menanam pohon untuk menjaga keseimbangan alam.''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah,''',
        },
        {
          'type': 'text',
          'content': '''Kelestarian alam yang terjaga pun akan menambah keindahan dan memberikan nilai estetika yang ternilai harganya. Pegunungan, hutan, dan lautan memberikan tempat untuk relaksasi dan rekreasi. Memelihara keindahan alam adalah investasi dalam kesejahteraan manusia secara keseluruhan.

Sehingga, menjaga lingkungan juga bagian berkontribusi periodik dalam upaya mengatasi perubahan iklim global. Konservasi energi, penggunaan sumber daya terbarukan, dan pengurangan emisi gas rumah kaca adalah langkah-langkah penting untuk menciptakan lingkungan yang berkelanjutan.
 
Dengan merawat dan menjaga lingkungan, kita membangun masa depan yang berkelanjutan, sehat, dan harmonis bagi manusia dan seluruh makhluk hidup. Tindakan kecil dari setiap individu dapat memiliki dampak besar jika dilakukan secara kolektif dengan penuh kesadaran.''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah,''',
        },
        {
          'type': 'text',
          'content': '''Di bulan yang penuh berkah ini, kita juga diajarkan untuk meningkatkan kepedulian sosial terhadap sesama. Bagi saudara-saudara kita yang terdampak bencana banjir, ini adalah ujian kesabaran. Allah berfirman:''',
        },
        {
          'type': 'arabic',
          'content': '''وَلَنَبْلُوَنَّكُمْ بِشَيْءٍ مِّنَ الْخَوْفِ وَالْجُوْعِ وَنَقْصٍ مِّنَ الْاَمْوَالِ وَالْاَنْفُسِ وَالثَّمَرٰتِۗ وَبَشِّرِ الصّٰبِرِيْنَ ۝١٥٥''',
          'translation': '''Artinya, "Dan sungguh akan Kami berikan cobaan kepadamu, dengan sedikit ketakutan, kelaparan, kekurangan harta, jiwa dan buah-buahan. Dan berilah kabar gembira kepada orang-orang yang sabar." (QS. Al-Baqarah: 155)''',
        },
        {
          'type': 'text',
          'content': '''Bagi kita yang tidak terdampak langsung, sudah seharusnya kita meningkatkan kepedulian dengan memberikan bantuan, baik berupa tenaga, harta, maupun doa. Sikap peduli pada penderitaan orang lain bisa menjadi barometer tingkat keimanan dan ketakwaan kita. Semakin beriman dan bertakwa kita, maka semakin tinggi tingkat sensitifnya terhadap masalah-masalah yang dihadapi oleh orang lain.''',
        },
        {
          'type': 'text',
          'content': '''Syekh Abdul Qadir Jailani dalam Fathur Rabbani wal Faydur Rahmani mengatakan: "Jika kamu menyukai makanan enak, pakaian bagus, rumah mewah, wanita cantik, dan harta yang berlimpah, sementara pada saat yang sama kamu menginginkan agar saudara seimanmu mendapatkan kebalikannya, maka sungguh bohong bila kamu mengaku memiliki iman yang sempurna. Wahai orang kurang akal! Kamu berdampingan dengan tetangga yang fakir dan mempunyai sanak-saudara miskin, sedangkan kamu memiliki harta yang sudah layak dizakati, keuntunganmu berlipat ganda setiap hari, dan kamu memiliki kekayaan lebih. Jika kamu enggan memberi dan menolong mereka, berarti kamu rela dengan kefakiran mereka."''',
        },
        {
          'type': 'text',
          'content': '''Inilah gambaran bagaimana Allah, Rasulullah, dan para ulama mengingatkan kita semua untuk memiliki kebersamaan yang tinggi dan kepedulian kolektif. Kita perlu ingat, keimanan tidak selamanya diukur berdasarkan jumlah ibadah mahdhoh seperti shalat, zikir, haji dan sebagainya. Walaupun kita rajin ibadah ritual dan percaya pada Allah jika kita tak memperkuat ibadah sosial atau tak peka pada lingkungan maka keimanan kita pun sangat layak dipertanyakan.''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah,''',
        },
        {
          'type': 'text',
          'content': '''Marilah kita jadikan bulan Ramadhan ini sebagai momen untuk meningkatkan kepedulian, tidak hanya kepada sesama manusia, tetapi juga kepada alam sekitar. Semoga Allah SWT menjadikan kita hamba-hamba-Nya yang bertakwa dan mencintai lingkungan sebagai bagian dari ibadah kita. Amin.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللّٰهُ لِيْ وَلَكُمْ فِيْ الْقُرْآنِ الْكَرِيْمِ وَنَفَعَنِيْ وَإِيَّاكُمْ بِمَا فِيْهِ مِنَ الذِّكْرِ الْحَكِيْمِ وَتَقَبَّلَ مِنِّيْ وَمِنْكُمْ تِلَاوَتَهُ إِنَّهُ هُوَ الْغَفُوْرُ الرَّحِيْمُ، فَاعْتَبِرُوْا يَآ أُوْلِى اْلأَلْبَابِ لَعَلَّكُمْ تُفْلِحُوْنَ''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ الَّذِي هَدَانَا لِهَذَا وَمَا كُنَّا لِنَهْتَدِيَ لَوْلَا أَنْ هَدَانَا اللّٰهُ. أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنْ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ لَا نَبِيَّ بَعْدَهُ. اَللّٰهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ المُجَاهِدِيْنَ الطَّاهِرِيْنَ.  أَمَّا بَعْدُ، فَيَا آيُّهَا الحَاضِرُوْنَ، أُوْصِيْكُمْ وَإِيَّايَ بِتَقْوَى اللّٰهِ وَطَاعَتِهِ لَعَلَّكُمْ تُفْلِحُوْنَ. يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ وَلَا تَمُوتُنَّ إِلَّا وَأَنْتُمْ مُسْلِمُونَ، وَتَزَوَّدُوا فَإِنَّ خَيْرَ الزَّادِ التَّقْوَى. فَقَدْ قَالَ اللّٰهُ تَعَالَى فِي كِتَابِهِ الْكَرِيْمِ أَعُوْذُ بِاللّٰهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ، بِسْمِ اللّٰهِ الرَّحْمَنِ الرَّحِيْمِ: وَالْعَصْرِ. إِنَّ الْإِنْسَانَ لَفِي خُسْرٍ. إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْر. إِنَّ اللَّهَ وَمَلَائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيمًا''',
        },
        {
          'type': 'arabic',
          'content': '''اللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى سَيِّدِنَا إِبْرَاهِيمَ وَعَلَى آلِ سَيِّدِنَا إِبْرَاهِيمَ، وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى سَيِّدِنَا إِبْرَاهِيمَ وَعَلَى آلِ سَيِّدِنَا إِبْرَاهِيمَ، فِى الْعَالَمِينَ إِنَّكَ حَمِيدٌ مَجِيدٌ   اَللّٰهُمَّ اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ. اَللّٰهُمَّ ادْفَعْ عَنَّا الْغَلَاءَ وَالْوَبَاءَ وَالطَّاعُوْنَ وَالْاَمْرَاضَ وَالْفِتَنَ مَا لَا يَدْفَعُهُ غَيْرُكَ عَنْ بَلَدِنَا هٰذَا اِنْدُوْنِيْسِيَّا خَاصَّةً وَعَنْ سَائِرِ بِلَادِ الْمُسْلِمِيْنَ عَامَّةً يَا رَبَّ الْعَالَمِيْنَ. رَبَّنَا اٰتِنَا فِي الدُّنْيَا حَسَنَةً وَ فِي الْاٰخِرَةِ حَسَنَةً وَ قِنَا عَذَابَ النَّارِ''',
        },
        {
          'type': 'arabic',
          'content': '''عٍبَادَ اللّٰهِ، إِنَّ اللّٰهَ يَأْمُرُ بِاْلعَدْلِ وَاْلإِحْسَانِ وَإِيْتاءِ ذِي اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشاءِ وَاْلمُنْكَرِ وَاْلبَغْيِ يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ، وَاذْكُرُوا اللّٰهَ اْلعَظِيْمَ يَذْكُرْكُمْ، وَاشْكُرُوْهُ عَلىَ نِعَمِهِ يَزِدْكُمْ، وَلَذِكْرُ اللّٰهِ أَكْبَرْ''',
        },
        {
          'type': 'text',
          'content': '''H Muhammad Faizin, Ketua PCNU Pringsewu, Lampung''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Manfaatkan 10 Hari Terakhir Ramadhan untuk Raih Lailatul Qadar',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Sepuluh hari terakhir bulan Ramdhan adalah masa yang paling berkah. Karena dalam hadits disebutkan bahwa Lailatul Qadar hadir pada salah satu dari malamnya. Siapa saja yang beruntung dapat bertemu dan beramal ibadah di waktu tersebut, maka ia akan memperoleh pahala atas amaliahnya lebih baik dibandingkan dengan melakukan perbuatan yang sama selama 1000 bulan di waktu yang berbeda.''',
        },
        {
          'type': 'text',
          'content': '''Naskah Khutbah Jumat berjudul, "Khutbah Jumat: Manfaatkan 10 Hari Terakhir Ramadhan untuk Raih Lailatul Qadar", mengajak kaum muslimin untuk meningkatkan semangat beribadah di penghujung bulan suci. Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ الَّذِيْ أَكْمَلَ لَنَا الدِّيْنَ وَتَمَّمَ عَلَيْنَا النِّعْمَةَ وَجَعَلَ شَهْرَ رَمَضَانَ مَوْسِمًا لِلْخَيْرَاتِ وَأَيَّامَهُ مِضْمَارًا لِلصَّالِحَاتِ، نَحْمَدُهُ تَعَالَى حَمْدًا كَثِيرًا وَنَشْكُرُهُ شُكْرًا جَمِيلًا. وَأَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنَّ سَيِّدَنَا وَنَبِيَّنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ، اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ أَجْمَعِيْنَ وَمَنْ تَبِعَهُمْ بِإِحْسَانٍ إِلَى يَوْمِ الدِّيْنِ، وَسَلَّمَ تَسْلِيْمًا كَثِيْرًا.أَمَّا بَعْدُ''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَا أَيُّهَا المُسْلِمُوْنَ، أُوْصِيْكُمْ وَنَفْسِيْ بِتَقْوَى اللّٰهِ، فَاتَّقُوْهُ حَقَّ تُقَاتِهِ، وَرَاقِبُوْهُ فِي السِّرِّ وَالعَلَانِيَةِ، فَقَدْ فَازَ المُتَّقُوْنَ. قَالَ اللّٰهُ تَعَالَى  فِي كِتَابِهِ الْكَرِيْمِ: اِنَّآ اَنْزَلْنٰهُ فِيْ لَيْلَةِ الْقَدْرِ وَمَآ اَدْرٰىكَ مَا لَيْلَةُ الْقَدْرِۗ لَيْلَةُ الْقَدْرِ ەۙ خَيْرٌ مِّنْ اَلْفِ شَهْرٍۗ تَنَزَّلُ الْمَلٰۤىِٕكَةُ وَالرُّوْحُ فِيْهَا بِاِذْنِ رَبِّهِمْۚ مِنْ كُلِّ اَمْرٍۛ سَلٰمٌ ۛهِيَ حَتّٰى مَطْلَعِ الْفَجْرِ ࣖ.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah kaum muslimin yang dirahmati oleh Allah''',
        },
        {
          'type': 'text',
          'content': '''Segala puji dan syukur mari kita panjatkan atas kehadirat Allah swt yang telah melimpahkan berbagai macam nikmat berserta karunia-Nya kepada kita semua. Shalawat teriring salam semoga senantiasa tercurahkan kepada baginda Nabi Muhammad saw, para sahabat, tabi\'in dan seluruh generasi penerus mereka hingga saat ini.''',
        },
        {
          'type': 'text',
          'content': '''Khatib berpesan bagi diri sendiri dan jamaah, mari bersama-sama kita tingkatkan ketakwaan kepada Allah dengan sebenar-benarnya takwa serta jangan sampai kita meninggal dunia kecuali dalam keadaan muslim. Dalam Al-Qur\'an diterangkan:''',
        },
        {
          'type': 'arabic',
          'content': '''يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوا اتَّقُوْا اللّٰهَ حَقَّ تُقٰىتِهٖ وَلَا تَمُوْتُنَّ اِلَّا وَاَنْتُمْ مُّسْلِمُوْنَ''',
          'translation': '''Artinya, "Wahai orang-orang yang beriman, bertakwalah kepada Allah dengan sebenar-benar takwa kepada-Nya dan janganlah kamu mati kecuali dalam keadaan muslim." (Surat Ali Imran ayat 102).''',
        },
        {
          'type': 'text',
          'content': '''Jamaah kaum muslimin yang dirahmati oleh Allah''',
        },
        {
          'type': 'text',
          'content': '''Hidup di dunia ini diibaratkan sebagai sebuah arena perlombaan. Setiap manusia pasti ikut menjadi peserta kompetisi, namun dengan cabang yang berbeda-beda. Ada yang berlomba-lomba dalam mengejar jabatan, harta, tahta, kesenangan duniawi dan lain sebagainya. Selain itu ada juga yang berpartisipasi dalam lomba mengerjakan amal kebaikan dengan sebanyak-banyaknya.''',
        },
        {
          'type': 'text',
          'content': '''Perlombaan dalam kebaikan inilah yang paling bermanfaat dan dianjurkan dalam Islam. Dalam Al-Qur\'an disebutkan:''',
        },
        {
          'type': 'arabic',
          'content': '''فَاسْتَبِقُوْا الْخَيْرٰتِۗ''',
          'translation': '''Artinya, "Maka, berlomba-lombalah kamu dalam berbagai kebajikan." (Surat Al-Baqarah ayat 148).''',
        },
        {
          'type': 'text',
          'content': '''Jamaah kaum muslimin yang dirahmati oleh Allah''',
        },
        {
          'type': 'text',
          'content': '''Setiap tahun para ulama, penceramah dan guru-guru kita selalu mengingatkan betapa dahsyatnya keutamaan yang dimiliki oleh Lailatul Qadar. Suatu malam yang apabila kita beribadah di dalamnya lebih baik dibandingkan dengan beribadah selama seribu bulan di waktu yang lain dan padanya pula diturunkan kitab suci Al-Qur\'an.''',
        },
        {
          'type': 'text',
          'content': '''Tentu saja betapa ruginya kita jika menyia-nyiakan kesempatan emas di sepuluh hari terakhir bulan suci ini, dengan tidak memanfaatkannya untuk mencari berkah Lailatul Qadar melalui optimalisasi diri serta berlomba-lomba dalam mengerjakan kebaikan. Apalagi dengan pahala yang berlipat ganda.''',
        },
        {
          'type': 'text',
          'content': '''Rasulullah saw saja apabila bertemu dengan sepuluh hari terakhir pada bulan suci Ramadhan, maka beliau akan meningkatkan semangat dan intensitas ibadahnya. Sebagaimana hal ini disampaikan oleh Aisyah ra dalam sebuah hadits:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنْ عَائِشَةَ رَضِيَ اللّٰهُ عَنْهَا قَالَتْ: كَانَ النَّبِيُّ صَلَّى اللّٰهُ عَلَيْهِ وَسَلَّمَ ‌إِذَا ‌دَخَلَ ‌الْعَشْرُ ‌شَدَّ مِئْزَرَهُ، وَأَحْيَا لَيْلَهُ، وَأَيْقَظَ أَهْلَهُ''',
          'translation': '''Artinya, "Dari Aisyah ra, ia berkata: "Nabi Muhammad saw apabila memasuki sepuluh hari terakhir bulan Ramadhan, maka beliau mengencangkan ikatan sarungnya, menghidupkan malamnya dan membangunkan keluarganya." (HR Al-Bukhari).''',
        },
        {
          'type': 'text',
          'content': '''Mazharuddin Az-Zaidani dalam kitab Al-Mafatih fi Syarhil Mashabih, jilid 1, halaman 55, menjelaskan, makna dari \'mengencangkan ikatan sarungnya\' dalam penggalan hadits ialah perumpamaan yang menggambarkan kesungguhan Nabi Muhammad saw yang hendak melakukan perkara ibadah. Selain itu, mengencangkan sarung juga diibaratkan sebagai simbol untuk meninggalkan kegiatan hubungan intim bersama istri.''',
        },
        {
          'type': 'text',
          'content': '''Az-Zaidani juga merincikan bahwa yang dimaksud dalam \'membangunkan keluarganya\' pada hadits tersebut ialah Nabi Muhammad saw mengajak keluarganya untuk melakukan ibadah dan mencari Lailatul Qadar dalam 10 hari terakhir bulan Ramadhan.''',
        },
        {
          'type': 'text',
          'content': '''Menambahkan penjelasan dari Az-Zaidani, Syamsuddin Al-Birmawi dalam kitab Al-Lami\'us Shabih bi Syarhil Jami\' As-Shahih, jilid 6, halaman 491, menyebutkan, \'menghidupkan malam\' dalam hadits tersebut maksudnya adalah Nabi Muhammad saw meninggalkan tidur malam, membangunkan dirinya untuk melaksanakan shalat malam yang dibarengi dengan ketaatan lain.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah kaum muslimin yang dirahmati oleh Allah''',
        },
        {
          'type': 'text',
          'content': '''Selain mengencangkan ikatan sarung, menghidupkan malam-malam dan membangunkan segenap keluarganya, Nabi Muhammad Saw juga menampilkan semangat yang berbeda ketika mendapati sepuluh hari terakhir di bulan suci Ramadhan.''',
        },
        {
          'type': 'text',
          'content': '''Dalam hadits yang diriwayatkan oleh Aisyah ra disebutkan:''',
        },
        {
          'type': 'arabic',
          'content': '''قَالَتْ عَائِشَةُ رَضِيَ اللهُ عَنْهَا: كَانَ رَسُولُ اللهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ يَجْتَهِدُ فِي الْعَشْرِ الْأَوَاخِرِ ‌مَا ‌لَا ‌يَجْتَهِدُ ‌فِي ‌غَيْرِهِ''',
          'translation': '''Artinya, "Aisyah ra berkata: "Rasulullah saw bersungguh-sungguh pada 10 hari terakhir (bulan Ramadhan) yang tidak pernah beliau lakukan di waktu lain." (HR Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Jamaah kaum muslimin yang dirahmati oleh Allah''',
        },
        {
          'type': 'text',
          'content': '''Berlomba-lomba dalam kebaikan di 10 hari terakhir bulan Ramadhan hendaklah diwujudkan dengan memperbanyak amal ibadah, berbagi kepada sesama, meningkatkan intensitas dzikir kepada Allah dan mengajak seluruh anggota keluarga. Sebagaimana hal yang sama seperti yang dilakukan oleh Rasulullah saw.''',
        },
        {
          'type': 'text',
          'content': '''Dalam 10 hari terakhir bulan suci Ramadhan ini juga kita dianjurkan memperbanyak berdoa kepada Allah swt untuk memohon ampun atas kesalahan yang diperbuat. Salah satu doa yang dianjurkan oleh Rasulullah saw untuk menghiasi ibadah kita ialah sebagaimana yang tercantum dalam hadits:''',
        },
        {
          'type': 'arabic',
          'content': '''‌اَللّٰهُمَّ ‌إِنَّكَ ‌عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي''',
          'translation': '''Artinya, "Ya Allah, engkau adalah maha pengampun. Maka ampunilah aku."''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللّٰهُ لِيْ وَلَكُمْ فِي الْقُرْآنِ الْعَظِيْمِ، وَنَفَعَنِيْ وَإِيَّاكُمْ بِمَا فِيْهِ مِنَ اْلآيَاتِ وَالذِّكْرِ الْحَكِيْمِ. أَقُوْلُ قَوْلِيْ هَذَا وَأَسْتَغْفِرُ اللّٰهَ لِيْ وَلَكُمْ وَلِلْمُسْلِمِيْنَ فَاسْتَغْفِرُوْهُ إِنَّهُ هُوَ الْغَفُوْرُ الرَّحِيْمُ''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ عَلَى إِحْسَانِهِ وَالشُّكْرُ لَهُ عَلَى تَوْفِيْقِهِ وَامْتِنَانِهِ. وَأَشْهَدُ أَنْ لَا اِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ الدَّاعِى إلَى رِضْوَانِهِ. اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى اٰلِهِ وَاَصْحَابِهِ وَسَلِّمْ تَسْلِيْمًا كَثِيْرًا أَمَّا بَعْدُ''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَا أَيُّهَا المُسْلِمُوْنَ اِتَّقُوْا اللّٰهَ فِيْمَا أَمَرَ وَانْتَهُوْا عَمَّا نَهَى. وَاعْلَمُوْا أَنَّ اللّٰهَ أَمَرَكُمْ بِأَمْرٍ بَدَأَ فِيْهِ بِنَفْسِهِ وَثَـنَّى بِمَلآئِكَتِهِ بِقُدْسِهِ وَقَالَ تَعَالَى: إِنَّ اللّٰهَ وَمَلآئِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّ يَآ اَيُّهَا الَّذِيْنَ آمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا. اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَّى اللّٰهُ عَلَيْهِ وَسَلَّمَّ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ وَعَلَى اَنْبِيَآئِكَ وَرُسُلِكَ وَمَلَآئِكَةِ الْمُقَرَّبِيْنَ، وَارْضَ اللّٰهُمَّ عَنِ الْخُلَفَاءِ الرَّاشِدِيْنَ أَبِى بَكْرٍ وَعُمَرَ وَعُثْمَانَ وَعَلِيِّ وَعَنْ بَقِيَّةِ الصَّحَابَةِ وَالتَّابِعِيْنَ وَتَابِعِيْ التَّابِعِيْنَ لَهُمْ بِاِحْسَانٍ اِلَى يَوْمِ الدِّيْنِ وَارْضَ عَنَّا مَعَهُمْ بِرَحْمَتِكَ يَا اَرْحَمَ الرَّاحِمِيْنَ. اَللّٰهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ وَالْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ اَلاَحْيَآءِ مِنْهُمْ وَالْاَمْوَاتِ اَللّٰهُمَّ أَعِزَّ الْإِسْلَامَ وَالْمُسْلِمِيْنَ وَأَذِلَّ الشِّرْكَ وَالْمُشْرِكِيْنَ وَانْصُرْ عِبَادَكَ الْمُوَحِّدِيَّةَ وَانْصُرْ مَنْ نَصَرَ الدِّيْنَ وَاخْذُلْ مَنْ خَذَلَ الْمُسْلِمِيْنَ وَ دَمِّرْ أَعْدَاءَ الدِّيْنِ وَاعْلِ كَلِمَاتِكَ إِلَى يَوْمِ الدِّيْنِ. اَللّٰهُمَّ ادْفَعْ عَنَّا الْبَلَاءَ وَالْوَبَاءَ وَالزَّلاَزِلَ وَالْمِحَنَ وَسُوْءَ الْفِتَنِ وَالْمِحَنِ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا اِنْدُونِيْسِيَّا خَآصَّةً وَسَائِرِ الْبُلْدَانِ الْمُسْلِمِيْنَ عَآمَّةً يَا رَبَّ الْعَالَمِيْنَ. رَبَّنَا ظَلَمْنَا اَنْفُسَنَا وَ اِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُوْنَنَّ مِنَ الْخَاسِرِيْنَ. رَبَّنَا آتِنَا فِى الدُّنْيَا حَسَنَةً وَفِى الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللّٰهِ! إِنَّ اللّٰهَ يَأْمُرُ بِالْعَدْلِ وَالْإِحْسَانِ وَإِيْتآءِ ذِيْ الْقُرْبٰى وَيَنْهَى عَنِ الْفَحْشَآءِ وَالْمُنْكَرِ وَالْبَغْيِ يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ وَاذْكُرُوْا اللّٰهَ الْعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلَى نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللّٰهِ أَكْبَرُ وَ اللّٰهُ يَعْلَمُ مَا تَصْنَعُوْنَ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Muhaimin Yasin, Alumnus Pondok Pesantren Ishlahul Muslimin Lombok Barat dan Pegiat Kajian Keislaman''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Menggapai Lailatul Qadar dengan Sabar dan Ibadah yang Ikhlas',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Lailatul Qadar adalah malam penuh berkah, yang pahala ibadahnya lebih besar dari 1000 bulan. Malam istimewa ini dinanti setiap Muslim untuk mendekatkan diri kepada Allah dengan keikhlasan dan kesabaran. Meraih Lailatul Qadar bukan sekadar memperbanyak ibadah, tapi juga melatih kesabaran dalam menghadapi ujian hidup.''',
        },
        {
          'type': 'text',
          'content': '''Naskah khutbah Jumat berikut ini berjudul, "Khutbah Jumat: Menggapai Lailatul Qadar dengan Sabar dan Ibadah yang Ikhlas". Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!''',
        },
        {
          'type': 'arabic',
          'content': '''​​​​​​اَلْحَمْدُ ِللهِ. اَلْحَمْدُ ِللهِ الَّذِيْ حَمْدًا يُوَافِيْ نِعَمَهُ وَيُكَافِئُ مَزِيْدَهُ، يَا رَبَّنَا لَكَ الْحَمْدُ كَمَا يَنْبَغِيْ لِجَلَالِ وَجْهِكَ وَلِعَظِيْمِ سُلْطَانِكَ سُبْحَانَكَ. اَللّٰهُمَّ لَا أُحْصِيْ ثَنَاءَكَ عَلَيْكَ أَنْتَ كَمَا أَثْنَيْتَ عَلَى نَفْسِكَ. أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ وَصَفِيُّهُ وَخَلِيْلُهُ، خَيْرُ نَبِيٍّ أَرْسَلَهُ اللهُ إِلَى الْعَالَمِ كُلِّهِ بَشِيْرًا وَنَذِيْرًا. اَللّٰهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى اَلِ سَيِّدِنَا مُحَمَّدٍ صَلَاةً وَسَلَامًا مُتَلَازِمَيْنِ إِلَى يَوْمِ الدِّيْنِ. أَمَّا بَعْدُ، فَيَاأَيُّهَا الْحَاضِرُوْنَ اِتَّقُوا اللهَ حَقَّ تُقَاتِهِ وَلَا تَمُوْتُنَّ اِلَّا وَأَنْتُمْ مُسْلِمُوْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''قَالَ اللهُ تَعَالَى فِي الْقُرْاٰنِ الْعَظِيْمِ، أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ، بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ 
إِنَّآ اَنْزَلْنٰهُ فِيْ لَيْلَةِ الْقَدْرِ ۝١
وَمَآ اَدْرٰىكَ مَا لَيْلَةُ الْقَدْرِۗ ۝٢
لَيْلَةُ الْقَدْرِ ەۙ خَيْرٌ مِّنْ اَلْفِ شَهْرٍۗ ۝٣
تَنَزَّلُ الْمَلٰۤىِٕكَةُ وَالرُّوْحُ فِيْهَا بِاِذْنِ رَبِّهِمْۚ مِنْ كُلِّ اَمْرٍۛ ۝٤
سَلٰمٌۛ هِيَ حَتّٰى مَطْلَعِ الْفَجْرِࣖ ۝٥''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin Jamaah shalat Jumat rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Sebagai wujud rasa terima kasih kepada Allah swt yang telah menganugerahkan nikmat yang tidak bisa kita hitung satu persatu, menjadi keniscayaan bagi kita untuk senantiasa mengungkapkan rasa syukur bi qaulina: "Alhamdulillahirabbilalamin".''',
        },
        {
          'type': 'text',
          'content': '''Nikmat tersebut diantaranya adalah anugerah umur panjang sehingga kita masih bisa menikmati kesejukan di bulan Ramadhan kali ini. Dan pada momentum saat ini kita sudah memasuki 10 hari ketiga bulan suci Ramadhan dengan berbagai keutamaan ibadah di dalamnya.''',
        },
        {
          'type': 'text',
          'content': '''Shalawat dan salam semoga senantiasa tercurahkan kepada Nabi Muhammad saw yang telah mengajarkan kepada kita bagaimana bersyukur pada nikmat yang kita dapat dan juga bersabar atas segala musibah, kecil maupun besar.''',
        },
        {
          'type': 'text',
          'content': '''Dalam kitab As-Shabru wats Tsawâb \'Alaihi halaman 30, Imam Ibnu Abid Dunya mencantumkan hadits riwayat Sayyidina Ali bin Abi Thalib, Rasulullah saw bersabda:''',
        },
        {
          'type': 'arabic',
          'content': '''الصَّبْرُ ثَلَاثٌ: فَصَبْرٌ عَلَى الْمُصِيبَةِ، وَصَبْرٌ عَلَى الطَّاعَةِ، وَصَبْرٌ عَنِ الْمَعْصِيَةِ''',
          'translation': '''Artinya, "Sabar ada tiga tingkatan; sabar atas musibah, sabar dalam menjalani ketaatan, dan sabar dari laku kemaksiatan."''',
        },
        {
          'type': 'arabic',
          'content': '''فَمَنْ صَبَرَ عَلَى الْمُصِيبَةِ حَتَّى يَرُدَّهَا بِحُسْنِ عَزَائِهَا كَتَبَ اللَّهُ لَهُ ثَلَاثَمِائَةِ دَرَجَةٍ بَيْنَ الدَّرَجَةِ إِلَى الدَّرَجَةِ كَمَا بَيْنَ السَّمَاءِ إِلَى الْأَرْضِ''',
        },
        {
          'type': 'text',
          'content': '''"Siapa saja yang sabar menghadapi musibah, sampai ia mampu merestorasinya sebaik mungkin, Allah akan mengangkat 300 derajatnya, yang mana satu dengan lainnya berjarak sejauh antara langit dan bumi."''',
        },
        {
          'type': 'arabic',
          'content': '''وَمَنْ صَبَرَ عَلَى الطَّاعَةِ كَتَبَ اللَّهُ لَهُ سِتَّمِائَةِ دَرَجَةٍ، مَا بَيْنَ الدَّرَجَةِ إِلَى الدَّرَجَةِ كَمَا بَيْنَ تُخُومِ الْأَرْضِ إِلَى مُنْتَهَى الْعَرْشِ''',
        },
        {
          'type': 'text',
          'content': '''"Orang yang bersabar dalam menjalani ketaatan, Allah mengangkat 600 derajatnya. Di mana, satu dengan lainnya berjarak sejauh antara lapisan-lapisan bumi dan batas (ketinggian) \'Arsy."''',
        },
        {
          'type': 'arabic',
          'content': '''وَمِنْ صَبَرَ عَنِ الْمَعْصِيَةِ كَتَبَ اللَّهُ لَهُ تِسْعَمِائَةِ دَرَجَةٍ، مَا بَيْنَ الدَّرَجَةِ إِلَى الدَّرَجَةِ كَمَا بَيْنَ تُخُومِ الْأَرْضِ إِلَى مُنْتَهَى الْعَرْشِ مَرَّتَيْنِ''',
        },
        {
          'type': 'text',
          'content': '''"Sedangkan, orang yang bersabar dari laku kemaksiatan, Allah mengangkat 900 derajatnya. Di mana, satu dengan lainnya berjarak sekitar dua kali lipat antara lapisan-lapisan bumi dan batas (ketinggian) \'Arsy".''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin Jamaah shalat Jumat rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Kesabaran dalam diri kita bisa dilatih dan diraih dari perjuangan menggapai keutamaan Lailatul Qadar. Malam mulia ini hanya terjadi pada bulan Ramadhan yang kapan harinya masih menjadi misteri.''',
        },
        {
          'type': 'text',
          'content': '''Selain menjadi malam yang penuh berkah dan pengampunan, Lailatul Qadar juga memiliki kaitan erat dengan pembentukan kesabaran dalam diri kita. Menanti malam tersebut, beribadah dengan istiqamah, serta menerima ketetapan Allah adalah bagian dari latihan spiritual yang dapat membentuk jiwa yang lebih sabar.''',
        },
        {
          'type': 'text',
          'content': '''Mencapai Lailatul Qadar bukanlah perkara mudah. Malam ini menjadi ujian kesabaran dalam berbagai aspek kehidupan kita. Kesabaran pertama yang diuji adalah dalam menunggu waktu yang dirahasiakan. Keberadaan Lailatul Qadar tidak diketahui secara pasti, hanya disebutkan berada dalam sepuluh malam terakhir Ramadhan.''',
        },
        {
          'type': 'text',
          'content': '''Rasulullah saw menganjurkan umat Islam untuk mencarinya di malam-malam ganjil, sehingga diperlukan kesabaran dan kesungguhan dalam beribadah setiap malam.''',
        },
        {
          'type': 'text',
          'content': '''Kesabaran juga dibutuhkan dalam beribadah secara istiqamah. Ibadah pada Lailatul Qadar dilakukan tanpa mengetahui kapan pahala terbesar diberikan.''',
        },
        {
          'type': 'text',
          'content': '''Hal ini melatih kita untuk beribadah dengan ikhlas, bukan sekadar mengharapkan balasan langsung. Selain itu, malam ini menjadi momentum untuk muhasabah dan introspeksi diri.''',
        },
        {
          'type': 'text',
          'content': '''Dalam Surat Al-Baqarah ayat 286 Allah mengingatkan dan mengajarkan kita menerima segala ketetapan-Nya dengan hati yang lapang. Ayat ini berisi untaian doa yang sering kita panjatkan:''',
        },
        {
          'type': 'arabic',
          'content': '''لَا يُكَلِّفُ اللّٰهُ نَفْسًا اِلَّا وُسْعَهَاۗ لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْۗ رَبَّنَا لَا تُؤَاخِذْنَآ اِنْ نَّسِيْنَآ اَوْ اَخْطَأْنَاۚ رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَآ اِصْرًا كَمَا حَمَلْتَهٗ عَلَى الَّذِيْنَ مِنْ قَبْلِنَاۚ رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهٖۚ وَاعْفُ عَنَّاۗ وَاغْفِرْ لَنَاۗ وَارْحَمْنَاۗ اَنْتَ مَوْلٰىنَا فَانْصُرْنَا عَلَى الْقَوْمِ الْكٰفِرِيْنَࣖ''',
          'translation': '''Artinya, "Allah tidak membebani seseorang, kecuali menurut kesanggupannya. Baginya ada sesuatu (pahala) dari (kebajikan) yang diusahakannya dan terhadapnya ada (pula) sesuatu (siksa) atas (kejahatan) yang diperbuatnya.''',
        },
        {
          'type': 'text',
          'content': '''(Mereka berdoa,) "Wahai Tuhan kami, janganlah Engkau hukum kami jika kami lupa atau kami salah. Wahai Tuhan kami, janganlah Engkau bebani kami dengan beban yang berat sebagaimana Engkau bebankan kepada orang-orang sebelum kami.''',
        },
        {
          'type': 'text',
          'content': '''Wahai Tuhan kami, janganlah Engkau pikulkan kepada kami apa yang tidak sanggup kami memikulnya. Maafkanlah kami, ampunilah kami, dan rahmatilah kami. Engkaulah pelindung kami. Maka, tolonglah kami dalam menghadapi kaum kafir."''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin Jamaah shalat Jumat rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Lailatul Qadar bukan hanya malam penuh berkah, tetapi juga kesempatan emas untuk melatih kesabaran dalam menanti, beribadah, dan menghadapi kehidupan. Keistimewaan malam ini seharusnya menjadi motivasi bagi kita untuk semakin mendekatkan diri kepada Allah.''',
        },
        {
          'type': 'text',
          'content': '''Jangan sampai kesempatan ini terlewat begitu saja. Semoga kita semua dapat meraih keberkahan Lailatul Qadar dan menjadi insan yang lebih sabar serta lebih baik di hadapan Allah.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللهُ لِيْ وَلَكُمْ فِي الْقُرْاٰنِ الْعَظِيْمِ، وَنَفَعَنِي وَاِيَّاكُمْ بِمَا فِيْهِ مِنَ الْاٰيَاتِ وَالذِّكْرِ الْحَكِيْمِ، وَتَقَبَّلَ مِنِّيْ وَمِنْكُمْ تِلَاوَتَهُ اِنَّهُ هُوَ السَّمِيْعُ الْعَلِيْمُ. وَأَسْتَغْفِرُ اللهَ الْعَظِيْمَ لِيْ وَلَكُمْ وَلِسَائِرِ الْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ، فَيَا فَوْزَ الْمُسْتَغْفِرِيْنَ وَيَا نَجَاةَ التَّائِبِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''الْحَمْدُ للهِ الَّذِيْ أَنْعَمَنَا بِنِعْمَةِ الْاِيْمَانِ وَالْاِسْلَامِ. وَالصَّلَاةُ وَالسَّلَامُ عَلٰى سَيِّدِنَا مُحَمَّدٍ خَيْرِ الْأَنَامِ. وَعَلٰى اٰلِهِ وَأَصْحَابِهِ الْكِرَامِ. أَشْهَدُ اَنْ لَا اِلٰهَ اِلَّا اللهُ الْمَلِكُ الْقُدُّوْسُ السَّلَامُ وَأَشْهَدُ اَنَّ سَيِّدَنَا وَحَبِيْبَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ صَاحِبُ الشَّرَفِ وَالْإِحْتِرَامِ''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ. فَيَا أَيُّهَا النَّاسُ أُوْصِيْكُمْ وَنَفْسِيْ بِتَقْوَى اللهِ فَقَدْ فَازَ الْمُتَّقُوْنَ. فَقَالَ اللهُ تَعَالَى اِنَّ اللهَ وَ مَلَائِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّ يٰأَيُّهَا الَّذِيْنَ أٰمَنُوْا صَلُّوْا عَلَيْهِ وَ سَلِّمُوْا تَسْلِيْمًا''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلٰى سَيِّدِنَا مُحَمَّدٍ وَ عَلٰى أٰلِ سَيِّدِنَا مُحَمَّدٍ كَمَا صَلَّيْتَ عَلٰى سَيِّدِنَا اِبْرَاهِيْمَ وَبَارِكْ عَلٰى سَيِّدِنَا مُحَمَّدٍ وَعَلٰى أٰلِ سَيِّدِنَا مُحَمَّدٍ كَمَا بَارَكْتَ عَلٰى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلٰى أٰلِ سَيِّدِنَا اِبْرَاهِيْمَ فْي الْعَالَمِيْنَ اِنَّكَ حَمِيْدٌ مَجِيْدٌ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ وَارْضَ عَنِ الْخُلَفَاءِ الرَّاشِدِيْنَ. وَعَنْ اَصْحَابِ نَبِيِّكَ اَجْمَعِيْنَ. وَالتَّابِعِبْنَ وَتَابِعِ التَّابِعِيْنَ وَ تَابِعِهِمْ اِلٰى يَوْمِ الدِّيْنِ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ. اَللّٰهُمَّ ادْفَعْ عَنَّا الْغَلَاءَ وَالْوَبَاءَ وَالطَّاعُوْنَ وَالْاَمْرَاضَ وَالْفِتَنَ مَا لَا يَدْفَعُهُ غَيْرُكَ عَنْ بَلَدِنَا هٰذَا اِنْدُوْنِيْسِيَّا خَاصَّةً وَعَنْ سَائِرِ بِلَادِ الْمُسْلِمِيْنَ عَامَّةً يَا رَبَّ الْعَالَمِيْنَ. رَبَّنَا اٰتِنَا فِي الدُّنْيَا حَسَنَةً وَ فِي الْاٰخِرَةِ حَسَنَةً وَ قِنَا عَذَابَ النَّارِ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ، اِنَّ اللهَ يَأْمُرُ بِالْعَدْلِ وَالْاِحْسَانِ وَيَنْهَى عَنِ الْفَحْشَاءِ وَالْمُنْكَرِ. يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ. فَاذْكُرُوا اللهَ الْعَظِيْمَ يَذْكُرْكُمْ. وَ اشْكُرُوْهُ عَلٰى نِعَمِهِ يَزِدْكُمْ. وَلَذِكْرُ اللهِ اَكْبَرُ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz H Muhammad Faizin, Ketua PCNU Kabupaten Pringsewu, Lampung''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Sedekah sebagai Peredam Murka Allah dan Amalan yang Mampu Mengubah Takdir',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Tahukah Anda bahwa sedekah bisa menjadi kunci untuk meredam murka Allah dan membuka pintu rahmat-Nya? Di khutbah Jumat kali ini, kita akan membahas betapa pentingnya sedekah sebagai amalan yang tidak hanya menumbuhkan kasih sayang, tetapi juga menjadi sarana utama untuk mendapatkan ampunan-Nya. Mari kita simak betapa besar manfaat sedekah yang disertai dengan niat yang tulus, dan bagaimana ia mampu memadamkan kemarahan Allah Ta\'ala.''',
        },
        {
          'type': 'text',
          'content': '''Teks khutbah Jumat berikut ini berjudul: "Khutbah Jumat: Sedekah Sebagai Peredam Murka Allah dan Amalan yang Mampu Mengubah Takdir". Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat! (Redaksi).''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ الَّذِي أَوْضَحَ لَنَا شَرَائِعَ دِيْنِهِ، وَمَنَّ عَلَيْنَا بِتَنْزِيلِ كِتَابِهِ وَأَمَدَّنَا بِسُنَّةِ رَسُولِهِ، فَلِلّٰهِ الْحَمْدُ عَلَى مَا أَنْعَمَ بِهِ مِنْ هِدَايَتِهِ. وَالصَّلَاةُ وَالسَّلَامُ عَلَى خَيْرِ الْإِنْسَانِ مُبَيِّنًا عَلَى رِسَالَةِ الرَّحْمَنِ نَبِيِّنَا مُحَمَّدٍ وَعَلَى اَلِهِ وَصَحْبِهِ الْمَحْبُوْبِيْنَ جَمِيْعًا. وَأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، شَهَادَةَ مُوْقِنٍ بِتَوْحِيْدِهِ، مُسْتَجِيْرٍ بِحَسَنِ تَأْيِيْدِهِ. وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّداً عَبْدُهُ الْمُصْطَفَى، وَأَمِيْنُهُ الْمُجْتَبَي وَرَسُوْلُهُ الْمَبْعُوْثُ إِلَى كَافَةِ الْوَرَى أَمَّا بَعْدُ''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَاعِبَادَ اللّٰهِ، اِتَّقِ اللَّهَ حَيْثُمَا كُنْتَ وَأَتْبِعِ السَّيِّئَةَ الْحَسَنَةَ تَمْحُهَا وَخَالِقِ النَّاسَ بِخُلُقٍ حَسَنٍ. قَالَ اللّٰهُ تَعَالَى فِي كِتَابِهِ الكَرِيْمِ: يَٰٓأَيُّهَا ٱلَّذِينَ ءَامَنُواْ كُتِبَ عَلَيۡكُمُ ٱلصِّيَامُ كَمَا كُتِبَ عَلَى ٱلَّذِينَ مِن قَبۡلِكُمۡ لَعَلَّكُمۡ تَتَّقُونَ''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Di hari yang mulia ini Khatib berwasiat kepada hadirin sekalian khususnya untuk diri khatib pribadi, untuk selalu meningkatkan kualitas ketakwaan kita kepada Allah ta\'ala. Dengan selalu menjaga perintah-Nya dan menjauhi segala bentuk larangan-Nya. Karena dengan ketakwaan kita berharap bisa menggapai ridha Allah dan ampunan-Nya.''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Kita tahu bahwa Baginda nabi Muhammad saw merupakan pribadi yang sangat dermawan, terutama di bulan Ramadhan, sebagaimana diriwayatkan:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنِ ابْنِ عَبَّاسٍ: كَانَ رَسُولُ اللهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ أَجْوَدَ النَّاسِ وَكَانَ أَجْوَدُ مَا يَكُونُ فِي رَمَضَانَ''',
          'translation': '''Artinya, "Dari sahabat Ibnu Abbas: \'Rasulullah saw adalah orang paling dermawan di antara manusia lainnya, dan beliau nabi semakin dermawan saat berada di bulan Ramadhan\'." (HR Al-Bukhari dan Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Hal ini dikarenakan beliau mengetahui betul bahwa dermawan adalah sifat utama yang dimiliki oleh orang-orang pilihan. Beliau juga menjelaskan tentang pentingnya sedekah tidak hanya untuk saling peduli pada lingkungan sekitar, namun dengan sedekah pula kemurkaan Allah bisa dipadamkan. Nabi saw bersabda:''',
        },
        {
          'type': 'arabic',
          'content': '''صَدَقَةُ السِّرِّ تُطْفِىُّ غَضَبَ الرَّبِّ''',
          'translation': '''Artinya, "Sedekah yang dilakukan secara rahasia dapat memadamkan kemarahan Allah ta\'ala." (HR At-Tirmidzi).''',
        },
        {
          'type': 'text',
          'content': '''Karenanya, sedekah menjadi penting sekali untuk kita yang selalu menyulut kemarahan Allah baik sengaja ataupun tidak. Kita tentu sadar bahwa kita merupakan manusia yang menjadi tempat lupa dan alpa, maka sudah sepantasnya kita mengetahui amalan amalan yang memantaskan kita mendapat ampunan dari Allah ta\'ala.''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Sedekah merupakan simbol kebaikan pada diri seorang mukmin. Sedekah tidaklah bisa dilakukan oleh orang orang kecuali mereka yang memiliki rasa welas asih. Artinya memiliki rasa kasih sayang yang besar kepada semua makhluk.''',
        },
        {
          'type': 'text',
          'content': '''Syekh Nawawi Al-Bantani dalam mukadimah kitab Nashaihul \'Ibad mengisahkan:''',
        },
        {
          'type': 'arabic',
          'content': '''"Suatu ketika ada seseorang yang berjumpa Imamِl-Ghazali dalam mimpi. Lalu orang tersebut bertanya: \'Bagaimana Allah memperlakukanmu wahai Imam?\'''',
        },
        {
          'type': 'text',
          'content': '''Imam Al-Ghazali mengisahkan, di hadapan Allah ia ditanya tentang bekal apa yang diserahkan untuk-Nya. Al-Ghazali pun menjawab dengan menyebut satu per satu seluruh prestasi ibadah yang pernah dijalani di dunia.''',
        },
        {
          'type': 'text',
          'content': '''"Aku (Allah) menolak itu semua!" Ternyata Allah menolak berbagai amalan Imam Al-Ghazali kecuali satu kebaikannya ketika bertemu dengan seekor lalat.''',
        },
        {
          'type': 'text',
          'content': '''Sebab suatu saat, Imam Al-Ghazali sibuk menulis kitab ada seekor lalat yang mengganggunya. Lalat ini haus dan tinta yang dipakai menulis kitab sang imam diminumnya barang sedikit. Sang Imam yang merasa kasihan lantas berhenti menulis untuk memberi kesempatan si lalat melepas dahaga dari tintanya itu. Sebab sedekah tinta kepada lalat inilah Allah berfirman kepadaku: \'Masuklah bersama hamba-Ku ke surga\'.".''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Ini bukan berarti amal Imam Al-Ghazali yang lain tidak berguna. Namun kisah ini menunjukkan betapa ketulusan bersedekah mampu membawa seseorang menggapai ridha dan ampunan Allah ta\'ala.''',
        },
        {
          'type': 'text',
          'content': '''Janganlah kita meremehkan sedekah walaupun terlihat tidak bernilai. Karena sekalipun secara sekilas tidak bernilai di mata manusia, belum tentu sama dengan penilaian Allah swt. Baginda Nabi saw bersabda:''',
        },
        {
          'type': 'arabic',
          'content': '''اِتَّقُوا النَّارَ وَلَوْ بِشِقِّ تَمْرَةٍ فَمَنْ لَمْ يَجِدْ فَبِكَلِمَةٍ طَيِّبَةٍ''',
        },
        {
          'type': 'text',
          'content': '''‎Artinya, "Jagalah diri kalian dari neraka sekalipun hanya dengan sedekah sebiji kurma, kalaulah tidak ‎bisa, maka dengan ucapan yang baik." (HR Al-Bukhari).''',
        },
        {
          'type': 'text',
          'content': '''Ini merupakan anjuran tegas dari Baginda Nabi saw kepada umat muslim agar tidak meremehkan sedekah walaupun sekecil biji kurma.''',
        },
        {
          'type': 'text',
          'content': '''Terlebih sedekah di bulan Ramadhan, bulan yang mulia yang sedekah didalamnya merupakan sedekah paling utama. Sebagaimana sabda Baginda nabi ketika ditanya tentang sedekah yang paling utama:''',
        },
        {
          'type': 'arabic',
          'content': '''أيُّ الصَّدَقَةِ أفْضَلُ؟ قَالَ: صَدَقَةٌ فِى رَمَضَانَ''',
          'translation': '''Artinya, ‎‎"Rasulullah saw pernah ditanya: \'Sedekah apakah yang paling utama?\' Beliau ‎menjawab: \'Yaitu sedekah di bulan Ramadhan\'." (HR At-Tirmidzi)‎.''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah‎''',
        },
        {
          'type': 'text',
          'content': '''Demikian khutbah di siang mulia ini. Semoga semua amal ibadah kita di bulan Ramadhan dan bulan-bulan lainnya diterima oleh Allah ta\'ala. Amin ya Rabbal \'alamin.''',
        },
        {
          'type': 'arabic',
          'content': '''أَقُوْلُ قَوْلِيْ هٰذَا وَأَسْتَغْفِرُ اللّٰهَ لِيْ وَلَكُمْ، فَاسْتَغْفِرُوْهُ، إِنَّهُ هُوَ الْغَفُوْرُ الرَّحِيْمُ''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ عَلَى إِحْسَانِهِ وَالشُّكْرُ لَهُ عَلَى تَوْفِيْقِهِ وَامْتِنَانِهِ. وَأَشْهَدُ أَنْ لاَ اِلَهَ إِلاَّ اللّٰهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ وَأَشْهَدُ أنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ الدَّاعِى إلَى رِضْوَانِهِ. اَللّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى اَلِهِ وَأَصْحَابِهِ وَسَلِّمْ تَسْلِيْمًا كَثِيْرًا، أَمَّا بَعْدُ

فَياَ اَيُّهَا النَّاسُ، إِتَّقُوااللّٰهَ فِيْمَا أَمَرَ وَانْتَهُوْا عَمَّا نَهَى، وَاعْلَمُوْا أَنَّ اللّٰهَ أَمَرَكُمْ بِأَمْرٍ عَظِيْمٍ، أَمَرَكُمْ بِالصَّلَاةِ وَالسَّلَامِ عَلَى نَبِيِّهِ الْكَرِيْمِ. فقَالَ تَعَالَى: إِنَّ اللّٰهَ وَمَلَآئِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِى، يَآ اَيُّهَا الَّذِيْنَ آمَنُوْا صَلُّوْا عَلٰيْهِ وَسَلِّمُوْا تَسْلِيْمًا.''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى سَيِّدِنَا إِبْرَاهِيْمَ وَعَلَى آلِ سَيِّدِنَا إِبْرَاهِيْمَ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى سَيِّدِنَا إِبْرَاهِيْمَ وَعَلَى آلِ سَيِّدِنَا إِبْرَاهِيْمَ، فِيْ الْعَالَمِيْنَ إِنَّكَ حَمِيْدٌ مَجِيْدٌ

اَللّهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَاْلمُؤْمِنَاتِ وَاْلمُسْلِمِيْنَ وَاْلمُسْلِمَاتِ اَلاَحْيآءِ مِنْهُمْ وَاْلاَمْوَاتِ. اَللّٰهُمَّ أَعِزَّ اْلإِسْلاَمَ وَاْلمُسْلِمِيْنَ وَأَذِلَّ الشِّرْكَ وَاْلمُشْرِكِيْنَ وَانْصُرْ مَنْ نَصَرَ الدِّيْنَ وَاخْذُلْ مَنْ خَذَلَ اْلمُسْلِمِيْنَ وَ دَمِّرْ أَعْدَاءَ الدِّيْنِ وَأَعْلِ كَلِمَاتِكَ إِلَى يَوْمِ الدِّيْنِ. اَللَّهُمَّ ادْفَعْ عَنَّا اْلبَلاَءَ وَاْلوَبَاءَ وَالزَّلاَزِلَ وَاْلمِحَنَ وَسُوْءَ اْلفِتَنِ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا اِنْدُونِيْسِيَّا خآصَّةً وَسَائِرِ بُلْدَانِ اْلمُسْلِمِيْنَ عآمَّةً يَا رَبَّ اْلعَالَمِيْنَ. اللَّهُمَّ أَصْلِحْ لَنَا دِيْنَنَا الَّذِيْ هُوَ عِصْمَةُ أَمْرِنَا، وَأَصْلِحْ لَنَا دُنْيَانَا الَّتِيْ فِيْهَا مَعَاشُنَا، وَأَصْلِحْ لَنَا آخِرَتَنَا الَّتِيْ إِلَيْهَا مَعَادُنَا، وَاجْعَلِ الحَيَاةَ زِيَادَةً لَنَا فِيْ كُلِّ خَيْرٍ، وَاجْعَلِ المَوْتَ رَاحَةً لَنَا مِنْ كُلِّ شَرٍّ بِرَحْمَتِكَ يَاأَرْحَمَ الرّٰحِمِيْنَ. رَبَّنَا آتِناَ فِى الدُّنْيَا حَسَنَةً وَفِى اْلآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَاللّٰهِ، إِنَّ اللّٰهَ يَأْمُرُ بِاْلعَدْلِ وَاْلإِحْسَانِ وَإِيْتآءِ ذِي اْلقُرْبَى وَيَنْهَى عَنِ اْلفَحْشَآءِ وَاْلمُنْكَرِ وَاْلبَغْيِ. يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ. وَاذْكُرُوا اللّٰهَ اْلعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلَى نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللّٰهِ أَكْبَرُ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Abdul Karim Malik, Alumni Al-Falah Ploso Kediri, Pengurus LBM PCNU Kabupaten Bekasi dan Tenaga Pengajar Pondok Pesantren YAPINK Tambun-Bekasi.''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Tiga Tingkatan Orang yang Berpuasa Ramadhan, Mengapa Puasa Anda Bisa Berbeda?',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Di bulan Ramadhan yang penuh berkah, setiap orang berpuasa dengan cara dan tujuan yang berbeda. Tiga tingkatan puasa menurut Imam Al-Ghazali memberikan pemahaman mendalam tentang bagaimana kualitas puasa kita bisa membawa kita lebih dekat kepada Allah. Apakah kita hanya sekadar menahan lapar dan dahaga, atau sudah berusaha untuk membersihkan hati dan memperbaiki diri? Khutbah Jumat ini akan mengajak kita merenungi tingkatan-tingkatan puasa yang mungkin belum kita sadari.''',
        },
        {
          'type': 'text',
          'content': '''Naskah khutbah Jumat ini berjudul, "Khutbah Jumat: Tiga Tingkatan Orang yang Berpuasa Ramadhan, Mengapa Puasa Anda Bisa Berbeda?" Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ الَّذِي هَدَانَا لِطَرِيْقِهِ الْقَوِيْمِ، وَفَقَّهَنَا فِي دِيْنِهِ الْمُسْتَقِيْمِ. أَشْهَدُ أَنْ لَا إِلٰهَ إلَّا اللّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ شَهَادَةً تُوَصِّلُنَا إِلىَ جَنَّاتِ النَّعِيْمِ، وَتَكُوْنُ سَبَبًا لِلنَّظْرِ إِلَى وَجْهِهِ الْكَرِيْمِ. وَأَشْهَدُ أَنَّ سَيِّدَنَا وَنَبِيَّنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ السَّيِّدُ السَّنَدُ الْعَظِيْمُ. اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَأَصْحَابِهِ أُوْلِى الْفَضْلِ الْجَسِيْمِ. أَمَّا بَعْدُ''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَا عِبَادَ الْكَرِيْمِ، فَإِنِّي أُوْصِيكُمْ بِتَقْوَى اللَّهِ الْحَكِيْمِ، اَلْقَائِلِ فِي كِتَابِهِ الْقُرْآنِ الْعَظِيْمِ: يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin jamaah Jumat yang dirahmati Allah''',
        },
        {
          'type': 'text',
          'content': '''Puji syukur alhamdulillahi Rabbil \'alamin, mari senantiasa kita ucapkan melalui lisan dan kita aplikasikan dalam kehidupan sehari-hari, atas segala nikmat dan karunia yang telah Allah berikan kepada kita semua tanpa terhitung jumlahnya. Khususnya kita masih diberi kesempatan untuk beribadah dan berjumpa kembali dengan bulan suci Ramadhan, bulan yang penuh berkah, ampunan, dan limpahan rahmat dari Allah. Semoga setiap ibadah yang kita lakukan di dalamnya diterima sebagai amal saleh dan semakin mendekatkan kita kepada-Nya.''',
        },
        {
          'type': 'text',
          'content': '''Shalawat dan salam mari senantiasa kita haturkan kepada junjungan kita, Nabi Muhammad saw, allahumma shalli wa sallim wa barik \'alaih, yang telah menjadi panutan dan teladan sempurna bagi kita semua dalam menjalankan kehidupan di dunia, khususnya beribadah di bulan Ramadhan. Semoga kita semua diakui sebagai umatnya, dan mendapatkan syafaatnya kelak di akhirat. Amin ya Rabbal \'alamin.''',
        },
        {
          'type': 'text',
          'content': '''Sudah menjadi  kewajiban bagi kami selaku Khatib, untuk senantiasa mengingatkan jamaah shalat Jumat agar senantiasa meningkatkan keimanan dan ketakwaan kepada Allah swt, yaitu dengan terus istiqamah dalam menunaikan semua kewajiban dan meninggalkan larangan-larangan-Nya.''',
        },
        {
          'type': 'text',
          'content': '''Dengan takwa, itu artinya kita sedang mempersiapkan bekal untuk kita bawa menuju akhirat, karena pada hakikatnya, dunia adalah tempat kita menanam, dan akhirat tempat kita memanen. Allah swt berfirman dalam Al-Qur\'an:''',
        },
        {
          'type': 'arabic',
          'content': '''وَتَزَوَّدُوا فَإِنَّ خَيْرَ الزَّادِ التَّقْوَى وَاتَّقُونِ يَا أُولِي الأَلْبَابِ''',
          'translation': '''Artinya, "Bawalah bekal, karena sesungguhnya sebaik-baik bekal adalah takwa. Dan bertakwalah kepada-Ku wahai orang-orang yang mempunyai akal sehat." (Surat Al-Baqarah ayat 197).​​​​​''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin jamaah Jumat yang dirahmati Allah''',
        },
        {
          'type': 'text',
          'content': '''Tidak terasa kita semua sudah berada di pertengahan akhir bulan Ramadhan. Tidak lama lagi bulan mulia nan penuh berkah akan segera meninggalkan kita semua.''',
        },
        {
          'type': 'text',
          'content': '''Namun perlu kita syukuri, bahwa dengan berpuasa di bulan ini, kita tidak hanya menahan lapar dan dahaga saja, tetapi juga melatih kesabaran, keikhlasan, serta kedisiplinan dalam menjalankan perintah Allah. Sebab, inilah spirit dari tujuan puasa itu sendiri, yaitu untuk meningkatkan ketakwaan kepada-Nya, sebagaimana ditegaskan dalam Al-Qur\'an. Allah swt berfirman:''',
        },
        {
          'type': 'arabic',
          'content': '''يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ''',
          'translation': '''Artinya, "Wahai orang-orang yang beriman! Diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa." (Surat Al-Baqarah ayat 183).''',
        },
        {
          'type': 'text',
          'content': '''Perlu kita ketahui bersama, setiap orang yang berpuasa di bulan Ramadhan memiliki cara dan pemahaman yang berbeda. Ada yang sekadar menahan diri dari makan dan minum. Ada juga yang juga menahan ucapan untuk tidak berkata kotor, menahan mata untuk tidak melihat sesuatu yang dilarang dalam Islam. Ada pula yang benar-benar menjadikannya sebagai momen untuk memperbaiki diri dan mendekatkan hati kepada Allah.''',
        },
        {
          'type': 'text',
          'content': '''Karena itu, Hujjatul Islam Abu Hamid Al-Ghazali dalam kitab Ihya Ulumiddin, jilid I, halaman 234, mengatakan, derajat orang yang berpuasa terbagi menjadi tiga:''',
        },
        {
          'type': 'text',
          'content': '''Seperti apa kriteria dari masing-masing ketiganya? Imam Al-Ghazali menjelaskan:''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا صَوْمُ الْعُمُوْمِ فَهُوَ كَفُّ الْبَطْنِ وَالْفَرْجِ عَنْ قَضَاءِ الشَّهْوَةِ. وَأَمَّا صَوْمُ الْخُصُوْصِ فَهُوَ كَفُّ السَّمْعِ وَالْبَصَرِ وَاللِّسَانِ وَالْيَدِ وَالرِّجْلِ وَسَائِرِ الْجَوَارِحِ عَنِ الْآثَامِ. وَأَمَّا صَوْمُ خُصُوْصِ الْخُصُوْصِ فَصَوْمُ الْقَلْبِ عَنِ الْهِمَمِ الدَّنِيَّةِ وَالْأَفْكَارِ الدُّنْيَوِيَّةِ وَكَفُّهُ عَمَّا سِوَى اللهِ بِالْكُلِّيَّةِ''',
          'translation': '''Artinya, "Adapun puasa orang awam, yaitu menahan perut dan kemaluan dari memenuhi syahwat. Adapun puasa orang pilihan, yaitu menahan pendengaran, penglihatan, lisan, tangan, kaki, dan seluruh anggota tubuh dari perbuatan dosa.''',
        },
        {
          'type': 'text',
          'content': '''Sedangkan puasa orang yang sangat istimewa, yaitu puasa hati dari keinginan-keinginan rendah dan pikiran-pikiran duniawi, serta menahannya dari segala sesuatu selain Allah secara total."''',
        },
        {
          'type': 'text',
          'content': '''Lantas, di tingkatan manakah puasa kita berada?''',
        },
        {
          'type': 'text',
          'content': '''Apakah kita masih berada dalam tingkatan awam yang sekadar menahan lapar dan dahaga?''',
        },
        {
          'type': 'text',
          'content': '''Ataukah kita sudah berusaha menjaga seluruh anggota tubuh dari maksiat, sebagaimana puasanya orang-orang pilihan?''',
        },
        {
          'type': 'text',
          'content': '''Atau bahkan, kita telah mencapai puncak kesempurnaan dengan menjaga hati dari segala sesuatu selain Allah?''',
        },
        {
          'type': 'text',
          'content': '''Sisa-sisa Ramadhan yang masih ada ini merupakan waktu yang tepat untuk merenungi hal ini, agar puasa yang kita jalani tidak sekadar menjadi rutinitas tahunan, melainkan benar-benar menjadi jalan menuju derajat yang lebih tinggi di sisi Allah swt.''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin jamaah Jumat yang dirahmati Allah''',
        },
        {
          'type': 'text',
          'content': '''Sebab itu, mari kita manfaatkan sebaik mungkin sisa-sisa bulan Ramadhan yang masih ada ini, dengan meningkatkan value puasa kita menjadi lebih baik dan terus meningkat. Jangan biarkan detik-detik yang tersisa berlalu begitu saja tanpa ada peningkatan dalam ibadah dan ketakwaan kita.''',
        },
        {
          'type': 'text',
          'content': '''Jika sebelumnya kita masih berada di tingkatan puasa orang awam, maka berusahalah naik ke tingkat yang lebih tinggi dengan menjaga seluruh anggota tubuh dari perbuatan dosa. Jika kita telah berada di tingkatan puasa orang pilihan, maka berupayalah untuk sampai pada puncaknya, yaitu puasanya hati yang benar-benar terhubung kepada Allah.''',
        },
        {
          'type': 'text',
          'content': '''Demikian adanya khutbah Jumat perihal tiga tingkatan derajat orang yang berpuasa di bulan Ramadhan. Semoga khutbah ini tidak hanya menjadi pengingat, tetapi juga menjadi motivasi bagi kita semua untuk terus meningkatkan kualitas ibadah, khususnya dalam menjalankan puasa.''',
        },
        {
          'type': 'text',
          'content': '''Mari kita jadikan sisa Ramadhan ini sebagai kesempatan untuk memperbaiki diri, mendekatkan hati kepada Allah, dan meraih derajat puasa yang lebih tinggi di sisi-Nya.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللهُ لِيْ وَلَكُمْ، وَنَفَعَنِيْ وَاِيَاكُمْ بِمَا فِيْهِ مِنَ اْلآيَاتِ وَالذِّكْرِ الْحَكِيْمِ، وَتَقَبَّلَ مِنِّيْ وَمِنْكُمْ جَمِيْعَ أَعْمَالِنَا إِنَّهُ هُوَ الْحَكِيْمُ الْعَلِيْمُ. أَقُوْلُ قَوْلِيْ هَذَا وَأَسْتَغْفِرُ اللهَ لِيْ وَلَكُمْ وَلِلْمُسْلِمِيْنَ فَاسْتَغْفِرُوْهُ اِنَّهُ هُوَ الْغَفُوْرُ الرَّحِيْمُ''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ للهِ حَمْدًا كَمَا أَمَرَ. أَشْهَدُ أَنْ لَا اِلَهَ اِلَّا الله وَحْدَهُ لَا شَرِيْكَ لَهُ، اِلَهٌ لَمْ يَزَلْ عَلَى كُلِّ شَيْءٍ وَكِيْلًا. وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ وَحَبِيْبُهُ وَخَلِيْلُهُ، أَكْرَمِ الْأَوَّلِيْنَ وَالْأَخِرِيْنَ، اَلْمَبْعُوْثِ رَحْمَةً لِلْعَالَمِيْنَ. اَللّهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلىَ أَلِهِ وَأَصْحَابِهِ وَمَنْ كَانَ لَهُمْ مِنَ التَّابِعِيْنَ، صَلَاةً دَائِمَةً بِدَوَامِ السَّمَوَاتِ وَالْأَرْضِيْنَ.أَمَّا بَعْدُ''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَا أَيُّهَا الْحَاضِرُوْنَ، اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ وَذَرُوْا الْفَوَاحِشَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ. وَحَافِظُوْا عَلَى الطَّاعَةِ وَحُضُوْرِ الْجُمْعَةِ وَالْجَمَاعَةِ وَالصَّوْمِ وَجَمِيْعِ الْمَأْمُوْرَاتِ وَالْوَاجِبَاتِ. وَاعْلَمُوْا أَنَّ اللهَ أَمَرَكُمْ بِأَمْرٍ بَدَأَ بِنَفْسِهِ. وَثَنَى بِمَلَائِكَةِ الْمُسَبِّحَةِ بِقُدْسِهِ. إِنَّ اللَّهَ وَمَلائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيماً''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلَى آلِ سَيِّدِنَا اِبْرَاهِيْمَ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلَى آلِ سَيِّدِنَا اِبْرَاهِيْمَ فِيْ العَالَمِيْنَ اِنَّكَ حَمِيْدٌ مَجِيْدٌ. اَللّهُمَّ اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ اَلْأَحْيَاءِ مِنْهُمْ وِالْأَمْوَاتِ. اَللّهُمَّ ادْفَعْ عَنَّا الْبَلَاءَ وَالْغَلَاءَ وَالْوَبَاءَ وَالْفَحْشَاءَ وَالْمُنْكَرَ وَالْبَغْيَ وَالسُّيُوْفَ الْمُخْتَلِفَةَ وَالشَّدَائِدَ وَالْمِحَنَ، مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ، مِنْ بَلَدِنَا هَذَا خَاصَةً وَمِنْ بُلْدَانِ الْمُسْلِمِيْنَ عَامَةً، اِنَّكَ عَلَى كُلِّ شَيْءٍ قَدِيْرٌ
​​​​​​​''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ، اِنَّ اللهَ يَأْمُرُ بِالْعَدْلِ وَالْاِحْسَانِ وَاِيْتَاءِ ذِيْ الْقُرْبَى وَيَنْهَى عَنِ الْفَحْشَاءِ وَالْمُنْكَرِ وَالْبَغْيِ، يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ. فَاذْكُرُوْا اللهَ الْعَظِيْمَ يَذْكُرُكُمْ وَلَذِكْرُ اللهِ أَكْبَرُ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Sunnatullah, Pengajar di Pondok Pesantren Al-Hikmah Darussalam Durjan Kokop Bangkalan Jawa Timur, dan Awardee Beasiswa non-Degree Kemenag-LPDP Program Kepenulisan Turots Ilmiah di Maroko.''',
        }
      ]
    },
    {
      'title': 'Khutbah Bahasa Jawa: Mapag Lailatul Qadar, Wengi Sewu Wulan',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Bulan Ramadhan telah memasuki 10 hari terakhir, sebuah periode yang penuh makna. Meskipun keberadaannya diselimuti misteri, 10 hari terakhir ini diyakini sebagai waktu yang sangat istimewa, yaitu Lailatul Qadar. Malam yang satu ini dipercaya memiliki keutamaan luar biasa, yang setiap ibadah di malam tersebut pahalanya setara dengan 1000 bulan. Lailatul Qadar, yang sering disebut sebagai "malam 10 bulan" menyimpan banyak harapan dan keberkahan. Lalu, apa saja yang perlu kita persiapkan untuk meraih kesempatan emas ini?''',
        },
        {
          'type': 'text',
          'content': '''Teks Khutbah Bahasa Jawa berikut berjudul "Khutbah Bahasa Jawa: Mapag Lailatul Qadar, Wengi Sewu Wulan". Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!''',
        },
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ. اَلْحَمْدُ لِلّٰهِ الَّذِيْ حَمْدًا يُوَافِيْ نِعَمَهُ وَيُكَافِئُ مَزِيْدَهُ، يَا رَبَّنَا لَكَ الْحَمْدُ كَمَا يَنْبَغِيْ لِجَلَالِ وَجْهِكَ وَلِعَظِيْمِ سُلْطَانِكَ، أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ وَصَفِيُّهُ وَخَلِيْلُهُ، خَيْرُ نَبِيٍّ أَرْسَلَهُ اللّٰهُ إِلَى الْعَالَمِ كُلِّهِ بَشِيْرًا وَنَذِيْرًا. اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى  اَلِ سَيِّدِنَا مُحَمَّدٍ صَلَاةً وَسَلَامًا مُتَلَازِمَيْنِ إِلَى يَوْمِ الدِّيْنِ، أَمَّا بَعْدُ''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَا أَيُّهَا الْحَاضِرُوْنَ، اِتَّقُوا اللّٰهَ حَقَّ تُقَاتِهِ وَلَا تَمُوْتُنَّ اِلَّا وَأَنْتُمْ مُسْلِمُوْنَ. قَالَ اللّٰهُ تَعَالَى فِي الْقُرْاٰنِ الْعَظِيْمِ، أَعُوْذُ بِاللّٰهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ، بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ:  إِنَّا أَنْزَلْنَاهُ فِي لَيْلَةِ الْقَدْرِ. وَمَا أَدْرَاكَ مَا لَيْلَةُ الْقَدْرِ. لَيْلَةُ الْقَدْرِ خَيْرٌ مِنْ أَلْفِ شَهْرٍ. تَنَزَّلُ الْمَلَائِكَةُ وَالرُّوحُ فِيهَا بِإِذْنِ رَبِّهِمْ مِنْ كُلِّ أَمْرٍ. سَلَامٌ هِيَ حَتَّى مَطْلَعِ الْفَجْر''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Wonten ing pambuka sidang khutbah ingkang minulya punika, kepareng khatib ngaturaken pepeling kagem kita sedaya. Manggaha kita tansah ningkataken takwa kita, kelawan nindaake perintahe Gusti saha nebihi sedaya awisane. Mugi-mugi kita kalebet golongan ingkang angsal Ridha saking Gusti Allah ta\'ala.''',
        },
        {
          'type': 'arabic',
          'content': '''وَتَزَوَّدُوا فَإِنَّ خَيْرَ الزَّادِ التَّقْوَى وَاتَّقُونِ يَا أُولِي الأَلْبَابِ''',
          'translation': '''Artosipun, "Pada (gawa) sanguha sira kabeh, mangka setuhune luwih bagus-baguse sangu, yaiku takwa marang Allah. Lan padha takwaha sira kabeh ing Ingsun (Allah), hei wong kang padha duweni akal" (Surat Al-Baqarah ayat 197).''',
        },
        {
          'type': 'text',
          'content': '''Jamaah sidang Jumat ingkang minulya''',
        },
        {
          'type': 'text',
          'content': '''Alhamdulillah, mboten keraos sakmenika sampun mlebet ing wulan Ramadhan wekdal 10 dinten kang akhir. Wekdal 10 dinten kang akhir punika, dipun percaya bakal dados wekdal rawuhe lailatul qadar, miturut riwayat hadits saking Siti Aisyah radliyallahu \'anha. Kanjeng Nabi Muhammad saw sampun paring dhawuh:''',
        },
        {
          'type': 'arabic',
          'content': '''تَحرّوْا لَيْلةَ القَدْرِ في الوتْرِ مِنَ العَشْرِ الأَواخِرِ منْ رمَضَانَ''',
          'translation': '''Artosipun, "Sliramu padha ngluru lailatul qadar ing dalem itungan (tanggal) ganjil saking sepuluh kang akhire wulan Ramadhan." (HR Al-Bukhari lan Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Awit saking hadits punika, lajeng para ulama kathah ingkang neliti lajeng mendet ijtihad bilih wancine Lailatul Qadar iku wonten ing 10 akhir wulan Ramadhan. Khususipun ing wanci tanggal kang ganjil. Keterangan punika kasebat ing kitab Fathul Qarib, Hasyiah Al-Bajuri, lan Fathul Mu\'in lajeng I\'anatut Thalibin, bilih Imam As-Syafi\'i paring pangandikan Lailatul Qadar punika ing 10 akhir Ramadhan, langkung-langkung ing tanggal kang ganjil kados dene 21, 23, lan sakpiturute.''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Menawi istilah Lailatul Qadar punika ugi sampun kasebat ing Al-Qur\'an lan wonten salah setunggale surat ingkang dipunasmani Surat Al-Qadr, ingkang nerangaken tumurune Al-Qur\'an nalika wengi kang diarani Lailatul Qadar. Lajeng dipun terangaken babagan Lailatul Qadar, yaiku wengi kang mulya, kang luwih bagus katimbang sewu wulan.''',
        },
        {
          'type': 'arabic',
          'content': '''إِنَّا أَنْزَلْنَاهُ فِي لَيْلَةِ الْقَدْرِ . وَمَا أَدْرَاكَ مَا لَيْلَةُ الْقَدْرِ . لَيْلَةُ الْقَدْرِ خَيْرٌ مِنْ أَلْفِ شَهْرٍ''',
          'translation': '''Artosipun, "Setuhune Ingsun (Allah) iku nurunake Al-Qur\'an ing dalem wengi kang mulya. Utawi apa iku lailatul qadar mungguh keagungane. Lailatul qadar iku luwih bagus katimbang sewu wulan." (Surat Al-Qadr ayat 1-3).''',
        },
        {
          'type': 'text',
          'content': '''Ingkang den maksud, luwih bagus katimbang sewu wulan yaiku amal ana ing wengi lailatul qadar iku luwih bagus katimbang amal sewu wulan ing liyane wengi Lailatul Qadar. Ana ing wanci lailatul qadar Malaikat Jibril ugi para malaikat sanese padha tumurun kanthi izin saking Gusti Allah saperlu padha uluk salam marang wong-wong mukmin ngantos dumugi wekdal mlethèke fajar. (Tafsir Al-Ibriz, juz 30, koco 2250-2251).''',
        },
        {
          'type': 'arabic',
          'content': '''تَنَزَّلُ الْمَلَائِكَةُ وَالرُّوحُ فِيهَا بِإِذْنِ رَبِّهِمْ مِنْ كُلِّ أَمْرٍ. سَلَامٌ هِيَ حَتَّى مَطْلَعِ الْفَجْر''',
          'translation': '''Artosipun, "Padha tumurun para malaikat lan Malaikat Jibril ing dalem lalatul qadar kelawan izine saking Pengeran, saking saben-saben perkara. Iku padha uluk salam (para malaikat) hingga mlethèke fajar." (Surat Al-Qadr ayat 4-5).''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Pramila, begja kemayangan menawi kita saget kepanggih kalian wengi kang mulya ing wulan Ramadhan, inggih punika lailatul qadar. Mangga kita ndherek mapag lailatul qadar punika kanthi sregep ing ibadah, langkung-langkung ing sepuluh dinten akhir ing wulan Ramadhan.''',
        },
        {
          'type': 'text',
          'content': '''Kanjeng Nabi Muhammad saw kemawon, menawi nalika sampun mlebet sepuluh dinten akhir ing wulan Ramadhan, piyambake tambah kenceng ing dalem ibadah lan nyerak marang Gusti Allah Swt.''',
        },
        {
          'type': 'arabic',
          'content': '''​​​​​كَانَ رَسُوْلُ اللهِ يَجْتَهِدُ فِيْ العَشْرِ الأَوَاخِرِ مَالاَ يَجْتَهِدُ فِيْ غَيْرِهِ''',
          'translation': '''Artosipun, "Kanjeng Rasulullah saw iku (langkung) temenan ing dalem wanci sepuluh (dinten) akhir ing wulan Ramadhan. Kang mboten den lampahi (Kanjeng Nabi) ing wanci sanese." (HR Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Kajaba tambah sregep ing ibadah, ingkang saget kita lampahi kanthi nglampahi shalat sunnah, maos Al-Qur\'an, shalawat, dzikir, lan kesahenan sanesipun, ugi saget kita ngathahaken maos doa nalika sampun mlebet wancine utawi kepanggih kalian lailatul qadar. Doa ingkang dipun riwayataken saking Siti Aisyah saking Kanjeng Nabi Muhammad saw.''',
        },
        {
          'type': 'arabic',
          'content': '''اَللَّهُمَّ إِنَّكَ عَفُوٌّ كَرِيمٌ  تُحِبُّ اَلْعَفْوَ فَاعْفُ عَنِّي''',
          'translation': '''Artosipun, "Ya Allah, setuhune Panjenengan iku Dzat kang Maha Pangapura lan remen marang wong kang nyuwun pangapura. Mangka mugi Panjenengan paring pangapura dhatêng kula." (HR At-Tirmidzi).''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Kangge mungkasi khutbah punika, mangga kita tansah dedunga mugi kita sedaya lan keluarga kita, saget kepanggih lan angsal keberkahan lan ganjaran saking Lailatul Qadar. Mugi kita ugi saget nglampahi ibadah ing wulan Ramadhan kanthi iman kang jejeg, awak kang sehat wal afiat, saha raos bungah lan istiqamah. Amin ya Rabbal \'alamin.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللّٰهُ لِيْ وَلَكُمْ فِيْ الْقُرْآنِ الْكَرِيْمِ، وَنَفَعَنِيْ وَإِيَّاكُمْ بِمَا فِيْهِ مِنَ الذِّكْرِ الْحَكِيْمِ، وَتَقَبَّلَ مِنِّيْ وَمِنْكُمْ تِلَاوَتَهُ إِنَّهُ هُوَ الْغَفُوْرُ الرَّحِيْمُ، فَاعْتَبِرُوْا يَآ أُوْلِى اْلأَلْبَابِ لَعَلَّكُمْ تُفْلِحُوْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ الَّذِي هَدَانَا لِهَذَا وَمَا كُنَّا لِنَهْتَدِيَ لَوْلَا أَنْ هَدَانَا اللّٰهُ. أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنْ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ لَا نَبِيَّ بَعْدَهُ. اَللّٰهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ المُجَاهِدِيْنَ الطَّاهِرِيْنَ.  أَمَّا بَعْدُ''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَا آيُّهَا الحَاضِرُوْنَ، أُوْصِيْكُمْ وَإِيَّايَ بِتَقْوَى اللّٰهِ وَطَاعَتِهِ لَعَلَّكُمْ تُفْلِحُوْنَ. يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ وَلَا تَمُوتُنَّ إِلَّا وَأَنْتُمْ مُسْلِمُونَ، وَتَزَوَّدُوا فَإِنَّ خَيْرَ الزَّادِ التَّقْوَى. فَقَدْ قَالَ اللّٰهُ تَعَالَى فِي كِتَابِهِ الْكَرِيْمِ أَعُوْذُ بِاللّٰهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ، بِسْمِ اللّٰهِ الرَّحْمَنِ الرَّحِيْمِ: وَالْعَصْرِ. إِنَّ الْإِنْسَانَ لَفِي خُسْرٍ. إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْر''',
        },
        {
          'type': 'arabic',
          'content': '''إِنَّ اللَّهَ وَمَلَائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيمًا. اللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى سَيِّدِنَا إِبْرَاهِيمَ وَعَلَى آلِ سَيِّدِنَا إِبْرَاهِيمَ، وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى سَيِّدِنَا إِبْرَاهِيمَ وَعَلَى آلِ سَيِّدِنَا إِبْرَاهِيمَ، فِى الْعَالَمِينَ إِنَّكَ حَمِيدٌ مَجِيدٌ   اَللّٰهُمَّ اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ. اَللّٰهُمَّ ادْفَعْ عَنَّا الْغَلَاءَ وَالْوَبَاءَ وَالطَّاعُوْنَ وَالْاَمْرَاضَ وَالْفِتَنَ مَا لَا يَدْفَعُهُ غَيْرُكَ عَنْ بَلَدِنَا هٰذَا اِنْدُوْنِيْسِيَّا خَاصَّةً وَعَنْ سَائِرِ بِلَادِ الْمُسْلِمِيْنَ عَامَّةً يَا رَبَّ الْعَالَمِيْنَ. رَبَّنَا اٰتِنَا فِي الدُّنْيَا حَسَنَةً وَ فِي الْاٰخِرَةِ حَسَنَةً وَ قِنَا عَذَابَ النَّارِ

عٍبَادَ اللّٰهِ، إِنَّ اللّٰهَ يَأْمُرُ بِاْلعَدْلِ وَاْلإِحْسَانِ وَإِيْتاءِ ذِي اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشاءِ وَاْلمُنْكَرِ وَاْلبَغْيِ يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ، وَاذْكُرُوا اللّٰهَ اْلعَظِيْمَ يَذْكُرْكُمْ، وَاشْكُرُوْهُ عَلىَ نِعَمِهِ يَزِدْكُمْ، وَلَذِكْرُ اللّٰهِ أَكْبَرْ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Ajie Najmuddin, Pengurus MWCNU Banyudono Boyolali''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat Bahasa Jawa: Nggayuh Rahmate Gusti ing Wulan Ramadhan Suci',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Dikatakan, keutamaan dalam bulan Ramadhan dibagi menjadi tiga. Pertama, yakni pada awal bulan rahmat, pertengahannya ampunan, dan di akhir terbebas dari neraka. Maka di awal bulan Ramadhan ini, mari kita senantiasa berupaya agar kita mendapat rahmat dari Allah swt.''',
        },
        {
          'type': 'text',
          'content': '''Materi khutbah Jumat berikut ini dengan judul: "Khutbah Jumat Bahasa Jawa: Nggayuh Rahmate Gusti ing Wulan Ramadhan Suci." Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat.''',
        },
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ الَّذِيْ جَعَلَ شَهْرَ رَمَضَانَ غُرَّةَ وَجْهِ الْعَامِ. وَشَرَّفَ أَوْقَاتَهُ عَلَى سَائِرِالأَوْقَاتِ، وَفَضَّلَ أَيَّامَهُ عَلَى سَائِرِ الْأَيَّامِ، أَشْهَدُ أَنْ لاَ إِلٰهَ إِلاَّ اللّٰهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ، شهادَةَ مَنْ قَالَ رَبِّيَ اللّٰهُ ثُمَّ اسْتَقَامَ، وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ، أَفْضَلُ مَنْ صَلَّى وَصَامَ. اللّٰهُمَّ صَلِّ وسَلِّمْ علَى عَبْدِكَ وَرَسُوْلِكَ مُحَمّدٍ وعَلٓى آلِهِ وأَصْحَابِهِ هُدَاةِ الأَنَامِ وَمَصَابِيْحِ الظُّلاَمِ. أَمَّا بَعْدُ، فَيَا أَيُّهَا النَّاسُ اتَّقُوا اللّٰهَ تَعَالَى بِفِعْلِ الطَّاعَاتِ وَتَرْكِ الْأَثَامِ. فَقَالَ اللّٰهُ تَعَالٰى فِيْ كِتَابِهِ الْكَرِيْمِ: أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ، بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ يَاۤ أَيُّهَا الَّذِيْنَ آمَنُواْ كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَ''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat ingkang minulya,''',
        },
        {
          'type': 'text',
          'content': '''Wonten ing pambuka sidang khutbah ingkang minulya punika, kepareng khatib ngaturaken pepeling kagem kita sedaya. Manggaha kita tansah ningkataken takwa kita, kelawan nindaake perintahe Gusti saha nebihi sedaya awisane. Mugi-mugi kita kalebet golongan ingkang angsal ridha saking Gusti Allah ta\'ala.''',
        },
        {
          'type': 'arabic',
          'content': '''وَتَزَوَّدُوا فَإِنَّ خَيْرَ الزَّادِ التَّقْوَى وَاتَّقُونِ يَا أُولِي الأَلْبَابِ''',
          'translation': '''Artosipun: "Pada (gawa) sanguha sira kabeh, mangka setuhune luwih bagus-baguse sangu, yaiku takwa marang Allah. Lan padha takwaha sira kabeh ing Ingsun (Allah), hei wong kang padha duweni akal," (QS. Al Baqarah: 197)''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Wonten salah satunggale keterangan, kaitanipun kalian kautamaan ing wulan Ramadhan. Bilih wulan Pasa menika dibagi ing tiga kautamaan. Ing awal wulan, Gusti Allah nurunke rahmat, lajeng ing pertengahan maringi pangapura, lan ing akhir wulan dipun bebasake saking neraka.''',
        },
        {
          'type': 'text',
          'content': '''Pramila, ing kesempatan awal Ramadhan menika, mangga kita sami berupaya, supados kita angsal kautamaan angsal rahmatipun Gusti Allah swt. Bilih rahmat utawi welas asihipun Gusti menika jembar sanget.''',
        },
        {
          'type': 'text',
          'content': '''Contonipun saking penjelasan sifat welas asihe Gusti Allah inggih punika Ar-Rahman lan Ar-Rahim. Wonten ing tafsir Al Ibriz dipun terangake ana ing surat Al-Fatihah ayat 3, bilih Gusti Allah iku persifatan welas asih maring sekabehane makhluk, luwih-luwih marang menungsa kang wis nyata diparingi nikmat wujud kanthi akal lan anggota badan kang sampurna lan nikmat liya-liyane meneh kang gedhe lan lembut.''',
        },
        {
          'type': 'arabic',
          'content': '''الرَّحْمٰنِ الرَّحِيْمِۙ''',
          'translation': '''Artosipun: "Kang Maha Welas ana ing (dunya lan akhirat) tur Maha Asih (ana ing akhirat blaka)," (QS Al-Fatihah: 3)''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Rahmat saking Gusti Allah menika, dados pengarep-arep sedaya makhluke. Supados angsal gesang ingkang sahe. Langkung-langkung, benjang ten akhirat, mestinipun kepengin mlebet swargane Gusti Allah.''',
        },
        {
          'type': 'text',
          'content': '''Kanjeng Nabi nate ngendikan ugi paring tuladha datheng kita umatipun, bilih piyambakipun mawon saget mlebet swarga, mboten kerana amale, nanging sebab rahmat lan fadhilah saking Gusti Allah.''',
        },
        {
          'type': 'arabic',
          'content': '''لَنْ يُدْخِلَ أَحَداً عَمَلُهُ الْجَنَّةَ ...  قَالُوا وَلاَ أَنْتَ يَا رَسُولَ اللَّهِ؟ قَالَ لاَ وَلاَ أَنَا إِلاَّ أَنْ يَتَغَمَّدَنِي اللَّهُ بِفَضْلٍ وَرَحْمَةٍ''',
          'translation': '''Artosipun: "Ora bakal mlebu ing suwarga sapa wong, sebab amale... lajeng para sahabat wonten ingkang tanglet:  termasuk panjenengan Ya Rasulullah? Lajeng Kanjeng Nabi ngendikan: Ya, aku iya ora (mlebet suwarga sebab amal), kajaba namung sebab rahmat lan fadhilah saking Gusti," (HR Bukhari Muslim)''',
        },
        {
          'type': 'text',
          'content': '''Wonten ing hadist menika, mboten kok nglarang kita ngamal, ananging wonten ing kelanjutan hadits menika, Kanjeng Nabi ugi maringi tambahan keterangan, supados kita mendet ing dalan tengah utawi ingkang seimbang antarane kita ngamal kalian kita gadah pengarep-arep dhateng rahmate Gusti.''',
        },
        {
          'type': 'text',
          'content': '''Ugi supaya kita, ati-ati ing dalem tingkah kita, sebab mboten wonten ingkang mangertos perkawis ingkang saget dados sebab tumurune rahmate Gusti. Ugi ingkang paling penting, supados kita mboten pedhot pengarep-arep marang rahmate Gusti.''',
        },
        {
          'type': 'arabic',
          'content': '''وَمَن يَقْنَطُ مِن رَّحْمَةِ رَبِّهِ إِلاَّ الضَّآلُّونَ''',
          'translation': '''Artosipun: "Mboten wonten tiyang ingkang putus harapan, saking rahmatipun Pengeran, kejawi namung tiyang-tiyang ingkang sasar," (Al-Hijr: 56)''',
        },
        {
          'type': 'text',
          'content': '''Para jamaah ingkang minulya,''',
        },
        {
          'type': 'text',
          'content': '''Pramila, wulan Ramadhan menika wekdal ingkang pas, kangge kita ningkatake amal sahe kita. Nglampahi ibadah pasa, shalat tarawih lan sunah sanese, maos Al-Qur\'an, sedekah lan liya-liyane. Sinambi kita tansah gadah pengarep-arep, mugi-mugi Gusti Allah nurunake rahmate maring kita sedaya. Amin ya Rabbal Alamin.''',
        },
        {
          'type': 'arabic',
          'content': '''أَعُوذُ بِاللهِ مِن الشَّيْطانِ الرَّجِيْمِ. بِسْمِ اللهِ الرَّحمن الرّحيم. يَا أَيُّهَا الَّذِينَ آمَنُواْ كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِن قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ أَيَّامًا مَّعْدُودَاتٍ فَمَن كَانَ مِنكُم مَّرِيضًا أَوْ عَلَى سَفَرٍ فَعِدَّةٌ مِّنْ أَيَّامٍ أُخَرَ وَعَلَى الَّذِينَ يُطِيقُونَهُ فِدْيَةٌ طَعَامُ مِسْكِينٍ فَمَن تَطَوَّعَ خَيْرًا فَهُوَ خَيْرٌ لَّهُ وَأَن تَصُومُواْ خَيْرٌ لَّكُمْ إِن كُنتُمْ تَعْلَمُونَ

 باَرَكَ اللهُ لِيْ وَلكمْ فِي القُرْآنِ العَظِيْمِ, وَنَفَعَنِيْ وَإِيّاكُمْ بِالآياتِ والذِّكْرِ الحَكِيْمِ. إنّهُ تَعَالَى جَوّادٌ كَرِيْمٌ مَلِكٌ بَرٌّ رَؤُوْفٌ رَحِيْمٌ''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ للهِ عَلىَ اِحْسَانِهِ وَالشُّكْرُ لَهُ عَلىَ تَوْفِيْقِهِ وَامْتِنَانِهِ. اَشْهَدُ اَنْ لاَ اِلَهَ اِلاَّ اللهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ وَاَشْهَدُ اَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ الدَّاعِي اِلىَ رِضْوَانِهِ. اللهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وِعَلَى اَلِهِ وَاَصْحَابِهِ وَسَلِّمْ تَسْلِيْمًا كِثيْرًا   اَمَّا بَعْدُ فَياَ اَيُّهَا النَّاسُ، اِتَّقُوااللهَ فِيْمَا اَمَرَ وَانْتَهُوْا عَمَّا نَهَى. وَاعْلَمُوْا اَنَّ اللّٰهَ اَمَرَكُمْ بِاَمْرٍ بَدَأَ فِيْهِ بِنَفْسِهِ وَثَـنَى بِمَلآ ئِكَتِهِ بِقُدْسِهِ وَقَالَ تَعاَلَى اِنَّ اللهَ وَمَلآ ئِكَتَهُ يُصَلُّوْنَ عَلىَ النَّبِى يآ اَيُّهَا الَّذِيْنَ آمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا. اللهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلِّمْ وَعَلَى آلِ سَيِّدِناَ مُحَمَّدٍ وَعَلَى اَنْبِيآئِكَ وَرُسُلِكَ وَمَلآئِكَةِ اْلمُقَرَّبِيْنَ، وَارْضَ اللّٰهُمَّ عَنِ اْلخُلَفَاءِ الرَّاشِدِيْنَ اَبِى بَكْرٍ وَعُمَر وَعُثْمَان وَعَلِى وَعَنْ بَقِيَّةِ الصَّحَابَةِ وَالتَّابِعِيْنَ وَتَابِعِي التَّابِعِيْنَ لَهُمْ بِاِحْسَانٍ اِلَى يَوْمِ الدِّيْنِ، وَارْضَ عَنَّا مَعَهُمْ بِرَحْمَتِكَ يَا اَرْحَمَ الرَّاحِمِيْنَ.''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَاْلمُؤْمِنَاتِ وَاْلمُسْلِمِيْنَ وَاْلمُسْلِمَاتِ اَلْاَحْيآءِ مِنْهُمْ وَاْلاَمْوَاتِ. اللهُمَّ اَعِزَّ اْلاِسْلاَمَ وَاْلمُسْلِمِيْنَ وَأَذِلَّ الشِّرْكَ وَاْلمُشْرِكِيْنَ وَانْصُرْ عِبَادَكَ اْلمُوَحِّدِيَّةَ وَانْصُرْ مَنْ نَصَرَ الدِّيْنَ وَاخْذُلْ مَنْ خَذَلَ اْلمُسْلِمِيْنَ وَدَمِّرْ اَعْدَاءَ الدِّيْنِ وَأَعْلِ كَلِمَاتِكَ اِلَى يَوْمَ الدِّيْنِ. اللهُمَّ ادْفَعْ عَنَّا اْلبَلاَءَ وَاْلوَبَاءَ وَالزَّلاَزِلَ وَاْلمِحَنَ وَسُوْءَ اْلفِتْنَةِ وَاْلمِحَنَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا اِنْدُونِيْسِيَّا خآصَّةً وَسَائِرِبُلْدَانِ اْلمُسْلِمِيْنَ عآمَّةً يَا رَبَّ اْلعَالَمِيْنَ. رَبَّنَا آتِناَ فِى الدُّنْيَا حَسَنَةً وَفِى اْلآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ. رَبَّنَا ظَلَمْنَا اَنْفُسَنَاوَاِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُوْنَنَّ مِنَ اْلخَاسِرِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ، اِنَّ اللهَ يَأْمُرُبِاْلعَدْلِ وَاْلاِحْسَانِ وَإِيْتآءِ ذِى اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشآءِ وَاْلمُنْكَرِ وَاْلبَغْي يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ وَاذْكُرُوااللهَ اْلعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلىَ نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللهِ اَكْبَرْ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Ajie Najmuddin, Sekretaris MWCNU Banyudono Boyolali''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Menjaga Kualitas Puasa di Bulan Ramadhan',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Khutbah Jumat ini mengajak jamaah untuk menjaga dan meningkatkan kualitas puasa di bulan Ramadhan, tidak hanya dengan menjaga perut dari makan dan minum tapi juga menjaga telinga, mata, lisan, tangan, kaki, dan segenap anggota badan dari berbuat dosa.''',
        },
        {
          'type': 'text',
          'content': '''Khutbah Jumat ini berjudul: "Khutbah Jumat: Menjaga Kualitas Puasa di Bulan Ramadhan". Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat! (Redaksi).''',
        },
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''اْلحَمْدُ ِللهِ اْلحَمْدُ ِللهِ الَّذِي هَدَانَا سُبُلَ السّلاَمِ، وَأَفْهَمَنَا بِشَرِيْعَةِ النَّبِيّ الكَريمِ، أَشْهَدُ أَنْ لَا اِلٰهَ إِلَّا الله وَحْدَهُ لا شَرِيكَ لَه، ذُو اْلجَلَالِ وَالإكْرَام، وَأَشْهَدُ أَنَّ سَيِّدَنَا وَنَبِيَّنَا مُحَمَّدًا عَبْدُهُ وَ رَسُوْلُه، اَللّٰهُمَّ صَلِّ و سَلِّمْ وَبارِكْ عَلَى سَيِّدِنَا مُحَمّدٍ وَعَلَى اٰلِهِ وَأصْحَابِهِ وَالتَّابِعِيْنَ بِإحْسَانٍ إلَى يَوْمِ الدِّيْن، أَمَّا بَعْدُ: فَيَايُّهَا الإِخْوَان، أوْصِيْكُمْ وَ نَفْسِيْ بِتَقْوَى اللهِ وَطَاعَتِهِ لَعَلَّكُمْ تُفْلِحُوْنْ، قَالَ اللهُ تَعَالىَ فِي اْلقُرْانِ اْلكَرِيمْ: أَعُوْذُ بِاللهِ مِنَ الَّشَيْطَانِ الرَّجِيْم، بِسْمِ اللهِ الرَّحْمَانِ الرَّحِيْمْ: يَا أَيُّهَا الَّذِينَ آَمَنُوا اتَّقُوا الله وَقُولُوا قَوْلًا سَدِيْدًا، يُصْلِحْ لَكُمْ أَعْمَالَكُمْ وَيَغْفِرْ لَكُمْ ذُنُوبَكُمْ وَمَنْ يُطِعِ الله وَرَسُولَهُ فَقَدْ فَازَ فَوْزًا عَظِيمًا وَقَالَ تَعَالى يَا اَيُّهَا الَّذِيْنَ آمَنُوْا اتَّقُوْا اللهَ حَقَّ تُقَاتِهِ وَلاَ تَمُوْتُنَّ إِلاَّ وَأَنْتُمْ مُسْلِمُوْنَ. صَدَقَ اللهُ العَظِيمْ''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat rahimakumullah.
Alhamdulillah pada hari ini kita berada di bulan yang penuh rahmat, anugerah, dan ampunan Allah, yaitu bulan suci Ramadhan. Pada bulan ini kita diwajibkan oleh Allah SWT untuk menjalankan ibadah puasa, yaitu menahan diri dari makan, minum, dan hal yang membatalkannya mulai terbitnya fajar hingga tenggelamnya Matahari dengan niat yang telah ditentukan.''',
        },
        {
          'type': 'text',
          'content': '''Tujuan utama dari berpuasa adalah menjadi manusia yang bertaqwa kepada Allah SWT. Sebagaimana firman Allah SWT dalam surat Al-Baqarah: 183:''',
        },
        {
          'type': 'arabic',
          'content': '''يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ ‌لَعَلَّكُمْ ‌تَتَّقُونَ (البقرة:183)''',
          'translation': '''Artinya: "Hai orang-orang yang beriman, diwajibkan atas kalian berpuasa sebagaimana diwajibkan atas orang-orang sebelum kalian agar kalian bertakwa."''',
        },
        {
          'type': 'text',
          'content': '''Manusia yang bertakwa merupakan harapan utama yang diperoleh seseorang setelah menjalankan ibadah puasa, maka Nabi memerintahkan bagi orang yang berpuasa untuk menghindari ucapan kotor dan tindakan yang bodoh, sebagaimana sabda Nabi yang diriwayatkan oleh Imam Malik dalam Kitab Al-Muwatha\'. Nabi bersabda:''',
        },
        {
          'type': 'arabic',
          'content': '''الصِّيَامُ جُنَّةٌ، فَإِذَا كَانَ أَحَدُكُمْ صَائِمًا: فَلَا يَرْفُثْ، وَلَا يَجْهَلْ، فَإِنِ امْرُؤٌ قَاتَلَهُ، أَوْ شَاتَمَهُ، فَلْيَقُلْ: إِنِّي صَائِمٌ، إِنِّي صَائِمٌ''',
          'translation': '''Artinya: "Puasa itu adalah perisai, jika salah satu dari kalian sedang berpuasa, maka jangan sampai berkata kotor dan jangan pula bertingkah laku jahil (sombong, suka mengejek, atau bertengkar). Jika ada orang lain yang mengajaknya berkelahi atau menghinanya maka hendaklah dia mengatakan: aku sedang puasa, aku sedang puasa" (HR. Imam Malik).''',
        },
        {
          'type': 'text',
          'content': '''Hadis di atas menjelaskan bahwa seseorang yang berpuasa diperintahkan Nabi untuk tidak mengucapkan kalimat yang kotor dan bertindak bodoh, bahkan jika ada seseorang yang mengajak berkelahi atau memusuhi, ia cukup mengucapkan saya sedang berpuasa. Hal ini bertujuan untuk menjaga kesempurnaan pahala puasa, terutama menjaga ketakwaannya kepada Allah SWT.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Bagaimana cara agar puasa kita memiliki kualitas yang baik? Imam Al-Ghazali dalam kitabnya Ihya Ulumuddin Juz 1 halaman 234 menjelaskan tentang kualitas puasanya orang-orang saleh, orang-orang yang berada pada tingkatan khusus, yaitu puasa dengan menjaga telinga, mata, lisan, tangan, kaki, dan segenap anggota badan dari dosa. Puasa ini dapat dicapai dengan enam hal:''',
        },
        {
          'type': 'text',
          'content': '''Pertama, menjaga mata dari memandang hal yang tercela, serta tidak memandang hal yang melalaikan hati dari dzikir kepada Allah. Bulan puasa menjadi momentum yang baik untuk menyibukkan pandangan kita dengan membaca Al-Qur\'an, mengaji kitab kuning, dan mempelajari ilmu pengetahuan. Agar puasa kita berkah dan berkualitas sebagaimana puasanya orang-orang yang saleh.''',
        },
        {
          'type': 'text',
          'content': '''Kedua, menjaga lisan dari ujaran kebohongan, menggunjing, memaki, menghina dan segala bentuk permusuhan. Bulan puasa merupakan momentum untuk membiasakan diri dengan berdzikir kepada Allah, membaca Qur\'an, dan lebih baik diam daripada mengucapkan yang tidak baik, hal ini merupakan bentuk dari puasa lisan. Imam Sufyan mengingatkan bahwa menggunjing dapat merusak terhadap pahala puasa.''',
        },
        {
          'type': 'text',
          'content': '''Ketiga, menjaga telinga dari mendengarkan hal yang diharamkan Allah. Sesuatu yang haram diucapkan, maka haram juga untuk didengarkan. Mumpung ini puasa, mari kita gunakan telinga kita untuk mendengarkan hal yang bermanfaat, seperti mendengarkan lantunan Al-Qur\'an, pengajian, maupun nasehat keagamaan. Agar puasa kita berkah dan mendapatkan pahala yang sempurna dari Allah SWT.''',
        },
        {
          'type': 'text',
          'content': '''Keempat, menjaga segenap anggota badan, mulai dari tangan, kaki, dan anggota tubuh lainnya dari melakukan hal-hal yang dilarang syariat agama, mari kita gunakan anggota badan kita untuk pergi ke masjid, musholla, madrasah, agar anggota tubuh kita terhindar perbuatan yang tercela.''',
        },
        {
          'type': 'text',
          'content': '''Kelima, tidak makan berlebihan ketika berbuka puasa, karena Allah membenci terhadap perut yang berisi makanan halal secara berlebihan. Makan berlebihan kontradiktif dengan tujuan puasa, yaitu melemahkan godaan syaitan dan hawa nafsu, tujuan ini tidak dapat terwujud tanpa mengurangi porsi makan.''',
        },
        {
          'type': 'text',
          'content': '''Keenam, ketika berbuka puasa, sebaiknya perasaan hati memuat dua hal, yaitu takut terhadap siksa Allah dan selalu mengharapkan rahmat-Nya. Harapannya agar seseorang selalu menjaga semangat ibadahnya, dan selalu istiqomah beribadah kepada Allah sehingga ia menjadi orang yang beruntung, orang yang bertaqwa kepada Allah SWT.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat rahimakumullah''',
        },
        {
          'type': 'text',
          'content': '''Mengapa penting untuk menjaga kualitas berpuasa? Karena manusia yang cerdas adalah manusia yang dapat menundukkan hawa nafsunya dan beramal untuk kehidupan setelah kematian. Sebagaimana hadis yang diriwayatkan oleh Imam Hakim dalam kitabnya Mustadrok \'ala Shahihain, juz 1, hlm 125:''',
        },
        {
          'type': 'arabic',
          'content': '''‌الْكَيِّسُ ‌مَنْ ‌دَانَ ‌نَفْسَهُ ‌وَعَمِلَ ‌لِمَا ‌بَعْدَ ‌الْمَوْتِ، وَالْعَاجِزُ مَنْ أَتْبَعَ نَفْسَهُ هَوَاهَا، وَتَمَنَّى عَلَى اللَّهِ''',
          'translation': '''Artinya: "Orang yang cerdas adalah yang menundukkan nafsunya dan beramal untuk kehidupan setelah kematian, sedangkan orang yang lemah adalah yang mengikuti hawa nafsunya tapi banyak berangan-angan atas (karunia) Allah." (HR. Hakim).''',
        },
        {
          'type': 'text',
          'content': '''Selain itu, Imam Al Ghazali dalam kitab Ihya\' Ulumuddin juz 1 halaman 236 menjelaskan bahwa derajat manusia itu di bawah malaikat dan di atas binatang. Ketika manusia terlena dengan syahwatnya, ia turun kasta menyusul kelompok binatang. Sebaliknya ketika manusia mampu menahan syahwatnya, menjaga kualitas puasanya, ia naik di atas derajat tertinggi menyusul wilayah para malaikat.''',
        },
        {
          'type': 'text',
          'content': '''Oleh karena itu, bulan puasa ini merupakan momentum terbaik bagi kita semua untuk menjaga kualitas puasa dengan berperilaku seperti malaikat dengan memperbanyak amal kebaikan dan dapat menahan diri dari hawa nafsu yang tercela. Semoga puasa kita diterima Allah SWT. Aamiin.''',
        },
        {
          'type': 'arabic',
          'content': '''جَعَلَنا اللهُ وَإيَّاكم مِنَ الفَائِزِين الآمِنِين، وَأدْخَلَنَا وإِيَّاكم فِي زُمْرَةِ عِبَادِهِ المُؤْمِنِيْنَ : أعُوذُ بِاللهِ مِنَ الشَّيْطانِ الرَّجِيمْ، بِسْمِ اللهِ الرَّحْمانِ الرَّحِيمْ: يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ وَقُولُوا قَوْلًا سَدِيدًا''',
        },
        {
          'type': 'arabic',
          'content': '''باَرَكَ اللهُ لِيْ وَلكمْ فِي القُرْآنِ العَظِيْمِ، وَنَفَعَنِيْ وَإِيّاكُمْ بِالآياتِ وذِكْرِ الحَكِيْمِ.  إنّهُ تَعاَلَى جَوّادٌ كَرِيْمٌ مَلِكٌ بَرٌّ رَؤُوْفٌ رَحِيْمٌ''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ للهِ عَلىَ إِحْسَانِهِ وَالشُّكْرُ لَهُ عَلىَ تَوْفِيْقِهِ وَاِمْتِنَانِهِ. وَأَشْهَدُ أَنْ لاَ اِلَهَ إِلاَّ اللهُ وَاللهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ وَأَشْهَدُ أنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ الدَّاعِى إلىَ رِضْوَانِهِ. اللهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وِعَلَى اَلِهِ وَأَصْحَابِهِ وَسَلِّمْ تَسْلِيْمًا كِثيْرًا''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ فَياَ اَيُّهَا النَّاسُ اِتَّقُوااللهَ فِيْمَا أَمَرَ وَانْتَهُوْا عَمَّا نَهَى وَاعْلَمُوْا أَنَّ اللهَ أَمَرَكُمْ بِأَمْرٍ بَدَأَ فِيْهِ بِنَفْسِهِ وَثَـنَى بِمَلآ ئِكَتِهِ بِقُدْسِهِ وَقَالَ تَعاَلَى إِنَّ اللهَ وَمَلآئِكَتَهُ يُصَلُّوْنَ عَلىَ النَّبِى يآ اَيُّهَا الَّذِيْنَ آمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا. اللهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلِّمْ وَعَلَى آلِ سَيِّدِناَ مُحَمَّدٍ وَعَلَى اَنْبِيآئِكَ وَرُسُلِكَ وَمَلآئِكَةِ اْلمُقَرَّبِيْنَ وَارْضَ اللّهُمَّ عَنِ اْلخُلَفَاءِ الرَّاشِدِيْنَ أَبِى بَكْرٍ وَعُمَر وَعُثْمَان وَعَلِى وَعَنْ بَقِيَّةِ الصَّحَابَةِ وَالتَّابِعِيْنَ وَتَابِعِي التَّابِعِيْنَ لَهُمْ بِاِحْسَانٍ اِلَىيَوْمِ الدِّيْنِ وَارْضَ عَنَّا مَعَهُمْ بِرَحْمَتِكَ يَا أَرْحَمَ الرَّاحِمِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَاْلمُؤْمِنَاتِ وَاْلمُسْلِمِيْنَ وَاْلمُسْلِمَاتِ اَلاَحْيآءُ مِنْهُمْ وَاْلاَمْوَاتِ اللهُمَّ أَعِزَّ اْلإِسْلاَمَ وَاْلمُسْلِمِيْنَ وَأَذِلَّ الشِّرْكَ وَاْلمُشْرِكِيْنَ وَانْصُرْ عِبَادَكَ اْلمُوَحِّدِيَّةَ وَانْصُرْ مَنْ نَصَرَ الدِّيْنَ وَاخْذُلْ مَنْ خَذَلَ اْلمُسْلِمِيْنَ وَ دَمِّرْ أَعْدَاءَ الدِّيْنِ وَاعْلِ كَلِمَاتِكَ إِلَى يَوْمَ الدِّيْنِ. اللهُمَّ ادْفَعْ عَنَّا اْلبَلاَءَ وَاْلوَبَاءَ وَالزَّلاَزِلَ وَاْلمِحَنَ وَسُوْءَ اْلفِتْنَةِ وَاْلمِحَنَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا اِنْدُونِيْسِيَّا خآصَّةً وَسَائِرِ اْلبُلْدَانِ اْلمُسْلِمِيْنَ عآمَّةً يَا رَبَّ اْلعَالَمِيْنَ. رَبَّنَا آتِناَ فِى الدُّنْيَا حَسَنَةً وَفِى اْلآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ. رَبَّنَا ظَلَمْنَا اَنْفُسَنَا وَاإنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُوْنَنَّ مِنَ اْلخَاسِرِيْنَ. عِبَادَاللهِ ! إِنَّ اللهَ يَأْمُرُنَا بِاْلعَدْلِ وَاْلإِحْسَانِ وَإِيْتآءِ ذِي اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشآءِ وَاْلمُنْكَرِ وَاْلبَغْي يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ وَاذْكُرُوا اللهَ اْلعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلىَ نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللهِ أَكْبَرْ''',
        },
        {
          'type': 'text',
          'content': '''Dr. Rustam Ibrahim, Dosen UIN Raden Mas Said Surakarta.''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Ramadhan Momentum Tumbuhkan Jiwa Kepedulian',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Bulan Ramadhan merupakan bulan penuh berkah dan ampunan yang dinanti-nanti oleh umat Islam di seluruh dunia. Di bulan ini, umat Islam diwajibkan untuk berpuasa dari terbit hingga terbenam matahari. Selain itu, Ramadhan juga menjadi momen untuk meningkatkan rasa peduli dan kedermawanan terhadap sesama.''',
        },
        {
          'type': 'text',
          'content': '''Naskah Khutbah Jumat ini berjudul: "Khutbah Jumat: Ramadhan Momentum Tumbuhkan Jiwa Kepedulian dan Kedermawanan". Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat! (Redaksi)''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ للهِ. اَلْحَمْدُ للهِ الَّذِيْ يَحْشُرُنَا فِي الْمَحْشَرِ. أَشْهَدُ اَنْ لَا اِلٰهَ اِلَّا اللهُ الْمَلِكُ الْجَبَّارُ وَأَشْهَدُ اَنَّ حَبِيْبَنَا وَ نَبِيَّنّا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ سَيِّدُ الْاِنْسِ وَالْبَشَرِ. اَللّٰهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلٰى سَيِّدِنَا مُحَمَّدٍ وَعَلٰى اٰلِهِ وَاَصْحَابِهِ اَجْمَعِيْنَ اَمَّا بَعْدُ''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَا أَيُّهَا الْحَاضِرُوْنَ. اِتَّقُوا اللهَ حَقَّ تُقَاتِهِ وَلَا تَمُوْتُنَّ اِلَّا وَأَنْتُمْ مُسْلِمُوْنَ. قَالَ اللهُ تَعَالَى فِي الْقُرْاٰنِ الْعَظِيْمِ. أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ، بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ: وَالْعَصْرِۙ اِنَّ الْاِنْسَانَ لَفِيْ خُسْرٍۙ اِلَّا الَّذِيْنَ اٰمَنُوْا وَعَمِلُوا الصّٰلِحٰتِ وَتَوَاصَوْا بِالْحَقِّ ەۙ وَتَوَاصَوْا بِالصَّبْرِ''',
        },
        {
          'type': 'text',
          'content': '''Hadirin sidang Jumat yang berbahagia''',
        },
        {
          'type': 'text',
          'content': '''Di awal khutbah siang Ramadhan ini mari kita tingkatkan kesadaran untuk meneguhkan ketakwaan kepada Alllah subhanahu wata\'ala.''',
        },
        {
          'type': 'text',
          'content': '''Puasa selama sebulan penuh merupakan salah satu dari rukun Islam yang wajib dijalankan oleh umat Muslim yang baligh dan mampu untuk melaksanakan puasa Ramadhan. Ibadah puasa ini dilaksanakan pada bulan suci Ramadan, yang penuh dengan keberkahan dan ampunan. Menjalankan ibadah puasa mengajarkan kita tentang arti kesabaran, keikhlasan, dan empati terhadap kaum yang kurang mampu.''',
        },
        {
          'type': 'text',
          'content': '''Hal ini sebagaimana dijelaskan dalam firman Allah swt, Al-Quran surat Al-Baqarah ayat 183:''',
        },
        {
          'type': 'arabic',
          'content': '''يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوْا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَۙ''',
          'translation': '''Artinya, "Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa."''',
        },
        {
          'type': 'text',
          'content': '''Hadirin sidang Jumat yang berbahagia
Puasa Ramadan bukan hanya tentang menahan lapar dan dahaga, tetapi juga merupakan kesempatan untuk meningkatkan ketakwaan sosial. Ketakwaan sosial berarti memiliki rasa peduli dan tanggung jawab terhadap sesama manusia. Salah satu cara untuk meningkatkan ketakwaan sosial selama Ramadhan adalah dengan berbagi rezeki kepada orang lain. Hal ini dapat dilakukan dengan berbagai cara, seperti zakat, infak, sedekah, dan memberikan makanan buka puasa.''',
        },
        {
          'type': 'text',
          'content': '''Dalam hadis riwayat Imam Al-Bukhari dan Muslim dijelaskan, Nabi saw senantiasa memperbanyak sedekah dan berbagi pada yang tidak mampu di bulan Ramadhan.''',
        },
        {
          'type': 'arabic',
          'content': '''كَانَ رَسُولُ اللهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ أَجْوَدَ النَّاسِ وَكَانَ أَجْوَدُ (أَجْوَدَ) مَا يَكُونُ فِي رَمَضَانَ''',
          'translation': '''Artinya, "Rasulullah  saw adalah orang paling murah hati. Ia semakin murah hati di bulan Ramadhan."  (HR Al-Bukhari dan Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Hadirin sidang Jumat yang berbahagia''',
        },
        {
          'type': 'text',
          'content': '''Bulan Ramadhan identik dengan bulan penuh berkah dan ampunan. Di bulan ini, umat Islam dianjurkan untuk memperbanyak amalan ibadah, salah satunya adalah sedekah. Bersedekah di bulan Ramadhan memiliki keutamaan yang berlipat ganda dibandingkan dengan bulan lainnya. Hal ini sebagaimana dijelaskan dalam sebuah hadits yang diriwayatkan dari Abu Hurairah ra, bahwa Rasulullah saw bersabda:''',
        },
        {
          'type': 'arabic',
          'content': '''عن أَبي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ قال : قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ : قَالَ اللَّهُ : كُلُّ عَمَلِ ابْنِ آدَمَ لَهُ إِلا الصِّيَامَ فَإِنَّهُ لِي وَأَنَا أَجْزِي بِهِ''',
          'translation': '''Artinya, "Dari Abu Hurairah radhiyallahu \'anhu, ia berkata: Rasulullah shallallahu \'alaihi wa sallam bersabda: Allah berfirman: "Setiap amal anak Adam (manusia) untuknya, kecuali puasa. Puasa itu untuk-Ku dan Aku-lah yang akan membalasnya." (HR Al-Bukhari dan Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Hadirin sidang Jumat yang berbahagia''',
        },
        {
          'type': 'arabic',
          'content': '''Pada hadis lain, Nabi menerangkan tentang keutamaan dari bersedekah di bulan Ramadhan, yakni dapat menjadi penolak bala dan menghapus dosa. Dalam hadits riwayat ِ At-Tirmidzi, Nabi bersabda:''',
        },
        {
          'type': 'arabic',
          'content': '''الصَّدَقَةُ تُطْفِئُ الْخَطَايَا كَمَا يُطْفِىءُ الْمَاءُ النَّارَ''',
          'translation': '''Artinya, "Sedekah itu menghapus kesalahan seperti air memadamkan api." (HR At-Tirmidzi).''',
        },
        {
          'type': 'text',
          'content': '''Hadirin sidang Jumat yang berbahagia''',
        },
        {
          'type': 'text',
          'content': '''Dalam kitab Hasyiyatul Baijuri, Syekh Ibrahim Al-Baijuri mengungkapkan bahwa terdapat banyak keutamaan dalam berbagi pada bulan Ramadhan. Salah satu keutamaan yang paling utama adalah ganjaran pahala yang berlipat ganda dibandingkan dengan bulan lainnya.''',
        },
        {
          'type': 'text',
          'content': '''Untuk itu, setiap amalan kebaikan di bulan Ramadhan, termasuk berbagi, akan dibalas dengan pahala yang berlipat ganda. Hal ini tentu menjadi motivasi bagi umat Islam untuk meningkatkan amalan kebaikannya, khususnya dalam berbagi kepada sesama.''',
        },
        {
          'type': 'arabic',
          'content': '''وَمُبَادَرَتُهُ لِإِكْثَارِ الصَّدَقَةِ لأَنَّهُ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ كَانَ أَجْوَدَ مَا يَكُونُ فِي رَمَضَانَ، وَبِالْجُمْلَةِ فَيَكْثُرُ فِيهِ مِنْ أَعْمَالِ الْخَيْرِ لأَنَّ الْعَمَلَ يُضَاعَفُ فِيهِ عَلَى الْعَمَلِ فِي غَيْرِهِ مِنْ بَقِيَّةِ الشُّهُورِ''',
          'translation': '''Artinya, "Dan segera memperbanyak sedekah karena beliau shallallahu \'alaihi wa sallam adalah orang yang paling dermawan di bulan Ramadhan, dan secara umum dia memperbanyak amal kebaikan di bulan Ramadhan karena amal di bulan Ramadhan dilipatgandakan pahalanya dibandingkan dengan amal di bulan-bulan lainnya. (Syekh Ibrahim Al-Baijuri, Hasyiyatul Baijuri, [Beirut, Darul Kutub Al-Ilmiyyah: 1999 M/1420 H], juz I, halaman 562)''',
        },
        {
          'type': 'text',
          'content': '''Dengan demikian, puasa Ramadan bukan hanya tentang menahan lapar dan dahaga, tetapi juga merupakan kesempatan untuk meningkatkan ketakwaan sosial. Ketakwaan sosial berarti memiliki rasa peduli dan tanggung jawab terhadap sesama manusia.''',
        },
        {
          'type': 'text',
          'content': '''Hadirin sidang Jumat yang berbahagia''',
        },
        {
          'type': 'text',
          'content': '''Dengan meningkatkan ketakwaan sosial, kita dapat menciptakan masyarakat yang lebih adil, sejahtera, dan harmonis. Ramadan adalah waktu yang tepat untuk memulai dan menumbuhkan kebiasaan-kebiasaan positif yang dapat bermanfaat bagi diri sendiri dan orang lain.''',
        },
        {
          'type': 'text',
          'content': '''Banyak orang memahami takwa sebagai "Menjalani perintah Allah dan menjauhi larangan Allah". Pemahaman ini, meskipun benar, terkesan vertikal dan satu arah, berfokus pada hubungan manusia dengan Tuhan. Namun, makna takwa dalam Al-Qur\'an lebih luas dari itu. Takwa juga memiliki dimensi horizontal, yang disebut sebagai "takwa sosial". Konsep ini lebih membumi dan berfokus pada hubungan manusia dengan sesama.''',
        },
        {
          'type': 'text',
          'content': '''Takwa sosial mendorong manusia untuk berbuat baik, adil, dan bertanggung jawab kepada sesama. Orang yang bertakwa sosial tidak hanya mementingkan diri sendiri, tetapi juga memperhatikan kesejahteraan orang lain.''',
        },
        {
          'type': 'text',
          'content': '''Dalam Al-Quran surat Ali Imran ayat 133-134 menegaskan bahwa konsep takwa tidak hanya terbatas pada hubungan individu dengan Allah swt, tetapi juga memiliki dimensi sosial yang penting. Ayat ini menekankan bahwa orang yang bertakwa adalah mereka yang senantiasa berlomba-lomba dalam kebaikan, saling mengingatkan untuk menegakkan kebenaran dan kesabaran, dan saling membantu dalam kesulitan.''',
        },
        {
          'type': 'arabic',
          'content': '''وَسَارِعُوا إِلَى مَغْفِرَةٍ مِنْ رَبِّكُمْ وَجَنَّةٍ عَرْضُهَا السَّمَاوَاتُ وَالأرْضُ أُعِدَّتْ لِلْمُتَّقِينَ (١٣٣) الَّذِينَ يُنْفِقُونَ فِي السَّرَّاءِ وَالضَّرَّاءِ وَالْكَاظِمِينَ الْغَيْظَ وَالْعَافِينَ عَنِ النَّاسِ وَاللَّهُ يُحِبُّ الْمُحْسِنِينَ''',
          'translation': '''Artinya, "Bersegeralah menuju ampunan dari Tuhanmu dan surga (yang) luasnya (seperti) langit dan bumi yang disediakan bagi orang-orang yang bertakwa,(yaitu) orang-orang yang selalu berinfak, baik di waktu lapang maupun sempit, orang-orang yang mengendalikan kemurkaannya, dan orang-orang yang memaafkan (kesalahan) orang lain. Allah mencintai orang-orang yang berbuat kebaikan." (QS Ali Imran: 133-134​​).''',
        },
        {
          'type': 'text',
          'content': '''Hadirin sidang Jumat yang berbahagia''',
        },
        {
          'type': 'text',
          'content': '''Ayat ini menjelaskan bahwa orang yang bertakwa adalah mereka yang tidak terlena dalam kesenangan duniawi, tetapi selalu ingat untuk bersedekah dan membantu orang lain, bahkan ketika mereka sendiri sedang dalam kesulitan. Mereka juga senantiasa memohon ampunan atas dosa-dosa mereka dan berusaha untuk tidak mengulanginya lagi.''',
        },
        {
          'type': 'text',
          'content': '''Mari kita renungkan, saat kita berpuasa, kita akan merasakan lapar dan haus. Rasa ini dialami juga oleh fakir miskin yang mungkin  setiap harinya mereka kekurangan  makanan dan minuman.  Dengan merasakan lapar dan haus saat puasa, hati kita akan tergerak untuk lebih peduli dan  berbagi kepada mereka yang membutuhkan.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللهُ لِيْ وَلَكُمْ فِي الْقُرْاٰنِ الْعَظِيْمِ، وَنَفَعَنِي وَاِيَّاكُمْ بِمَا فِيْهِ مِنَ الْاٰيَاتِ وَالذِّكْرِ الْحَكِيْمِ، وَتَقَبَّلَ مِنِّيْ وَمِنْكُمْ تِلَاوَتَهُ اِنَّهُ هُوَ السَّمِيْعُ الْعَلِيْمُ. وَأَسْتَغْفِرُ اللهَ الْعَظِيْمَ لِيْ وَلَكُمْ وَلِسَائِرِ الْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ فَيَا فَوْزَ الْمُسْتَغْفِرِيْنَ وَيَا نَجَاةَ التَّائِبِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ للهِ الَّذِيْ أَنْعَمَنَا بِنِعْمَةِ الْاِيْمَانِ وَالْاِسْلَامِ. وَالصَّلَاةُ وَالسَّلَامُ عَلٰى سَيِّدِنَا مُحَمَّدٍ خَيْرِ الْأَنَامِ وَعَلٰى اٰلِهِ وَأَصْحَابِهِ الْكِرَامِ. أَشْهَدُ اَنْ لَا اِلٰهَ اِلَّا اللهُ الْمَلِكُ الْقُدُّوْسُ السَّلَامُ وَأَشْهَدُ اَنَّ سَيِّدَنَا وَحَبِيْبَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ صَاحِبُ الشَّرَفِ وَالْإِحْتِرَامِ''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ. فَيَا أَيُّهَا النَّاسُ أُوْصِيْكُمْ وَنَفْسِيْ بِتَقْوَى اللهِ فَقَدْ فَازَ الْمُتَّقُوْنَ. فَقَالَ اللهُ تَعَالَى اِنَّ اللهَ وَ مَلَائِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّ يٰأَيُّهَا الَّذِيْنَ أٰمَنُوْا صَلُّوْا عَلَيْهِ وَ سَلِّمُوْا تَسْلِيْمًا. اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلٰى سَيِّدِنَا مُحَمَّدٍ وَ عَلٰى أٰلِ سَيِّدِنَا مُحَمَّدٍ كَمَا صَلَّيْتَ عَلٰى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلٰى اٰلِ سَيِّدِنَا اِبْرَاهِيْمَ  وَبَارِكْ عَلٰى سَيِّدِنَا مُحَمَّدٍ وَعَلٰى اٰلِ سَيِّدِنَا مُحَمَّدٍ كَمَا بَارَكْتَ عَلٰى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلٰى اٰلِ سَيِّدِنَا اِبْرَاهِيْمَ فْي الْعَالَمِيْنَ اِنَّكَ حَمِيْدٌ مَجِيْدٌ اَللّٰهُمَّ وَارْضَ عَنِ الْخُلَفَاءِ الرَّاشِدِيْنَ. وَعَنْ اَصْحَابِ نَبِيِّكَ اَجْمَعِيْنَ. وَالتَّابِعِبْنَ وَتَابِعِ التَّابِعِيْنَ وَ تَابِعِهِمْ اِلٰى يَوْمِ الدِّيْنِ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ. اَللّٰهُمَّ ادْفَعْ عَنَّا الْغَلَاءَ وَالْوَبَاءَ وَالطَّاعُوْنَ وَالْاَمْرَاضَ وَالْفِتَنَ مَا لَا يَدْفَعُهُ غَيْرُكَ عَنْ بَلَدِنَا هٰذَا اِنْدُوْنِيْسِيَّا خَاصَّةً وَعَنْ سَائِرِ بِلَادِ الْمُسْلِمِيْنَ عَامَّةً يَا رَبَّ الْعَالَمِيْنَ. رَبَّنَا اٰتِنَا فِي الدُّنْيَا حَسَنَةً وَ فِي الْاٰخِرَةِ حَسَنَةً وَ قِنَا عَذَابَ النَّارِ. عِبَادَ اللهِ! إِنَّ اللهَ يَأْمُرُ بِاْلعَدْلِ وَاْلإِحْسَانِ وَإِيْتآءِ ذِي اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشآءِ وَاْلمُنْكَرِ وَاْلبَغْي يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ وَاذْكُرُوا اللهَ اْلعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلىَ نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللهِ أَكْبَرْ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Masrur Irsyadi, Pengajar di Ma\'had Ali UIN Jakarta''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Hidupkan Malam Ramadhan dengan Amal Saleh',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Bulan Ramadhan merupakan momen tahunan yang tidak seharusnya dilewatkan oleh umat Islam untuk berlomba memperbanyak amal saleh. Terutama dengan menghidupkan malamnya yang dipenuhi keberkahan dengan melakukan aktivitas positif.''',
        },
        {
          'type': 'text',
          'content': '''Naskah khutbah Jumat berikut ini dengan judul, "Hidupkan Malam Ramadhan dengan Amal Saleh." Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!''',
        },
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''الْحَمْدُ للهِ. الْحَمْدُ للهِ الَّذِيْ حَمْدًا يُوَافِيْ نِعَمَهُ وَيُكَافِئُ مَزِيْدَهُ, يَا رَبَّنَا لَكَ الْحَمْدُ كَمَا يَنْبَغِيْ لِجَلَالِ وَجْهِكَ وَلِعَظِيْمِ سُلْطَانِكَ سُبْحَانَكَ اَللّٰهُمَّ لَا أُحْصِيْ ثَنَاءَكَ عَلَيْكَ أَنْتَ كَمَا أَثْنَيْتَ عَلَى نَفْسِكَ, وَأَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ, وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ وَصَفِيُّهُ وَخَلِيْلُهُ، خَيْرُ نَبِيٍّ أَرْسَلَهُ اللهُ إِلَى الْعَالَمِ كُلِّهِ بَشِيْرًا وَنَذِيْرًا. اَللّٰهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى أَلِ سَيِّدِنَا مُحَمَّدٍ صَلَاةً وَسَلَامًا مُتَلَازِمَيْنِ إِلَى يَوْمِ الدِّيْنِ أَمَّا بَعْدُ، فَيَاأَيُّهَا الْحَاضِرُوْنَ اِتَّقُوا اللهَ حَقَّ تُقَاتِهِ وَلَا تَمُوْتُنَّ اِلَّا وَأَنْتُمْ مُسْلِمُوْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''قَالَ اللهُ تَعَالَى فِي الْقُرْاٰنِ الْعَظِيْمِ. أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ: يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوْا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَۙ''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat yang dimuliakan Allah''',
        },
        {
          'type': 'text',
          'content': '''Segala puji bagi Allah yang telah memberikan kita berbagai macam kenikmatan sehingga kita dapat memenuhi panggilan-Nya untuk menunaikan shalat Jumat. Nikmat yang harus digunakan dalam rangka memenuhi syariat yang telah ditetapkan-Nya.''',
        },
        {
          'type': 'text',
          'content': '''Shalawat beserta salam, mari kita haturkan bersama kepada Nabi Muhammad saw, juga kepada para keluarganya, sahabatnya, dan semoga melimpah kepada kita semua selaku umatnya. Aamiiin ya Rabbal \'alamin.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat yang dimuliakan Allah''',
        },
        {
          'type': 'text',
          'content': '''Saat ini kita berada di dalam bulan Ramadhan. Bulan Ramadhan merupakan bulan yang mulia. Pada bulan ini Al-Qur\'an turun, juga pada bulan ini malam lailatul qadar berada. Pada bulan ini pula umat Islam seluruh dunia diwajibkan melaksanakan puasa selama satu bulan penuh. Allah berfirman dalam surat Al-Baqarah ayat 183:''',
        },
        {
          'type': 'arabic',
          'content': '''يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوْا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَۙ''',
          'translation': '''Artinya, "Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa." (QS. Al-Baqarah: 183).''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat yang dimuliakan Allah''',
        },
        {
          'type': 'text',
          'content': '''Banyak riwayat hadits yang menjelaskan keutamaan bulan Ramadhan. Termasuk keutamaan menghidupkan malam Ramadhan dengan berbagai macam ibadah untuk mendekatkan diri kepada Allah ta\'ala. Kita simak hadits yang diriwayatkan oleh Imam Bukhari berikut:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنْ أَبِي هُرَيْرَةَ أَنَّ رَسُولَ اللَّهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ قَالَ: ‌مَنْ ‌قَامَ ‌رَمَضَانَ إِيمَانًا وَاحْتِسَابًا، غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ''',
          'translation': '''Artinya, "Dari Abu Hurairah bahwa Rasulullah saw bersabda: "Barangsiapa beribadah di bulan Ramadhan dalam keadaan beriman dan mencari pahala, maka dosa-dosanya yang telah lalu akan diampuni." (HR. Bukhari).''',
        },
        {
          'type': 'text',
          'content': '''Hadits di atas menjelaskan keutamaan beribadah di bulan Ramadhan. Pada hadits tersebut dijelaskan bahwa orang-orang yang memurnikan diri beribadah kepada Allah di bulan Ramadhan dengan niat yang tulus dan mengharapkan pahala dari-Nya akan diampuni dosa-dosanya yang telah berlalu.''',
        },
        {
          'type': 'text',
          'content': '''Imam Al-Qasthalani dalam kitabnya Irsyadus Sari juz I, hal 178 menjelaskan bahwa arti hadits di atas ialah, "Siapa pun yang menghidupkan malam bulan Ramadhan dengan melaksanakan ketaatan, seperti shalat tarawih, dalam keadaan beriman kepada Allah dan dengan niat yang tulus, akan diampuni dosa-dosanya yang telah berlalu. Ini mencakup dosa-dosa kecil, dan dengan anugerah serta rahmat-Nya, juga bisa mencakup dosa-dosa besar, sebagaimana tercermin dalam lafadz hadits tersebut."''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat yang dimuliakan Allah''',
        },
        {
          'type': 'text',
          'content': '''Salah satu tujuan menghidupkan malam bulan Ramadhan dengan berbagai ibadah adalah untuk meraih malam Lailatul Qadar, yang lebih baik dari seribu bulan.''',
        },
        {
          'type': 'text',
          'content': '''Pada malam ini, seluruh Al-Qur\'an diturunkan secara keseluruhan dari Lauhul Mahfudz ke langit dunia, sebelum diturunkan secara bertahap kepada Nabi Muhammad SAW selama 23 tahun. Lailatul Qadar adalah malam penuh berkah yang disembunyikan oleh Allah dalam bulan Ramadhan setiap tahunnya, dan tidak ada yang mengetahui dengan pasti kapan terjadinya. Rasulullah SAW bersabda:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ، عَنِ النَّبِيِّ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ، قَالَ: مَنْ قَامَ لَيْلَةَ القَدْرِ إِيمَانًا وَاحْتِسَابًا، غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ، وَمَنْ صَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ''',
          'translation': '''Artinya, "Dari Abi Hurairah ra, dari Nabi Muhammad saw bersabda: "Siapa saja yang menghidupkan malam lailatul qadar dengan keimanan dan mengharapkan pahala dari-Nya, maka dosa-dosanya yang telah berlalu akan diampuni, barangsiapa yang berpuasa di bulan Ramadhan dalam keadaan iman dan mengharapkan pahala dari-Nya maka dosanya yang telah berlalu akan diampuni". (HR. Bukhari).''',
        },
        {
          'type': 'text',
          'content': '''Dalam hal ini menghidupkan malam Ramadhan dengan berbagai macam ibadah sangat dianjurkan dalam Islam. Terlebih pada 10 malam terakhir bulan Ramadhan. Pada malam-malam tersebut Rasulullah SAW akan lebih giat lagi menghidupkan malamnya untuk beribadah kepada Allah. Rasulullah SAW bersabda:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنْ عَائِشَةَ رَضِيَ اللَّهُ عَنْهَا، قَالَتْ: كَانَ النَّبِيُّ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ إِذَا دَخَلَ العَشْرُ شَدَّ مِئْزَرَهُ، وَأَحْيَا لَيْلَهُ، وَأَيْقَظَ أَهْلَهُ''',
          'translation': '''Artinya, "Dari Aisyah ra, berkata: Rasululullah saw ketika memasuki 10 malam terakhir akan mengencangkan sabuknya, menghidupkan malamnya dan membangunkan keluarganya." (HR. Bukhari).''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat yang dimuliakan Allah''',
        },
        {
          'type': 'text',
          'content': '''Ada banyak cara yang dapat dilakukan untuk menghidupkan malam bulan Ramadhan, di antaranya:''',
        },
        {
          'type': 'text',
          'content': '''Pertama, mari kita lakukan shalat Isya berjamaah, lalu dilanjutkan dengan shalat Tarawih, Witir, dan shalat malam lainnya. Lakukan semua ini dengan niat ikhlas, mengharapkan ridha Allah SWT. Seperti yang dijelaskan dalam syarah hadits, salah satu makna "qama ramadhana" adalah melaksanakan shalat Tarawih.''',
        },
        {
          'type': 'text',
          'content': '''Kedua, bacalah Al-Qur\'an dengan niat mengikuti jejak Nabi Muhammad SAW. Dalam sebuah hadits, disebutkan bahwa selama bulan Ramadhan, Nabi Muhammad SAW menjadi lebih dermawan dan setiap hari bertemu Jibril untuk membaca Al-Qur\'an.''',
        },
        {
          'type': 'text',
          'content': '''Ketiga, mari kita beri\'tikaf di masjid, terutama pada 10 hari terakhir bulan Ramadhan, seperti yang dilakukan oleh Rasulullah SAW dalam hadits berikut:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنْ عَبْدِ اللَّهِ بْنِ عُمَرَ رَضِيَ اللَّهُ عَنْهُمَا، قَالَ: كَانَ رَسُولُ اللَّهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ يَعْتَكِفُ العَشْرَ الأَوَاخِرَ مِنْ رَمَضَانَ''',
          'translation': '''Artinya, "Dari Abdullah bin Umar ra berkata, \'Rasulullah saw rutin melakukan i\'tikaf pada 10 hari terakhir dari Ramadhan\'." (HR. Bukhari).''',
        },
        {
          'type': 'text',
          'content': '''Kesimpulannya, bulan Ramadhan adalah momen sekali dalam setahun umat Islam mendapatkan banyak ruang untuk meningkatkan kualitas ibadah. Oleh karenanya, selayaknya bagi kita untuk memanfaatkannya sebaik mungkin untuk beribadah kepada Allah. Terlebih di malam hari dengan harapan mendapatkan keutamaan malam lailatul qadar.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللهُ لِيْ وَلَكُمْ فِي الْقُرْاٰنِ الْعَظِيْمِ وَنَفَعَنِي وَاِيَّاكُمْ بِمَا فِيْهِ مِنَ الْاٰيَاتِ وَالذِّكْرِ الْحَكِيْمِ وَتَقَبَّلَ مِنِّيْ وَمِنْكُمْ تِلَاوَتَهُ اِنَّهُ هُوَ السَّمِيْعُ الْعَلِيْمُ. وَأَسْتَغْفِرُ اللهَ الْعَظِيْمَ لِيْ وَلَكُمْ وَلِسَائِرِ الْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ فَيَا فَوْزَ الْمُسْتَغْفِرِيْنَ وَيَا نَجَاةَ التَّائِبِيْنَ''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''الْحَمْدُ للهِ الَّذِيْ أَنْعَمَنَا بِنِعْمَةِ الْاِيْمَانِ وَالْاِسْلَامِ. وَالصَّلَاةُ وَالسَّلَامُ عَلٰى سَيِّدِنَا مُحَمَّدٍ خَيْرِ الْأَنَامِ. وَعَلٰى اٰلِهِ وَأَصْحَابِهِ الْكِرَامِ. أَشْهَدُ اَنْ لَا اِلٰهَ اِلَّا اللهُ الْمَلِكُ الْقُدُّوْسُ السَّلَامُ وَأَشْهَدُ اَنَّ سَيِّدَنَا وَحَبِيْبَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ صَاحِبُ الشَّرَفِ وَالْإِحْتِرَامِ''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ. فَيَاأَيُّهَا النَّاسُ أُوْصِيْكُمْ وَنَفْسِيْ بِتَقْوَى اللهِ فَقَدْ فَازَ الْمُتَّقُوْنَ. فَقَالَ اللهُ تَعَالَى اِنَّ اللهَ وَ مَلَائِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّ يٰأَيُّهَا الَّذِيْنَ أٰمَنُوْا صَلُّوْا عَلَيْهِ وَ سَلِّمُوْا تَسْلِيْمًا''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلٰى سَيِّدِنَا مُحَمَّدٍ وَ عَلٰى أٰلِ سَيِّدِنَا مُحَمَّدٍ كَمَا صَلَّيْتَ عَلٰى سَيِّدِنَا اِبْرَاهِيْمَ وَبَارِكْ عَلٰى سَيِّدِنَا مُحَمَّدٍ وَعَلٰى اٰلِ سَيِّدِنَا مُحَمَّدٍ كَمَا بَارَكْتَ عَلٰى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلٰى اٰلِ سَيِّدِنَا اِبْرَاهِيْمَ فْي الْعَالَمِيْنَ اِنَّكَ حَمِيْدٌ مَجِيْدٌ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ وَارْضَ عَنِ الْخُلَفَاءِ الرَّاشِدِيْنَ. وَعَنْ اَصْحَابِ نَبِيِّكَ اَجْمَعِيْنَ. وَالتَّابِعِبْنَ وَتَابِعِ التَّابِعِيْنَ وَ تَابِعِهِمْ اِلٰى يَوْمِ الدِّيْنِ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ. اَللّٰهُمَّ ادْفَعْ عَنَّا الْغَلَاءَ وَالْوَبَاءَ وَالطَّاعُوْنَ وَالْاَمْرَاضَ وَالْفِتَنَ مَا لَا يَدْفَعُهُ غَيْرُكَ عَنْ بَلَدِنَا هٰذَا اِنْدُوْنِيْسِيَّا خَاصَّةً وَعَنْ سَائِرِ بِلَادِ الْمُسْلِمِيْنَ عَامَّةً يَا رَبَّ الْعَالَمِيْنَ. رَبَّنَا اٰتِنَا فِي الدُّنْيَا حَسَنَةً وَ فِي الْاٰخِرَةِ حَسَنَةً وَ قِنَا عَذَابَ النَّارِ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ اِنَّ اللهَ يَأْمُرُ بِالْعَدْلِ وَالْاِحْسَانِ وَيَنْهَى عَنِ الْفَحْشَاءِ وَالْمُنْكَرِ. يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ. فَاذْكُرُوا اللهَ الْعَظِيْمَ يَذْكُرْكُمْ. وَ اشْكُرُوْهُ عَلٰى نِعَمِهِ يَزِدْكُمْ. وَلَذِكْرُ اللهِ اَكْبَرُ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Alwi Jamalulel Ubab, Alumni Khas Kempek Cirebon dan Mahad Aly Jakarta''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Menjadikan Ramadhan sebagai Madrasah Ketakwaan',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Menjadikan Ramadhan sebagai madrasah ketakwaan merupakan langkah bijak untuk meraih peningkatan spiritual selama bulan suci. Orang yang memanfaatkan Ramadhan sebagai ajang mendidik diri akan lebih disiplin dalam beribadah, lebih terkendali dalam berbicara dan bertindak, serta lebih peka terhadap nilai-nilai kebaikan.''',
        },
        {
          'type': 'text',
          'content': '''Naskah khutbah Jumat berikut ini dengan judul, "Khutbah Jumat: Menjadikan Ramadhan sebagai Madrasah Ketakwaan". Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat!''',
        },
        {
          'type': 'arabic',
          'content': '''الْحَمْدُ لِلّٰهِ الَّذِي أَنْزَلَ الْأَحْكَامَ لِإِمْضَاءِ عِلْمِهِ الْقَدِيمِ، وَأَجْزَلَ الْإِنْعَامَ لِشَاكِرِ فَضْلِهِ الْعَمِيمِ. وَأَشْهَدُ أَنْ لَا إِلٰهَ إلَّا اللّٰهُ وَحْدَهُ لَا شَرِيكَ لَهُ الْبَرُّ الرَّحِيمُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ الْمَبْعُوثُ بِالدِّيْنِ الْقَوِيمِ، الْمَنْعُوتُ بِالْخُلُقِ الْعَظِيمِ. صَلَّى اللَّهُ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ وَسَلَّمَ أَفْضَلَ الصَّلَاةِ وَالتَّسْلِيمِ. أَمَّا بَعْدُ: فَيَا عِبَادَ الْكَرِيْمِ، فَإِنِّي أُوْصِيكُمْ بِتَقْوَى اللَّهِ الْحَكِيْمِ، الْقَائِلِ فِي كِتَابِهِ الْقُرْآنِ الْعَظِيْمِ: يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin jamaah Jumat yang dirahmati Allah''',
        },
        {
          'type': 'text',
          'content': '''Alhamdulillahi rabbil alamin, kalimat syukur yang harus senantiasa kita lafalkan melalui lisan, atas segala nikmat dan karunia yang telah Allah berikan, terkhusus nikmat agung dipertemukannya kembali dengan bulan yang sangat mulia, yaitu bulan Ramadhan. Semoga di bulan yang sangat singkat ini, kita bisa benar-benar meraih manfaat, keutamaan, dan keberkahan yang ada di dalamnya.''',
        },
        {
          'type': 'text',
          'content': '''Shalawat dan salam tak henti-hetinya kita curahkan kepada junjungan kita, Nabi Muhammad saw, allahumma shalli wa sallim \'ala sayyidina Muhammad wa \'ala alih wa shahbih. Sosok teladan yang sempurna, insan yang jujur, sabar, dan bijaksana. Semoga kita semua yang hadir pada pelaksanaan shalat Jumat ini termasuk golongan umatnya yang mendapatkan syafaat darinya kelak di hari kiamat. Amin ya rabbal alamin.''',
        },
        {
          'type': 'text',
          'content': '''Selanjutnya, sudah menjadi kewajiban bagi kami selaku khatib, untuk senantiasa mengajak dan mengingatkan kepada kami sendiri dan keluarga, serta semua jamaah yang hadir pada pelaksanaan shalat Jumat ini, untuk senantiasa meningkatkan keimanan dan ketakwaan kepada Allah, yaitu dengan terus istiqamah mengerjakan ketaatan, kebaikan, dan kedisiplinan, terkhusus di bulan Ramadhan yang mulia ini, di mana semua amal kebajikan akan dilipatgandakan pahalanya oleh Allah.''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin jamaah Jumat yang dirahmati Allah''',
        },
        {
          'type': 'text',
          'content': '''Ramadhan adalah bulan penuh berkah yang sejatinya berfungsi sebagai madrasah ketakwaan bagi kita Semua sebagai umat Islam. Selama sebulan penuh, kita diajarkan untuk menahan diri dari segala hal yang membatalkan puasa, tidak hanya sebatas makan dan minum saja, namun juga dari perkataan dan perbuatan yang sia-sia.''',
        },
        {
          'type': 'text',
          'content': '''Dengan berpuasa, kita diajarkan tentang kesabaran dan pengendalian diri. Dengan shalat tarawih, kita diajarkan tentang kesabaran dan kedisiplinan. Dengan sedekah dan zakat fitrah, kita diajarkan untuk menumbuhkan kepekaan sosial kepada sesama. Begitu juga dengan membaca Al-Qur\'an, kita diajarkan untuk memperdalam kandungan yang ada dalam firman Allah. Semua ibadah ini, menjadi bukti nyata bagi kita Semua bahwa kehadiran bulan Ramadhan menjadi tempat belajar atau madrasah untuk memperkukuh ketakwaan kita semua.''',
        },
        {
          'type': 'text',
          'content': '''Oleh sebab itu, Allah swt berfirman dalam Al-Qur\'an bahwa tujuan diwajibkannya puasa adalah untuk meningkatkan ketakwaan. Maka sangat tepat jika kita menjadikan Ramadhan sebagai madrasah untuk meningkatkan ketakwaan kepada-Nya. Dalam Al-Qur\'an Allah berfirman:''',
        },
        {
          'type': 'arabic',
          'content': '''يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ''',
          'translation': '''Artinya, "Wahai orang-orang yang beriman! Diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa." (QS Al-Baqarah [2]: 183).''',
        },
        {
          'type': 'text',
          'content': '''Ayat ini dengan jelas mengingatkan kita Semua tentang tujuan utama dari puasa di bulan Ramadhan, yaitu untuk mencapai ketakwaan kepada Allah. Karenanya, puasa tidak hanya sekadar ritual ibadah yang dalam praktiknya hanya dengan menahan lapar dan dahaga saja, namun juga untuk membentuk pribadi yang lebih taat kepada-Nya, membentuk pribadi yang bisa menjaga pandangan, perkataan, dan perbuatan, serta menjauhkan diri dari segala perbuatan yang tidak diridhai oleh Allah.''',
        },
        {
          'type': 'text',
          'content': '''Imam Ibnu Katsir dalam kitab Tafsir Al-Qur\'anil Adzim, jilid I, halaman 497 menjelaskan alasan kenapa Allah menjadikan takwa sebagai puncak dan tujuan dari ibadah puasa, karena dengannya kita akan berusaha untuk membersihkan diri dari segala kejelekan, dan dengan berpuasa pula kita akan mempersempit jalur-jalur setan. Artinya, hawa nafsu akan melemah sehingga setan akan lebih sulit menggoda manusia,''',
        },
        {
          'type': 'arabic',
          'content': '''لَعَلَّكُمْ تَتَّقُونَ. لِأَنَّ الصَّوْمَ فِيْهِ تَزْكِيَةٌ لِلْبَدَنِ وَتَضْيِيْقٌ لِمَسَالِكِ الشَّيْطَانِ''',
          'translation': '''Artinya, "Agar kamu bertakwa. Karena di dalam puasa terdapat penyucian bagi tubuh dan penyempitan jalan-jalan setan."''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin jamaah Jumat yang dirahmati Allah''',
        },
        {
          'type': 'text',
          'content': '''Menjadikan Ramadhan sebagai madrasah ketakwaan artinya kita tidak hanya sekadar menjalani ibadah di bulan Ramadhan saja tanpa memperhatikan hal-hal yang bisa merusak pahala ibadah tersebut, namun juga harus menjaga sakralitasnya, agar kita bisa beribadah sekaligus mendapatkan pahala dari ibadah yang kita kerjakan, alias diterima oleh Allah.''',
        },
        {
          'type': 'text',
          'content': '''Caranya adalah dengan meninggalkan segala perbuatan-perbuatan jelek yang biasa kita lakukan sebelum puasa, seperti membicarakan keburukan orang lain, berbohong, mengadu domba, berbohong, memandang hal-hal yang dilarang alam Islam dengan syahwat, dan lainnya. Semua perbuatan ini sejatinya sekalipun tidak membatalkan puasa, namun bisa menghanguskan pahala ibadah tersebut.''',
        },
        {
          'type': 'text',
          'content': '''Berkaitan dengan penjelasan dia atas, Syekh Hasan al-Massyath dalam kitab Is\'afu Ahlil Iman bi Wadza\'if Syahri Ramadhan, halaman 45 mengatakan:''',
        },
        {
          'type': 'arabic',
          'content': '''إِذَا لَم يَكُنْ فِي السَّمْعِ مِنِّي تَصَاوُنٌ * وَفِي بَصَرِي غَضٌّ وَفِي مَنْطِقِي صَمْتٌ * فَحَظِّي إِذَنْ مِنْ صَومِيَ الجُوعُ وَ الظَّما ** فَإِنْ قُلْتُ إِنِّي صُمْتُ يَومِي فَمَا صُمْتُ''',
          'translation': '''Artinya, "(Jika saat puasa) pendengaranku tidak dijaga, tidak menundukkan pandanganku, dan tidak mendiamkan ucapanku. Maka tidak ada yang aku peroleh dari puasaku kecuali lapar dan dahaga. Sekalipun aku mengatakan "aku puasa", padahal kenyataannya tidak."''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral Muslimin jamaah Jumat yang dirahmati Allah''',
        },
        {
          'type': 'text',
          'content': '''Oleh sebab itu, mari kita jadikan bulan Ramadhan ini sebagai madrasah, tempat belajar untuk meningkatkan keimanan dan ketakwaan kepada Allah swt, sehingga kita akan terbiasa melakukan kebaikan-kebaikan dan istiqamah dalam melakukan ketaatan, sekalipun setelah selesainya bulan Ramadhan nanti, sebab kita sudah terdidik dan terbiasa melakukannya selama bulan Ramadhan ini.''',
        },
        {
          'type': 'text',
          'content': '''Demikian adanya khutbah Jumat, perihal menjadikan bulan Ramadhan sebagai . Semoga menjadi khutbah yang membawa berkah dan manfaat bagi kita semua. Amin ya rabbal alamin.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللهُ لِيْ وَلَكُمْ، وَنَفَعَنِيْ وَاِيَاكُمْ بِمَا فِيْهِ مِنَ اْلآيَاتِ وَالذِّكْرِ الْحَكِيْمِ، وَتَقَبَّلَ مِنِّيْ وَمِنْكُمْ جَمِيْعَ أَعْمَالِنَا إِنَّهُ هُوَ الْحَكِيْمُ الْعَلِيْمُ. أَقُوْلُ قَوْلِيْ هَذَا وَأَسْتَغْفِرُ اللهَ لِيْ وَلَكُمْ وَلِلْمُسْلِمِيْنَ فَاسْتَغْفِرُوْهُ اِنَّهُ هُوَ الْغَفُوْرُ الرَّحِيْمُ''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ للهِ حَمْدًا كَمَا أَمَرَ. أَشْهَدُ أَنْ لَا إِلٰهَ اِلَّا الله وَحْدَهُ لَا شَرِيْكَ لَهُ، اِلَهٌ لَمْ يَزَلْ عَلَى كُلِّ شَيْءٍ وَكِيْلًا. وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ وَحَبِيْبُهُ وَخَلِيْلُهُ، أَكْرَمُ الْأَوَّلِيْنَ وَالْأَخِرِيْنَ، اَلْمَبْعُوْثُ رَحْمَةً لِلْعَالَمِيْنَ. اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلىَ أَلِهِ وَأَصْحَابِهِ وَمَنْ كَانَ لَهُمْ مِنَ التَّابِعِيْنَ، صَلَاةً دَائِمَةً بِدَوَامِ السَّمَوَاتِ وَالْأَرْضِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ: فَيَا أَيُّهَا الْحَاضِرُوْنَ اتَّقُوا اللهَ حَقَّ تُقَاتِهِ وَذَرُوْا الْفَوَاحِشَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ. وَحَافِظُوْا عَلَى الطَّاعَةِ وَحُضُوْرِ الْجُمْعَةِ وَالْجَمَاعَةِ وَالصَّوْمِ وَجَمِيْعِ الْمَأْمُوْرَاتِ وَالْوَاجِبَاتِ. وَاعْلَمُوْا أَنَّ اللهَ أَمَرَكُمْ بِأَمْرٍ بَدَأَ بِنَفْسِهِ. وَثَنَى بِمَلَائِكَةِ الْمُسَبِّحَةِ بِقُدْسِهِ. إِنَّ اللهَ وَمَلائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ يَا أَيُّهَا الَّذِينَ آمَنُوا صَلُّوا عَلَيْهِ وَسَلِّمُوا تَسْلِيماً''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلَى آلِ سَيِّدِنَا اِبْرَاهِيْمَ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ كَمَا بَارَكْتَ عَلَى سَيِّدِنَا اِبْرَاهِيْمَ وَعَلَى آلِ سَيِّدِنَا اِبْرَاهِيْمَ فِيْ العَالَمِيْنَ اِنَّكَ حَمِيْدٌ مَجِيْدٌ. اَللّٰهُمَّ  اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ اَلْأَحْيَاءِ مِنْهُمْ وِالْأَمْوَاتِ. اَللّٰهُمَّ  ادْفَعْ عَنَّا الْبَلَاءَ وَالْغَلَاءَ وَالْوَبَاءَ وَالْفَحْشَاءَ وَالْمُنْكَرَ وَالْبَغْيَ وَالسُّيُوْفَ الْمُخْتَلِفَةَ وَالشَّدَائِدَ وَالْمِحَنَ، مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ، مِنْ بَلَدِنَا هَذَا خَاصَةً وَمِنْ بُلْدَانِ الْمُسْلِمِيْنَ عَامَةً، اِنَّكَ عَلَى كُلِّ شَيْءٍ قَدِيْرٌ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ، اِنَّ اللهَ يَأْمُرُ بِالْعَدْلِ وَالْاِحْسَانِ وَاِيْتَاءِ ذِيْ الْقُرْبَى وَيَنْهَى عَنِ الْفَحْشَاءِ وَالْمُنْكَرِ وَالْبَغْيِ، يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ. فَاذْكُرُوْا اللهَ الْعَظِيْمَ يَذْكُرُكُمْ وَلَذِكْرُ اللهِ أَكْبَرُ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Sunnatullah, Pengajar di Pondok Pesantren Al-Hikmah Darussalam Durjan Kokop Bangkalan Jawa Timur, dan alumnus Program Kepenulisan Turots Ilmiah Maroko.''',
        }
      ]
    }
  ];

  final List<Map<String, dynamic>> _ramadhanMenu = [
    {
      'title': 'Doa Menyambut Bulan Ramadhan',
      'arabic': 'اَللَّهُمَّ سَلِّمْنِيْ مِنْ رَمَضَانَ، وَسَلِّمْ رَمَضَانَ لِيْ، وَتَسَلَّمْهُ مِنِّيْ مُتَقَبَّلًا',
      'latin': 'Allâhumma sallimnî min ramadlâna wa sallim ramadlâna lî wa tasallamhu minnî mutaqabbalan',
      'translation': 'Ya Allah, sampaikan aku (dengan selamat menuju bulan) Ramadhan. Sampaikanlah Ramadhan kepadaku, dan terimalah amal-amalku (di bulan Ramadhan).',
    },
    {
      'title': 'Niat Puasa Ramadhan Sebulan Penuh',
      'arabic': 'نَوَيْتُ صَوْمَ جَمِيعِ شَهْرِ رَمَضَانِ هٰذِهِ السَّنَةِ تَقْلِيْدًا لِلْإِمَامِ مَالِكٍ فَرْضًا لِلّٰهِ تَعَالَى',
      'latin': 'Nawaitu shauma jamî\'i syahri ramadlâni hâdzihis sanati taqlîdan lil imâmi mâlikin fardlan lillâhi ta\'âlâ',
      'translation': 'Aku niat berpuasa di sepanjang bulan Ramadhan tahun ini dengan mengikuti Imam Malik, fardhu karena Allah.',
    },
    {
      'title': 'Niat Puasa Ramadhan',
      'arabic': 'نَوَيْتُ صَوْمَ غَدٍ عَنْ أَدَاءِ فَرْضِ شَهْرِ رَمَضَانَ هٰذِهِ السَّنَةِ لِلّٰهِ تَعَالَى',
      'latin': 'Nawaitu shauma ghadin \'an adâ\'i fardli syahri ramadlâna hâdzihis sanati lillâhi ta\'âlâ',
      'translation': 'Aku niat berpuasa esok hari untuk menunaikan fardhu di bulan Ramadhan tahun ini, karena Allah Ta\'ala.',
    },
    {
      'title': 'Doa usai Buka Puasa',
      'arabic': 'اَللّٰهُمَّ لَكَ صُمْتُ وَعَلَى رِزْقِكَ أَفْطَرْتُ ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوْقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللّٰهُ تَعَالَى',
      'latin': 'Allâhumma laka shumtu wa \'alâ rizqika afthartu dzahaba-dh-dhama\'u wabtalatil \'urûqu wa tsabatal ajru insyâ-allâh ta\'âlâ',
      'translation': 'Ya Allah, untuk-Mulah aku berpuasa, atas rezekimulah aku berbuka. Telah sirna rasa dahaga, urat-urat telah basah, dan (semoga) pahala telah ditetapkan, insyaallah.',
    },
    {
      'title': 'Niat Shalat Tarawih',
      'arabic': '',
      'latin': '',
      'translation': '',
      'sections': [
        {
          'subtitle': 'Sebagai Imam',
          'arabic': 'أُصَلِّيْ سُنَّةَ التَّرَاوِيْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً إِمَامًا لِلّٰهِ تَعَالَى',
          'latin': 'Ushallî sunnatat tarâwîhi rak\'atayni mustaqbilal qiblati adâ\'an imâman lillâhi ta\'âlâ.',
          'translation': 'Aku menyengaja shalat sunnah tarawih dua rakaat dengan menghadap kiblat, tunai sebagai imam karena Allah ta\'ala.',
        },
        {
          'subtitle': 'Sebagai Makmum',
          'arabic': 'أُصَلِّيْ سُنَّةَ التَّرَاوِيْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً مَأْمُوْمًا لِلّٰهِ تَعَالَى',
          'latin': 'Ushallî sunnatat tarâwîhi rak\'atayni mustaqbilal qiblati adâ\'an ma\'mûman lillâhi ta\'âlâ.',
          'translation': 'Aku menyengaja shalat sunnah tarawih dua rakaat dengan menghadap kiblat, tunai sebagai makmum karena Allah ta\'ala.',
        },
        {
          'subtitle': 'Sendirian',
          'arabic': 'أُصَلِّيْ سُنَّةَ التَّرَاوِيْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلّٰهِ تَعَالَى',
          'latin': 'Ushallî sunnatat tarâwîhi rak\'atayni mustaqbilal qiblati adâ\'an lillâhi ta\'âlâ.',
          'translation': 'Aku menyengaja shalat sunnah tarawih dua rakaat dengan menghadap kiblat, tunai karena Allah ta\'ala.',
        },
      ]
    },
    {
      'title': 'Bilal Tarawih dan Jawabannya',
      'arabic': '',
      'latin': '',
      'translation': '',
      'sections': [
        {
          'subtitle': 'الصلاة ١\nDua rakaat shalat ke-1',
          'arabic': 'صَلُّوْا سُنَّةَ التَّرَاوِيْحِ رَكْعَتَيْنِ جَامِعَةً رَحِمَكُمُ اللّٰهُ (رَحِمَكُمُ اللّٰهُ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Shallû sunnatat tarâwîhi rak\'ataini jâmi\'atan rahimakumullâh.\n(Jawaban jamaah: Rahimakumullâh)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Shalatlah sunnah tarawih dua rakaat secara berjamaah. Semoga Allah merahmati kalian semua.\n(Semoga Allah merahmati kalian semua)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٢\nDua rakaat shalat ke-2',
          'arabic': 'فَضْلًا مِنَ اللّٰهِ تَعَالَى وَنِعْمَةً (وَمَغْفِرَةً وَنِعْمَةً)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Fadl-lan mina-Llâhi ta\'âlâ wa ni\'mah.\n(Jawaban jamaah: Wa maghfiratan wa ni\'mah)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Kita berharap karunia dan kenikmatan dari Allah ta\'ala.\n([Berharap pula] ampunan dan kenikmatan)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٣\nDua rakaat shalat ke-3',
          'arabic': 'اَلْخَلِيْفَةُ الْأُوْلَى سَيِّدُنَا أَبُوْ بَكْرِ الصِّدِّيْقُ (رَضِيَ اللّٰهُ عَنْهُ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Al-khalîfatul ûlâ sayyidunâ Abû Bakrnish-Shiddîq.\n(Jawaban jamaah: Radliyallâhu \'anh)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Khalifah pertama Sayyidina Abu Bakar ash-Shiddiq.\n(Semoga Allah meridhainya)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٤\nDua rakaat shalat ke-4',
          'arabic': 'فَضْلًا مِنَ اللّٰهِ تَعَالَى وَنِعْمَةً (وَمَغْفِرَةً وَنِعْمَةً)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Fadl-lan mina-Llâhi ta\'âlâ wa ni\'mah.\n(Jawaban jamaah: Wa maghfiratan wa ni\'mah)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Kita berharap karunia dan kenikmatan dari Allah ta\'ala.\n([Berharap pula] ampunan dan kenikmatan)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٥\nDua rakaat shalat ke-5',
          'arabic': 'اَلْخَلِيْفَةُ الثَّانِيَةُ سَيِّدُنَا عُمَرُ ابْنُ الْخَطَّابِ (رَضِيَ اللّٰهُ عَنْهُ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Al-khalîfatuts-tsâniyah sayyidunâ \'Umar ibnu Khaththâb.\n(Jawaban jamaah: Radliyallâhu \'anh)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Khalifah kedua Sayyidina Umar bin Khattab.\n(Semoga Allah meridhainya)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٦\nDua rakaat shalat ke-6',
          'arabic': 'فَضْلًا مِنَ اللّٰهِ تَعَالَى وَنِعْمَةً (وَمَغْفِرَةً وَنِعْمَةً)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Fadl-lan mina-Llâhi ta\'âlâ wa ni\'mah.\n(Jawaban jamaah: Wa maghfiratan wa ni\'mah)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Kita berharap karunia dan kenikmatan dari Allah ta\'ala.\n([Berharap pula] ampunan dan kenikmatan)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٧\nDua rakaat shalat ke-7',
          'arabic': 'اَلْخَلِيْفَةُ الثَّالِثَةُ سَيِّدُنَا عُثْمَانُ بْنُ عَفَّانِ (رَضِيَ اللّٰهُ عَنْهُ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Al-khalîfatuts tsâlitsah sayyidunâ \'Utsmân ibnu \'Affân radliyallâhu \'anh.\n(Jawaban jamaah: Radliyallâhu \'anh)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Khalifah ketiga Sayyidina Utsman bin Affan.\n(Semoga Allah meridhainya)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٨\nDua rakaat shalat ke-8',
          'arabic': 'فَضْلًا مِنَ اللّٰهِ تَعَالَى وَنِعْمَةً (وَمَغْفِرَةً وَنِعْمَةً)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Fadl-lan mina-Llâhi ta\'âlâ wa ni\'mah.\n(Jawaban jamaah: Wa maghfiratan wa ni\'mah)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Kita berharap karunia dan kenikmatan dari Allah ta\'ala.\n([Berharap pula] ampunan dan kenikmatan)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ٩\nDua rakaat shalat ke-9',
          'arabic': 'اَلْخَلِيْفَةُ الرَّابِعَةُ سَيِّدُنَا عَلِيُّ بْنُ أَبِيْ طَالِبٍ (كَرَّمَ اللّٰهُ وَجْهَهُ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Al-khalîfatur râbi\'ah sayyidunâ \'Aliyyun-nibnu Abî Thâlibin.\n(Jawaban jamaah: Karrama-Llâhu wajhah)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Khalifah keempat Sayyidina Ali bin Abi Thalib.\n(Semoga Allah memuliakan wajahnya)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'الصلاة ١٠\nDua rakaat shalat ke-10',
          'arabic': 'اٰخِرُ التَّرَاوِيْحِ أَجَرَكُمُ اللّٰهُ (اٰمِيْنَ يَارَبَّ الْعَالَمِيْنَ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Âkhirut tarâwîhi ajarakumullâh.\n(Jawaban jamaah: Âmîn yâ Rabbal \'âlamîn)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Ini adalah penghujung shalat tarawih. Semoga Allah memberi kalian pahala.\n(Semoga Allah mengabulkan, wahai Tuhan semesta alam)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        },
        {
          'subtitle': 'صلاة الوتر\nShalat Witir',
          'arabic': 'صَلُّوْا سُنَّةَ الْوِتْرِ ثَلَاثَ رَكَعَاتٍ جَامِعَةً رَحِمَكُمُ اللّٰهُ (رَحِمَكُمُ اللّٰهُ)\n\nاَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ (اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَيْهِ)',
          'latin': 'Seruan bilal: Shallû sunnatal witri tsalâtsa raka\'âtin jâmi\'atan rahimakumullâh.\n(Jawaban jamaah: Rahimakumullâh)\n\nSeruan bilal: Allâhumma shalli \'alâ sayyidinâ Muhammad(in).\n(Jawaban jamaah: Allâhumma shalli wa sallim \'alaih)',
          'translation': 'Shalatlah sunnah witir tiga rakaat secara berjamaah. Semoga Allah merahmati kalian semua.\n(Semoga Allah merahmati kalian semua)\n\nYa Allah, limpahkanlah rahmat dan takzim kepada Baginda Nabi Muhammad.\n(Ya Allah, limpahkanlah rahmat dan keselamatan kepada beliau)',
        }
      ]
    },
    {
      'title': 'Doa Kamilin Bakda Tarawih',
      'arabic': 'اَللّٰهُمَّ اجْعَلْنَا بِالْإِيْمَانِ كَامِلِيْنَ، وَلِلْفَرَائِضِ مُؤَدِّيْنَ، وَلِلصَّلَاةِ حَافِظِيْنَ، وَلِلزَّكَاةِ فَاعِلِيْنَ، وَلِمَا عِنْدَكَ طَالِبِيْنَ، وَلِعَفْوِكَ رَاجِيْنَ، وَبِالْهُدَى مُتَمَسِّكِيْنَ، وَعَنِ اللَّغْوِ مُعْرِضِيْنَ، وَفِي الدُّنْيَا زَاهِدِيْنَ، وَفِي الْآخِرَةِ رَاغِبِيْنَ، وَبِالْقَضَاءِ رَاضِيْنَ، وَلِلنَّعْمَاءِ شَاكِرِيْنَ، وَعَلَى الْبَلَاءِ صَابِرِيْنَ، وَتَحْتَ لِوَاءِ مُحَمَّدٍ صَلَّى اللّٰهُ عَلَيْهِ وَسَلَّمَ يَوْمَ الْقِيَامَةِ سَائِرِيْنَ، وَعَلَى الْحَوْضِ وَارِدِيْنَ، وَإِلَى الْجَنَّةِ دَاخِلِيْنَ، وَمِنَ النَّارِ نَاجِيْنَ، وَعَلَى سَرِيْرِ الْكَرَامَةِ قَاعِدِيْنَ، وَبِحُوْرِ عِيْنٍ مُتَزَوِّجِيْنَ، وَمِنْ سُنْدُسٍ وَإِسْتَبْرَقٍ وَدِيْبَاجٍ مُتَلَبِّسِيْنَ، وَمِنْ طَعَامِ الْجَنَّةِ آكِلِيْنَ، وَمِنْ لَبَنٍ وَعَسَلٍ مُصَفًّى شَارِبِيْنَ، بِأَكْوَابٍ وَأَبَارِيْقَ وَكَأْسٍ مِنْ مَعِيْنٍ مَعَ الَّذِيْنَ أَنْعَمْتَ عَلَيْهِمْ مِنَ النَّبِيِّيْنَ وَالصِّدِّيْقِيْنَ وَالشُّهَدَاءِ وَالصَّالِحِيْنَ وَحَسُنَ أُولٰئِكَ رَفِيْقًا، ذٰلِكَ الْفَضْلُ مِنَ اللّٰهِ وَكَفَى بِاللّٰهِ عَلِيْمًا، اَللّٰهُمَّ اجْعَلْنَا فِي هٰذِهِ لَيْلَةِ الشَّهْرِ الشَّرِيْفَةِ الْمُبَارَكَةِ مِنَ السُّعَدَاءِ الْمَقْبُوْلِيْنَ، وَلَا تَجْعَلْنَا مِنَ الْأَشْقِيَاءِ الْمَرْدُوْدِيْنَ، وَصَلَّى اللّٰهُ عَلَى سَيِّدِنَا مُحَمَّدٍ وَاٰلِهِ وَصَحْبِهِ أَجْمَعِيْنَ، بِرَحْمَتِكَ يَا أَرْحَمَ الرَّاحِمِيْنَ، وَالْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِيْنَ',
      'latin': 'Allâhummaj\'alnâ bil îmâni kâmilîn. Wa lil farâidli muaddîn. Wa lish-shalâti hâfidhîn. Wa liz-zakâti fâ\'ilîn. Wa lima \'indaka thâlibîn. Wa li \'afwika râjîn. Wa bil-hudâ mutamassikîn. Wa \'anil laghwi mu\'ridlîn. Wa fid-dunyâ zâhidîn. Wa fil \'âkhirati râghibîn. Wa bil-qadlâ\'i râdlîn. Wa lin na\'mâ\'i syâkirîn. Wa \'alal balâ\'i shâbirîn. Wa tahta liwâ\'i muhammadin shallallâhu \'alaihi wasallam yaumal qiyâmati sâ\'irîna wa \'alal haudli wâridîn. Wa ilal jannati dâkhilîn. Wa minan nâri nâjîn. Wa \'alâ sarîril karâmati qâ\'idîn. Wa bi hûrun \'in mutazawwijîn. Wa min sundusin wa istabraqîn wadîbâjin mutalabbisîn. Wa min tha\'âmil jannati âkilîn. Wa min labanin wa \'asalin mushaffan syâribîn. Bi akwâbin wa abârîqa wa ka\'sin min ma\'în. Ma\'al ladzîna an\'amta \'alaihim minan nabiyyîna wash shiddîqîna wasy syuhadâ\'i wash shâlihîna wa hasuna ulâ\'ika rafîqan. Dzâlikal fadl-lu minallâhi wa kafâ billâhi \'alîman. Allâhummaj\'alnâ fî hâdzhihi lailatisy syahrisy syarîfatil mubârakah minas su\'adâ\'il maqbûlîn. Wa lâ taj\'alnâ minal asyqiyâ\'il mardûdîn. Wa shallallâhu \'alâ sayyidinâ muhammadin wa âlihi wa shahbihi ajma\'în. Birahmatika yâ arhamar râhimîn wal hamdulillâhi rabbil \'âlamîn.',
      'translation': 'Yaa Allah, jadikanlah kami orang-orang yang sempurna imannya, yang memenuhi kewajiban-kewajiban, yang memelihara shalat, yang mengeluarkan zakat, yang mencari apa yang ada di sisi-Mu, yang mengharapkan ampunan-Mu, yang berpegang pada petunjuk, yang berpaling dari kebatilan, yang zuhud di dunia, yang menyenangi akhirat, yang ridha dengan qadla-Mu (ketentuan-Mu), yang bersyukur atas nikmat-nikmat-Mu, yang sabar atas segala musibah, yang berada di bawah bendera junjungan kami Nabi Muhammad, pada hari kiamat, yang mengunjungi telaga (Nabi Muhammad), yang masuk ke dalam surga, yang selamat dari api neraka, yang duduk di atas ranjang kemuliaan, yang menikah dengan para bidadari, yang mengenakan berbagai sutra, yang makan makanan surga, yang minum susu dan madu murni dengan gelas, cangkir, dan cawan bersama orang-orang yang Engkau beri nikmat dari kalangan para nabi, shiddiqin, syuhada dan orang-orang shalih. Mereka itulah teman yang terbaik. Itulah keutamaan (anugerah) dari Allah, dan cukuplah bahwa Allah Maha Mengetahui. Ya Allah, jadikanlah kami pada malam yang mulia dan diberkahi ini termasuk orang-orang yang bahagia dan diterima amalnya, dan janganlah Engkau jadikan kami tergolong orang-orang yang celaka dan ditolak amalnya. Semoga Allah mencurahkan rahmat kepada junjungan kami Nabi Muhammad, serta seluruh keluarga dan sahabat beliau. Berkat rahmat-Mu, wahai Yang Paling Penyayang di antara yang penyayang. Segala puji bagi Allah Tuhan semesta alam.',
    },
    {
      'title': 'Niat Shalat Witir',
      'arabic': '',
      'latin': '',
      'translation': '',
      'sections': [
        {
          'subtitle': 'Satu Rakaat',
          'arabic': 'أُصَلِّيْ سُنَّةَ الْوِتْرِ رَكْعَةً مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً (إِمَامًا/مَأْمُوْمًا) لِلّٰهِ تَعَالَى',
          'latin': 'Ushallî sunnatal witri rak\'atan mustaqbilal qiblati adâ\'an (imâman/ma\'mûman) lillâhhi ta\'âlâ.',
          'translation': 'Aku niat shalat sunnah witir satu rakaat menghadap kiblat (sebagai imam/makmum) karena Allah ta\'ala.',
        },
        {
          'subtitle': 'Tiga Rakaat Sekaligus',
          'arabic': 'أُصَلِّيْ سُنَّةَ الْوِتْرِ ثَلَاثَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً (إِمَامًا/مَأْمُوْمًا) لِلّٰهِ تَعَالَى',
          'latin': 'Ushallî sunnatal-witri tsalâtsa raka\'âtin mustaqbilal qiblati adâ\'an (imâman/ma\'mûman) lillâhhi ta\'âlâ.',
          'translation': 'Aku niat shalat sunnah witir tiga rakaat menghadap kiblat (sebagai imam/makmum) karena Allah ta\'ala.',
        },
        {
          'subtitle': 'Ketika Didahului Dua Rakaat',
          'arabic': 'أُصَلِّيْ سُنَّةَ مِنَ الْوِتْرِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً (إِمَامًا/مَأْمُوْمًا) لِلّٰهِ تَعَالَى',
          'latin': 'Ushallî sunnatan minal witri rak\'ataini mustaqbilal qiblati adâ\'an (imâman/ma\'mûman) lillâhhi ta\'âlâ.',
          'translation': 'Aku niat shalat sunnah dua rakaat yang menjadi bagian dari witir, menghadap kiblat (sebagai imam/makmum) karena Allah ta\'ala.',
        }
      ]
    },
    {
      'title': 'Wirid dan Doa Bakda Witir',
      'arabic': '',
      'latin': '',
      'translation': '',
      'sections': [
        {
          'subtitle': '',
          'arabic': 'سُبْحَانَ الْمَلِكِ الْقُدُّوْسِ ٣×',
          'latin': 'Subhânal malikil quddûs. (3x)',
          'translation': '"Mahasuci Tuhan yang kudus," (HR An-Nasa\'i dan Ibnu Majah). (3x)',
        },
        {
          'subtitle': '',
          'arabic': 'سُبُّوْحٌ قُدُّوْسٌ رَبُّنَا وَرَبُّ الْمَلَائِكَةِ وَالرُّوْحِ',
          'latin': 'Subbûhun, quddûsun, rabbunâ wa rabbul malâ\'ikati war rûh.',
          'translation': '"Suci dan qudus Tuhan kami, Tuhan para malaikat dan Jibril," (HR Al-Baihaqi dan Ad-Daruqutni).',
        },
        {
          'subtitle': '',
          'arabic': 'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللّٰهُ، أَسْتَغْفِرُ اللّٰهَ، نَسْأَلُكَ رِضَاكَ وَالْجَنَّةَ وَنَعُوْذُ بِكَ مِنْ سَخَطِكَ وَالنَّارِ ٣×',
          'latin': 'Asyhadu an lâ ilâha illallââh. Astaghfirullâh. Nas\'aluka ridhâka wal jannah, wa na\'ûdzu bika min sakhathika wan nâr. (3x)',
          'translation': 'Aku bersaksi bahwa tiada tuhan selain Allah. Aku memohon ampunan Allah. Kami memohon ridha dan surga-Mu. Kami juga berlindung kepada (rahmat)-Mu dari murka dan neraka-Mu. (3x)',
        },
        {
          'subtitle': '',
          'arabic': 'اَللّٰهُمَّ إِنَّكَ عَفُوٌّ كَرِيْمٌ تُحِبُّ الْعَفْوَ فَاعْفُ عَنَّا ٣×',
          'latin': 'Allâhumma innaka \'afuwwun karîmun tuhibbul \'afwa, fa\'fu \'annâ. (3x)',
          'translation': '"Tuhanku, sungguh Kau maha pengampun lagi pemurah. Kau menyukai ampunan, oleh karenanya ampunilah kami." (3x)',
        },
        {
          'subtitle': '',
          'arabic': 'يَا كَرِيْمُ بِرَحْمَتِكَ يَا أَرْحَمَ الرَّاحِمِيْنَ',
          'latin': 'Yâ karîmu, bi rahmatika yâ arhamar râhimîna.',
          'translation': 'Wahai Dzat yang maha pemurah, (aku memohon) atas berkat rahmat-Mu, wahai Dzat yang paling penyayang dari segenap penyayang.',
        },
        {
          'subtitle': '',
          'arabic': 'اَللّٰهُمَّ إِنَّا نَعُوْذُ بِرِضَاكَ مِنْ سَخَطِكَ وَبِمُعَافَاتِكَ مِنْ عُقُوْبَتِكَ وَنَعُوْذُ بِكَ مِنْكَ لَا نُحْصِيْ ثَنَاءً عَلَيْكَ أَنْتَ كَمَا أَثْنَيْتَ عَلَى نَفْسِكَ',
          'latin': 'Allâhumma inâ na\'ûdzu bi ridhâka min sakhathika, wa bi mu\'âfâtika min \'uqûbatika. Wa na\'ûdzu bika minka, lâ nuhshî tsanâ\'an alayka anta kamâ atsnayta \'alâ nafsika.',
          'translation': '"Tuhanku, kami berlindung kepada ridha-Mu dari murka-Mu dan kepada afiat-Mu dari siksa-Mu. Kami meminta perlindungan-Mu dari murka-Mu. Kami tidak (sanggup) membilang pujian-Mu sebanyak Kau memuji diri-Mu sendiri," (HR Abu Dawud, Tirmidzi, An-Nasa\'i, dan Ibnu Majah).',
        },
        {
          'subtitle': 'الدعاء\nDoa',
          'arabic': 'اَللّٰهُمَّ إِنَّا نَسْأَلُكَ إِيْمَانًا دَائِمًا وَنَسْأَلُكَ قَلْبًا خَاشِعًا وَنَسْأَلُكَ عِلْمًا نَافِعًا وَنَسْأَلُكَ يَقِيْنًا صَادِقًا وَنَسْأَلُكَ عَمَلًا صَالِحًا وَنَسْأَلُكَ دِيْنًا قَيِّمًا وَنَسْأَلُكَ خَيْرًا كَثِيْرًا وَنَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ وَنَسْأَلُكَ تَمَامَ الْعَافِيَةِ وَنَسْأَلُكَ الشُّكْرَ عَلَى الْعَافِيَةِ وَنَسْأَلُكَ الْغِنَى عَنِ النَّاسِ. اَللّٰهُمَّ رَبَّنَا تَقَبَّلْ مِنَّا صَلَاتَنَا وَصِيَامَنَا وَقِيَامَنَا وَتَخَشُّعَنَا وَتَضَرُّعَنَا وَتَعَبُّدَنَا وَتَمِّمْ تَقْصِيْرَنَا يَا اَللّٰهُ يَا أَرْحَمَ الرَّاحِمِيْنَ وَصَلَّى اللّٰهُ عَلَى خَيْرِ خَلْقِهِ سَيِّدِنَا مُحَمَّدٍ وَعَلَى اٰلِهِ وَأَصْحَابِهِ أَجْمَعِيْنَ وَالْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِيْنَ',
          'latin': 'Allâhumma innâ nasaluka îmânan dâiman wa nas-aluka qalban khâsyi\'an wan as-aluka \'ilman nâfi\'an wan as-aluka yaqînan shâdiqan wan as-aluka \'amalan shâlihan wan as-aluka dînan qayyiman wan as-aluka khairan katsîran wan as-aluka-l-\'afwa wal \'âfiyata wan as-aluka tamâmal \'âfiyati wan as-aluka-sy-syukra \'alal \'âfiyati wan as-aluka-l-ghinâ \'anin nâs. Allâhumma rabbanâ taqabbal minnâ shalâtanâ wa shiyâmanâ wa qiyâmanâ wa takhasyu\'anâ wa tadlarru\'anâ wa ta\'abbudanâ wa tammim taqshîranâ. Yâ Allâh yâ arhamar râhimîn wa shallallâhu \'alâ khairi khalqihi sayyidinâ Muhammadin wa \'alâ âlihî wa ash-hâbihî ajma\'în wal hamdulillâhi rabbil \'âlamîn',
          'translation': 'Ya Allah, kami mohon pada-Mu, iman yang langgeng, hati yang khusyuk, ilmu yang bermanfaat, keyakinan yang benar, amal yang saleh, agama yang lurus, kebaikan yang banyak. kami mohon kepada-Mu ampunan dan kesehatan, kesehatan yang sempurna, kami mohon kepada-Mu bersyukur atas karunia kesehatan, kami mohon kepada-Mu kecukupan terhadap sesama manusia. Ya Allah, tuhan kami terimalah dari kami: shalat, puasa, ibadah, kekhusyukan, rendah diri dan ibadah kami, dan sempurnakanlah segala kekurangan kami. Ya Allah, Tuhan yang Maha Pengasih dari segala yang pengasih. Dan semoga kesejahteraan dilimpahkan kepada makhluk-Nya yang terbaik, Nabi Muhammad, demikian pula keluarga dan para sahabatnya secara keseluruhan. Serta segala puji milik Allah Tuhan semesta alam.',
        }
      ]
    },
    {
      'title': 'Doa ketika Sahur',
      'arabic': 'يَرْحَمُ اللّٰهُ الْمُتَسَحِّرِيْنَ',
      'latin': 'Yarhamullâhul mutasahhirîn.',
      'translation': '"Semoga Allah merahmati mereka yang bersahur."',
    },
    {
      'title': 'Bacaan Lailatul Qadar',
      'arabic': 'اَللّٰهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّيْ',
      'latin': 'Allâhumma innaka \'afuwwun tuhibbul \'afwa fa\'fu \'annî',
      'translation': 'Wahai Tuhan, Engkau Maha Pengampun, menyukai orang yang minta ampunan, ampunilah aku.',
    },
    {
      'title': 'Niat Zakat Fitrah',
      'arabic': '',
      'latin': '',
      'translation': '',
      'sections': [
        {
          'subtitle': 'Untuk Diri Sendiri',
          'arabic': 'نَوَيْتُ أَنْ أُخْرِجَ زَكَاةَ الْفِطْرِ عَنْ نَفْسِيْ فَرْضًا لِلّٰهِ تَعَالَى',
          'latin': 'Nawaitu an ukhrija zakâtal fithri \'an nafsî fardlan li-Llâhi ta\'âlâ',
          'translation': 'Aku niat mengeluarkan zakat fitrah untuk diriku sendiri, fardu karena Allah ta\'âlâ.',
        },
        {
          'subtitle': 'Untuk Istri',
          'arabic': 'نَوَيْتُ أَنْ أُخْرِجَ زَكَاةَ الْفِطْرِ عَنْ زَوْجَتِيْ فَرْضًا لِلّٰهِ تَعَالَى',
          'latin': 'Nawaitu an ukhrija zakâtal fithri \'an zaujatî fardlan li-Llâhi ta\'âlâ',
          'translation': 'Aku niat mengeluarkan zakat fitrah untuk istriku, fardu karena Allah ta\'âlâ.',
        },
        {
          'subtitle': 'Untuk Anak Laki-laki',
          'arabic': 'نَوَيْتُ أَنْ أُخْرِجَ زَكَاةَ الْفِطْرِ عَنْ وَلَدِيْ فَرْضًا لِلّٰهِ تَعَالَى',
          'latin': 'Nawaitu an ukhrija zakâtal fithri \'an waladî fardlan li-Llâhi ta\'âlâ',
          'translation': 'Aku niat mengeluarkan zakat fitrah untuk anak laki-lakiku.... (sebutkan nama), fardu karena Allah ta\'âlâ.',
        },
        {
          'subtitle': 'Untuk Anak Perempuan',
          'arabic': 'نَوَيْتُ أَنْ أُخْرِجَ زَكَاةَ الْفِطْرِ عَنْ بِنْتِيْ فَرْضًا لِلّٰهِ تَعَالَى',
          'latin': 'Nawaitu an ukhrija zakâtal fithri \'an bintî fardlan li-Llâhi ta\'âlâ',
          'translation': 'Aku niat mengeluarkan zakat fitrah untuk anak perempuanku.... (sebutkan nama), fardu karena Allah ta\'âlâ.',
        },
        {
          'subtitle': 'Untuk Diri Sendiri dan Keluarga',
          'arabic': 'نَوَيْتُ أَنْ أُخْرِجَ زَكَاةَ الْفِطْرِ عَنِّيْ وَعَنْ جَمِيْعِ مَا يَلْزَمُنِيْ نَفَقَاتُهُمْ شَرْعًا فَرْضًا لِلّٰهِ تَعَالَى',
          'latin': 'Nawaitu an ukhrija zakâtal fithri \'anî wa \'an jamî\'i mâ yalzamunî nafaqâtuhum syar\'an fardlan li-Llâhi ta\'âlâ',
          'translation': 'Aku niat mengeluarkan zakat fitrah untuk diriku dan seluruh orang yang nafkahnya menjadi tanggunganku, fardu karena Allah ta\'âlâ.',
        },
        {
          'subtitle': 'Untuk Orang yang Diwakilkan',
          'arabic': 'نَوَيْتُ أَنْ أُخْرِجَ زَكَاةَ الْفِطْرِ عَنْ (.....) فَرْضًا لِلّٰهِ تَعَالَى',
          'latin': 'Nawaitu an ukhrija zakâtal fithri \'an (......) fardlan li-Llâhi ta\'âlâ',
          'translation': 'Aku niat mengeluarkan zakat fitrah untuk... (sebutkan nama spesifik), fardu karena Allah ta\'âlâ.',
        }
      ]
    },
    {
      'title': 'Doa Menerima Zakat Fitrah',
      'arabic': 'طَهَّرَ اللّٰهُ قَلْبَكَ فِيْ قُلُوْبِ الْأَبْرَارِ وَزَكَّى عَمَلَكَ فِيْ عَمَلِ الْأَخْيَارِ وَصَلَّى عَلَى رُوْحِكَ فِيْ أَرْوَاحِ الشُّهَدَاءِ',
      'latin': 'Thahharallâhu qalbaka fî qulûbil abrâr, wa zakkâ \'amalaka fî \'amalil akhyâr, wa shallâ \'alâ rûhika fî arwâhis syuhadâ\'',
      'translation': 'Semoga Allah menyucikan hatimu ke dalam hati para hamba-Nya yang gemar berbuat kebajikan. Semoga Allah membersihkan amalmu ke dalam amal para hamba-Nya yang terpilih. Semoga Allah melimpahkan kasih sayang untuk rohmu ke dalam roh para hamba-Nya yang syahid.',
    },
    {
      'title': 'Doa Malam Idul Fitri',
      'arabic': 'اَللّٰهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَاٰلِهِ مَصَابِيْحِ الْحِكْمَةِ وَمَوَالِي النِّعْمَةِ، وَمَعَادِنِ الْعِصْمَةِ، وَاعْصِمْنِيْ بِهِمْ مِنْ كُلِّ سُوْءٍ. وَلَا تَأْخُذْنِيْ عَلَى غِرَّةٍ وَلَا عَلَى غَفْلَةٍ، وَلَا تَجْعَلْ عَوَاقِبَ أَمْرِيْ حَسْرَةً وَنَدَامَةً، وَارْضَ عَنِّيْ، فَإِنَّ مَغْفِرَتَكَ لِلظَّالِمِيْنَ، وَأَنَا مِنَ الظَّالِمِيْنَ، اَللّٰهُمَّ اغْفِرْ لِيْ مَا لَا يَضُرُّكَ، وَأَعْطِنِيْ مَا لَا يَنْفَعُكَ، فَإِنَّكَ الْوَاسِعَةُ رَحْمَتُهُ، الْبَدِيْعَةُ حِكْمَتُهُ، فَأَعْطِنِي السَّعَةَ وَالدَّعَةَ، وَالْأَمْنَ وَالصِّحَّةَ وَالشُّكْرَ وَالْمُعَافَاةَ وَالتَّقْوَى، وَأَفْرِغِ الصَّبْرَ وَالصِّدْقَ عَلَيَّ، وَعَلَى أَوْلِيَائِيْ فِيْكَ، وَأَعْطِنِي الْيُسْرَ، وَلَا تَجْعَلْ مَعَهُ الْعُسْرَ، وَأَعِمَّ بِذٰلِكَ أَهْلِيْ وَوَلَدِيْ وَإِخْوَانِيْ فِيْكَ، وَمَنْ وَلَدَنِيْ مِنَ الْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ',
      'latin': 'Allâhumma shalli \'alâ Muhammadin wa âlihi, mashâbîhil hikmati wa mawâlin ni\'amti, wa ma\'âdinil \'ishmati, wa\'shimnî bihim min kulli sû\'in, wa lâ ta\'khudznî \'alâ ghirratin wa lâ \'ala ghaflatin, wa lâ taj\'al \'awâqiba amri hasratan wa nadâmatan, wardlâ \'annî, fa-inna maghfirataka lidh-dhâlimîn, wa anâ minadh dhâlimina, allâhumma ighfirl lî mâ lâ yadlurruka, wa a\'thinî ma la yanfa\'uka, fainnaka al-wâsi\'ata rahmatuhu, al-badî\'ata hikmatuhu, fa a\'thinî as-sa\'ata wad da\'ata, wal amna wash shihhata wasy syukra wal mu\'âfata wattaqwâ, wa afrigh ash-shabra wash shidqa \'alayya, wa \'alâ auliyâi fîka, wa a\'thinî al-yusra, walâ taj\'al ma\'ahu al-\'usrâ, wa a\'imma bidzâlika ahli wa waladî wa ikhwâni fika, wa man waladanî minal muslimîna wal muslimâti wal mu\'minîna wal mu\'minâti',
      'translation': '"Ya Allah limpahkan rahmat ta\'zhim-Mu kepada Nabi Muhammad dan keluarganya, lampu-lampu hikmah, tuan-tuan nikmat, sumber-sumber penjagaan. Jagalah aku dari segala keburukan lantaran mereka, janganlah engkau hukum aku atas kelengahan dan kelalaian, janganlah engkau jadikan akhir urusanku suatu kerugian dan penyesalan, ridhailah aku, sesungguhnya ampunan-Mu untuk orang-orang zalim dan aku termasuk dari mereka, ya Allah ampunilah bagiku dosa yang tidak merugikan-Mu, berilah aku anugerah yang tidak memberi manfaat kepada-Mu, sesungguhnya rahmat-Mu luas, hikmah-Mu indah, berilah aku kelapangan, ketenangan, keamanan, kesehatan, syukur, perlindungan (dari segala penyakit) dan ketakwaan. Tuangkanlah kesabaran dan kejujuran kepadaku, kepada kekasih-kekasihku karenaMu, berilah aku kemudahan dan janganlah jadikan bersamanya kesulitan, liputilah dengan karunia-karunia tersebut kepada keluargaku, anaku, saudar-saudaraku karena-Mu dan para orang tua yang melahirkanku dari kaum muslimin muslimat, serta kaum mukiminin mukminat."',
    },
    {
      'title': 'Lafal Takbiran Idul Fitri',
      'arabic': '',
      'latin': '',
      'translation': '',
      'sections': [
        {
          'subtitle': '',
          'arabic': 'اَللّٰهُ أَكْبَرُ اَللّٰهُ أَكْبَرُ اَللّٰهُ أَكْبَرُ',
          'latin': 'Allâhu akbar, Allâhu akbar, Allâhu akbar.',
          'translation': 'Allah Mahabesar, Allah Mahabesar, Allah Mahabesar.',
        },
        {
          'subtitle': '',
          'arabic': 'لَا إِلٰهَ إِلَّا اللّٰهُ وَاللّٰهُ أَكْبَرُ، اَللّٰهُ أَكْبَرُ وَلِلّٰهِ الْحَمْدُ',
          'latin': 'Lâ ilâha illallâhu wallâhu akbar. Allâhu akbar wa lillâhil hamdu.',
          'translation': 'Tiada tuhan selain Allah. Allah Mahabesar. Segala puji bagi-Nya.',
        },
        {
          'subtitle': '',
          'arabic': 'اَللّٰهُ أَكْبَرُ كَبِيْرًا وَالْحَمْدُ لِلّٰهِ كَثِيْرًا وَسُبْحَانَ اللّٰهِ بُكْرَةً وَأَصِيْلًا لَا إِلٰهَ إِلَّا اللّٰهُ وَلَا نَعْبُدُ إِلَّا إِيَّاهُ مُخْلِصِيْنَ لَهُ الدِّيْنَ وَلَوْ كَرِهَ الْكَافِرُوْنَ',
          'latin': 'Allâhu akbar kabîrâ, walhamdu lillâhi katsîrâ, wa subhânallâhi bukratan wa ashîlâ, lâ ilâha illallâhu wa lâ na\'budu illâ iyyâhu mukhlishîna lahud dîna wa law karihal kâfirûn',
          'translation': 'Allah Mahabesar. Segala puji yang banyak bagi Allah. Maha suci Allah pagi dan sore. Tiada tuhan selain Allah. Kami tidak menyembah kecuali kepada-Nya, memurnikan bagi-Nya sebuah agama meski orang kafir tidak menyukainya.',
        },
        {
          'subtitle': '',
          'arabic': 'لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ صَدَقَ وَعْدَهُ وَنَصَرَ عَبْدَهُ وَأَعَزَّ جُنْدَهُ وَهَزَمَ الْأَحْزَابَ وَحْدَهُ',
          'latin': 'Lâ ilâha illallâhu wahdah, shadaqa wa\'dah, wa nashara \'abdah, wa a-\'azza jundahu wa hazamal ahzâba wahdah,',
          'translation': 'Tiada tuhan selain Allah yang esa, yang menepati janji-Nya, membela hamba-Nya, memuliakan tentara-Nya, dan sendiri memorak-porandakan pasukan musuh',
        },
        {
          'subtitle': '',
          'arabic': 'لَا إِلٰهَ إِلَّا اللّٰهُ وَاللّٰهُ أَكْبَرُ، اَللّٰهُ أَكْبَرُ وَلِلّٰهِ الْحَمْدُ',
          'latin': 'Lâ ilâha illallâhu wallâhu akbar. Allâhu akbar wa lillâhil hamdu.',
          'translation': 'Tiada tuhan selain Allah. Allah Mahabesar. Segala puji bagi-Nya.',
        }
      ]
    },
    {
      'title': 'Niat Shalat Idul Fitri',
      'arabic': '',
      'latin': '',
      'translation': '',
      'sections': [
        {
          'subtitle': 'Sebagai Imam',
          'arabic': 'أُصَلِّيْ سُنَّةً لِعِيْدِ الْفِطْرِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً إِمَامًا لِلّٰهِ تَعَالَى',
          'latin': 'Ushallî sunnatan li \'îdil fithri rak\'atayni mustaqbilal qiblati adâ\'an imâman lillâhi ta\'âlâ',
          'translation': 'Aku menyengaja sembahyang sunnah Idul Fitri dua rakaat dengan menghadap kiblat, tunai sebagai imam karena Allah ta\'ala.',
        },
        {
          'subtitle': 'Sebagai Makmum',
          'arabic': 'أُصَلِّيْ سُنَّةً لِعِيْدِ الْفِطْرِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً مَأْمُوْمًا لِلّٰهِ تَعَالَى',
          'latin': 'Ushallî sunnatan li \'îdil fithri rak\'atayni mustaqbilal qiblati adâ\'an ma\'mûman lillâhi ta\'âlâ.',
          'translation': 'Aku menyengaja sembahyang sunnah Idul Fitri dua rakaat dengan menghadap kiblat, tunai sebagai makmum karena Allah ta\'ala.',
        }
      ]
    },
    {
      'title': 'Bacaan Bilal Shalat Idul Fitri',
      'arabic': '',
      'latin': '',
      'translation': '',
      'sections': [
        {
          'subtitle': 'Bilal Mengajak Shalat Id',
          'arabic': 'صَلُّوْاسُنَّةً لِعِيْدِ الْفِطْرِ رَكْعَتَيْنِ جَامِعَةً رَحِمَكُمُ اللّٰهُ ٢×',
          'latin': 'Shallû sunnata-l-li\'îdil fithri rak\'atauni jâmi\'atan rahimakumullâh (dibaca dua kali)',
          'translation': 'Mari shalat sunnah Idul Fitri dua rakaat secara berjamaah. Semoga Allah merahmati kalian.',
        },
        {
          'subtitle': 'Usai Shalat Id sebelum Khutbah',
          'arabic': 'مَعَاشِرَ الْمُسْلِمِيْنَ وَزُمْرَةَ الْمُؤْمِنِيْنَ رَحِمَكُمُ اللّٰهُ، اِعْلَمُوْا أَنَّ يَوْمَكُمْ هٰذَا يَوْمُ عِيْدِ الْفِطْرِ وَيَوْمُ السُّرُوْرِ وَيَوْمُ الْمَغْفُوْرِ يَوْمٌ أَحَلَّ اللّٰهُ لَكُمْ فِيْهِ الطَّعَامَ وَحَرَّمَ عَلَيْكُمْ فِيْهِ الصِّيَامَ\n\nإِذَا صَعِدَ الْخَطِيْبُ عَلَى الْمِنْبَرِ، أَنْصِتُوْا أَثَابَكُمُ اللّٰهُ، وَاسْمَعُوْا أَجَارَكُمُ اللّٰهُ، وَأَطِيْعُوْا رَحِمَكُمُ اللّٰهُ',
          'latin': 'Ma\'âsyiral muslimîna wa zumratal mu\'minîna rahimakumullâh(u), i\'lamû anna yaumakum hâdzâ yaumu \'îdil fithri wa yaumus surûr wa yaumul maghfûr wa yaumu ahallallâhu lakum fîhi-th tha\'âma wa harrama \'alaikum fîhish shiyâm(a)\n\nIdzâ sha\'idal khathîbu \'alâl minbar, anshitû atsâbakumullâh(u), wasma\'û ajârakumullâh(u), wa athî\'û rahimakumullâh(u)',
          'translation': 'Wahai kaum muslimin dan mukminin (semoga Allah merahmati kalian semua). Ketahuilah bahwa hari ini adalah hari Idul Fitri, hari kegembiraan, hari penuh ampunan, hari dihalalkan bagi kalian makan dan diharamkan bagi kalian puasa.\n\nKetika khatib naik mimbar, bersikaplah tenang dan simaklah baik-baik. Semoga Allah mengganjar kalian dengan pahala. Taatlah kalian (kepada Allah). Semoga Allah merahmati kalian semua.',
        },
        {
          'subtitle': 'Saat Khatib di Mimbar Sebelum Khutbah',
          'arabic': 'اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ، اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا وَمَوْلَانَا مُحَمَّدٍ، اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا وَمَوْلَانَا مُحَمَّدٍ وَعَلَى اٰلِ سَيِّدِنَا مُحَمَّدٍ\n\nاَللّٰهُمَّ قَوِّ الْإِسْلَامَ مِنَ الْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ، وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ، وَانْصُرْهُمْ عَلَى مُعَانِدِي الدِّيْنِ رَبِّ اخْتِمْ لَنَا مِنْكَ بِالْخَيْرِ ، يَـاخَيْرَ النَّاصِرِيْنَ بِرَحْمَتِكَ يَا أَرْحَمَ الرَّاحِمِيْنَ',
          'latin': 'Allâhumma shalli \'alâ sayyidinâ muhammad(in). Allâhumma shalli \'alâ sayyidinâ wa maulânâ muhammad(in). Allâhumma shalli wa sallim \'alâ sayyidinâ wa maulânâ muhammadin wa \'alâ âli sayyidinâ muhammad(in)\n\nAllâhumma qawwil islâma minal muslimîna wal muslimât wal mu\'minîna wal mu\'minât(i), wa-nshurhum \'alâ mu\'ândjid dîn rabbikhtim lanâ minka bil khairi, yâ khairan nâshirîna bi rahmatika yâ arhamar râhimîn',
          'translation': 'Semoga Allah melimpahkan rahmat kepada junjungan kami Muhammad. Semoga Allah melimpahkan rahmat kepada junjungan dan tuan kami Muhammad. Semoga Allah melimpahkan rahmat dan keselamatan kepada junjungan dan tuan kami Muhammad, beserta keluarga junjungan kami Muhammad.\n\nYa Allah kuatkanlah Islam kaum muslimin dan muslimat, kaum mukminin dan mukminat. Tolonglah mereka menghadapi para pendurhaka agama. Ya Tuhan, akhiri hidup kami dengan kebaikan, wahai sebaik-baik Penolong, dengan rahmat-Mu, wahai sebaik-baik Pemberi rahmat.',
        },
        {
          'subtitle': 'Saat Khatib Duduk Usai Ucap Salam',
          'arabic': 'اَللّٰهُ أَكْبَرُ اَللّٰهُ أَكْبَرُ اَللّٰهُ أَكْبَرُ، لَا إِلٰهَ إِلَّا اللّٰهُ وَاللّٰهُ أَكْبَرُ، اَللّٰهُ أَكْبَرُ وَلِلّٰهِ الْحَمْدُ',
          'latin': 'Allâhu akbar, Allâhu akbar, Allâhu akbar. Lâ ilâha illallâhu wallâhu akbar. Allâhu akbar wa lillâhil hamd(u)',
          'translation': 'Allah Mahabesar, Allah Mahabesar, Allah Mahabesar. Tiada tuhan yang patut disembah kecuali Allah. Allahu Mahabesar. Segala puji bagi Allah.',
        },
        {
          'subtitle': 'Saat Khatib Duduk di Antara 2 Khutbah',
          'arabic': 'اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا وَمَوْلَانَا مُحَمَّدٍ وَعَلَى اٰلِ سَيِّدِنَا مُحَمَّدٍ. اَللّٰهُمَّ صَلِّ وَسَلِّمْ، وَزِدْ وَأَنْعِمْ وَتَفَضَّلْ وَبَارِكْ، بِجَلَالِكَ وَكَمَالِكَ عَلَى زَيْنِ عِبَادِكَ وَأَشْرَفِ عِبَادِكَ، سَيِّدِ الْعَرَبِ وَالْعَجَمِ، وَإِمَامِ طَيْبَةَ وَالْحَرَمِ، سَيِّدِنَا وَمَوْلَانَا مُحَمَّدٍ وَعَلَى اٰلِهِ وَصَحْبِهِ وَسَلِّمْ وَرَضِيَ اللّٰهُ تَبَارَكَ وَتَعَالَى عَنْ كُلِّ صَحَابَةِ رَسُوْلِ اللّٰهِ أَجْمَعِيْنَ',
          'latin': 'Allâhumma shalli wa sallim \'alâ sayyidinâ wa maulânâ muhammad(in) wa \'alâ âli sayyidinâ muhammad(in). Allâhumma shalli wa sallim wa zid wa an\'im wa tafadl-dlal wa bârik bi jalâlika wa kamâlika \'alâ zaini \'ibâdika wa asyrafi \'ibâdika sayyidil \'arabi wal \'ajami wa imâmi thaibata wal harami, sayyidinâ wa maulânâ muhammadin wa \'alâ âlihi wa shahbihi wa sallim radliyallâhu tabâraka wa ta\'âlâ \'an kulli shahâbati rasûlillâhi ajma\'în(a)',
          'translation': 'Semoga Allah melimpahkan rahmat dan keselamatan kepada junjungan dan tuan kami Muhammad, juga kepada keluarga junjungan kami Muhammad. Ya Allah, limpahkanlah rahmat dan keselamatan, tambahlah, berilah kenikmatan, anugerahilah keutamaan, karunialah keberkahan lantaran keagungan-Mu dan kesempurnaan-Mu, kepada hamba terbaik dan termulia, tua kaum Arab dan non-Arab, pemimpin Makkah dan Madinah, junjungan dan tuan kami Muhammad. Semoga Allah juga merahmati dan meridhai seluruh sahabat Rasulullah.',
        }
      ]
    },
  ];

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final provinces = await _prayerService.getProvinces();
      setState(() => _provinces = provinces);
      await _loadCities(_selectedProvince);
      await _loadSchedule();
      _startCountdown();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadCities(String province) async {
    try {
      final cities = await _prayerService.getCities(province);
      setState(() {
        _cities = cities;
        if (!_cities.contains(_selectedCity)) {
          _selectedCity = _cities.isNotEmpty ? _cities.first : '';
        }
      });
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _loadSchedule() async {
    setState(() => _isLoading = true);
    try {
      final data = await _prayerService.getMonthlySchedule(
        province: _selectedProvince,
        city: _selectedCity,
        month: _selectedMonth,
        year: _selectedYear,
      );
      setState(() {
        _scheduleData = data;
        _calculateCountdown();
      });
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gagal memuat data: $message'),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _calculateCountdown();
      }
    });
  }

  void _calculateCountdown() {
    if (_scheduleData == null) return;
    final List<dynamic> schedules = _scheduleData!['jadwal'] ?? [];
    if (schedules.isEmpty) return;

    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final tomorrowStr = DateFormat('yyyy-MM-dd').format(now.add(const Duration(days: 1)));

    dynamic todayEntry;
    dynamic tomorrowEntry;

    for (var entry in schedules) {
      final entryDate = entry['tanggal_lengkap'];
      if (entryDate == todayStr) {
        todayEntry = entry;
      } else if (entryDate == tomorrowStr) {
        tomorrowEntry = entry;
      }
    }

    if (todayEntry == null) {
      if (mounted) {
        setState(() {
          _countdownLabel = 'Jadwal Hari Ini Tidak Tersedia';
          _countdownTime = '-- : -- : --';
        });
      }
      return;
    }

    DateTime parseTime(String dateStr, String timeStr) {
      final parts = timeStr.split(':');
      final dateParts = dateStr.split('-');
      return DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
    }

    try {
      final imsakToday = parseTime(todayStr, todayEntry['imsak']);
      final maghribToday = parseTime(todayStr, todayEntry['maghrib']);

      String label = '';
      DateTime targetTime;

      if (now.isBefore(imsakToday)) {
        label = 'Menuju Sahur (Imsak)';
        targetTime = imsakToday;
      } else if (now.isBefore(maghribToday)) {
        label = 'Menuju Buka Puasa (Maghrib)';
        targetTime = maghribToday;
      } else {
        label = 'Menuju Sahur (Imsak) Besok';
        if (tomorrowEntry != null) {
          targetTime = parseTime(tomorrowStr, tomorrowEntry['imsak']);
        } else {
          targetTime = imsakToday.add(const Duration(days: 1));
        }
      }

      final diff = targetTime.difference(now);
      final hours = diff.inHours.toString().padLeft(2, '0');
      final minutes = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');

      if (mounted) {
        setState(() {
          _countdownLabel = label;
          _countdownTime = '$hours : $minutes : $seconds';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _countdownLabel = 'Kesalahan Memformat Waktu';
          _countdownTime = '-- : -- : --';
        });
      }
    }
  }

  void _showSearchPicker({
    required String title,
    required List<String> items,
    required String currentValue,
    required Function(String) onSelected,
  }) {
    String searchQuery = "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredItems = items
                .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryTeal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Cari...",
                        prefixIcon: const Icon(Icons.search, color: primaryTeal),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: filteredItems.isEmpty
                        ? const Center(
                            child: Text(
                              'Tidak ditemukan',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final isSelected = item == currentValue;
                              return ListTile(
                                title: Text(
                                  item,
                                  style: TextStyle(
                                    color: isSelected ? primaryTeal : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle, color: primaryTeal)
                                    : null,
                                onTap: () {
                                  onSelected(item);
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Column(
        children: [
          _buildPremiumHeader(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildImsakiyahTab(),
                _buildDuasTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryTeal, Color(0xFF07382B)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Ramadhan Kareem',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.nightlight_round, color: goldColor, size: 22),
                ],
              ),
              const SizedBox(height: 16),
              // Countdown & Icon Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Image.asset(
                      'assets/images/ramadhan_icon.png',
                      height: 52,
                      width: 52,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.mosque_outlined, color: goldColor, size: 45),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _countdownLabel,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _countdownTime,
                          style: GoogleFonts.outfit(
                            color: goldColor,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Location selectors
              Row(
                children: [
                  Expanded(
                    child: _buildLocationSelector(
                      icon: Icons.location_on,
                      label: 'Provinsi',
                      value: _selectedProvince,
                      onTap: () => _showSearchPicker(
                        title: 'Pilih Provinsi',
                        items: _provinces,
                        currentValue: _selectedProvince,
                        onSelected: (val) {
                          setState(() => _selectedProvince = val);
                          _loadCities(val).then((_) => _loadSchedule());
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildLocationSelector(
                      icon: Icons.map,
                      label: 'Kab/Kota',
                      value: _selectedCity,
                      onTap: () => _showSearchPicker(
                        title: 'Pilih Kabupaten/Kota',
                        items: _cities,
                        currentValue: _selectedCity,
                        onSelected: (val) {
                          setState(() => _selectedCity = val);
                          _loadSchedule();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSelector({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                Icon(icon, color: goldColor, size: 14),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white60, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: primaryTeal,
        unselectedLabelColor: Colors.grey,
        indicatorColor: accentTeal,
        indicatorWeight: 3,
        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
        tabs: const [
          Tab(text: 'Jadwal Imsakiyah'),
          Tab(text: 'Niat & Doa'),
        ],
      ),
    );
  }

  Widget _buildImsakiyahTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: accentTeal),
      );
    }

    if (_scheduleData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat jadwal Imsakiyah',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadSchedule,
              style: ElevatedButton.styleFrom(backgroundColor: primaryTeal),
              child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final List<dynamic> schedules = _scheduleData!['jadwal'] ?? [];
    if (schedules.isEmpty) {
      return const Center(child: Text('Jadwal tidak tersedia'));
    }

    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final day = schedules[index];
        final isToday = day['tanggal_lengkap'] == todayStr;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isToday ? goldColor : Colors.grey.shade100,
              width: isToday ? 2.0 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isToday ? goldColor.withOpacity(0.12) : Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: isToday,
              leading: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isToday ? goldColor : lightTeal,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    day['tanggal'].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.white : primaryTeal,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    '${day['hari']}, ${day['tanggal']} ${_monthNames[_selectedMonth - 1]}',
                    style: TextStyle(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                      color: isToday ? goldColor : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  if (isToday) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: goldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Hari Ini',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCompactTime('Imsak', day['imsak'], isToday),
                    _buildCompactTime('Subuh', day['subuh'], isToday),
                    _buildCompactTime('Buka Puasa', day['maghrib'], isToday),
                  ],
                ),
              ),
              children: [
                const Divider(height: 1, color: Colors.black12, indent: 16, endIndent: 16),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDetailTime('Terbit', day['terbit']),
                      _buildDetailTime('Dhuha', day['dhuha']),
                      _buildDetailTime('Dzuhur', day['dzuhur']),
                      _buildDetailTime('Ashar', day['ashar']),
                      _buildDetailTime('Isya', day['isya']),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactTime(String label, String time, bool isToday) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isToday ? primaryTeal : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailTime(String label, String time) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: primaryTeal,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryTeal : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? primaryTeal : Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : primaryTeal),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuasTab() {
    return Column(
      children: [
        // Horizontal Chips Scroll
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildChip('Kumpulan Doa', Icons.collections_bookmark_outlined, _selectedCategory == 'Kumpulan Doa', () => setState(() => _selectedCategory = 'Kumpulan Doa')),
              const SizedBox(width: 8),
              _buildChip('Artikel Ramadhan', Icons.article_outlined, _selectedCategory == 'Artikel Ramadhan', () => setState(() => _selectedCategory = 'Artikel Ramadhan')),
              const SizedBox(width: 8),
              _buildChip('Khutbah Ramadhan', Icons.menu_book, _selectedCategory == 'Khutbah Ramadhan', () => setState(() => _selectedCategory = 'Khutbah Ramadhan')),
            ],
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Cari',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),

        // List Items
        Expanded(
          child: Builder(
            builder: (context) {
              final listData = _selectedCategory == 'Artikel Ramadhan'
                  ? _artikelMenu
                  : _selectedCategory == 'Khutbah Ramadhan'
                      ? _khutbahMenu
                      : (_selectedCategory == 'Kumpulan Doa' ? _ramadhanMenu : []);

              if (listData.isEmpty) {
                return Center(
                  child: Text(
                    'Belum ada $_selectedCategory',
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: listData.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.shade300,
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final item = listData[index];
                  if (_searchQuery.isNotEmpty &&
                      !item['title']!.toLowerCase().contains(_searchQuery.toLowerCase())) {
                    return const SizedBox.shrink();
                  }
                  
                  return InkWell(
                    onTap: () {
                      if (_selectedCategory == 'Artikel Ramadhan' || _selectedCategory == 'Khutbah Ramadhan') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RamadhanArticlePage(article: item),
                          ),
                        );
                      } else if (_selectedCategory == 'Kumpulan Doa') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RamadhanDetailPage(
                              menuList: _ramadhanMenu,
                              initialIndex: index,
                            ),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 32,
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: primaryTeal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item['title']!,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (_selectedCategory == 'Artikel Ramadhan')
                            const Icon(
                              Icons.menu_book_outlined,
                              size: 16,
                              color: Colors.black54,
                            )
                          else
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.black54,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          ),
        ),
      ],
    );
  }
}
