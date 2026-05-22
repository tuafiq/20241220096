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
                      if (_selectedCategory == 'Artikel Ramadhan') {
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
