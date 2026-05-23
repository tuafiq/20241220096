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

  final List<Map<String, dynamic>> _kultumMenu = [
    {
      'title': 'Kultum Ramadhan: Bangun Kepedulian, Eratkan Ikatan Kerabat',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Bulan Ramadhan tidak melulu soal puasa menahan lapar dan haus. Pun bukan hanya soal menahan hawa nafsu dari kemaksiatan zahir dan batin. Di bulan suci ini, bisa juga kita manfaatkan untuk menumbuhkan dan meningkatkan kepedulian kepada kerabat.\n\nDengan memadukan menahan lapar-haus, mengendalikan hawa nafsu, dan meningkatkan kepedulian terhadap kerabat, ibadah kita akan semakin sempurna di sisi Allah SWT. Pun kualitas kehidupan kita akan semakin meningkat, baik dari sisi kesalehan spiritual maupun kesalehan sosial.\n\nAllah SWT berfirman dalam surat Al-Baqarah ayat 183:',
        },
        {
          'type': 'arabic',
          'content': 'يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوْا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَۙ',
          'latin': '',
          'translation': 'Artinya: "Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa." (QS. Al-Baqarah [2]: 183).',
        },
        {
          'type': 'text',
          'content': 'Ayat ini menegaskan bahwa diwajibkan puasa agar kita senantiasa bertakwa kepada Allah SWT. Tentu banyak sekali cara bertakwa, termasuk peduli terhadap sesama, terutama kepada para kerabat terdekat kita. Hal ini merupakan bagian dari peningkatan ketakwaan seseorang. Dalam konteks kaitan bulan Ramadhan dan kepedulian sosial, Rasulullah SAW bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'عَنِ ابْنِ عَبَّاسٍ قَالَ: كَانَ رَسُولُ اللَّهِ صَلَّى الله عَلَيْهِ وَسَلَّمَ أَجْوَدَ النَّاسِ، وَكَانَ أَجْوَدُ ‌مَا ‌يَكُونُ ‌فِي ‌رَمَضَانَ حِينَ يَلْقَاهُ جِبْرِيلُ، وَكَانَ يَلْقَاهُ فِي كُلِّ لَيْلَةٍ مِنْ رَمَضَانَ فَيُدَارِسُهُ الْقُرْآنَ، فَلَرَسُولُ اللَّهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ أَجْوَدُ بِالْخَيْرِ مِنَ الرِّيحِ الْمُرْسَلَةِ',
          'latin': '',
          'translation': 'Artinya: "Diriwayatkan dari Sahabat Ibnu Abbas RA, ia berkata: \'Rasulullah SAW merupakan manusia yang paling dermawan.\' Sifat dermawannya yang paling menonjol itu tampak ketika bulan suci Ramadhan, saat bertemu dengan malaikat Jibril. Jibril menemui Rasulullah Saw pada setiap malam di bulan tersebut dan mengajarkan beliau Al-Qur\'an. Sungguh kedermawanan Rasulullah terhadap kebaikan itu laksana angin yang berhembus." (HR Imam Bukhari).',
        },
        {
          'type': 'text',
          'content': 'Hadits ini mengisyaratkan bagaimana bulan suci Ramadhan sangat berkaitan erat dengan kepedulian terhadap sesama. Rasulullah SAW yang merupakan manusia paling dermawan dan pada bulan Ramadhan sampai meningkatkan kualitas kedermawanannya. Hal tersebut jelas menunjukkan bahwa bulan Ramadhan adalah momen tepat untuk meningkatkan kepedulian kita terhadap sesama manusia, terutama kepada kerabat terdekat kita.\n\nDi samping itu, dalam hadits lain Rasulullah SAW juga menegaskan pentingnya kepedulian terhadap sesama. Beliau bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'عَنْ أَبِيْ هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ عَنِ النَّبِيِّ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ قَالَ مَنْ نَـفَّسَ عَنْ مُؤْمِنٍ كُـرْبَةً مِنْ كُرَبِ الدُّنْيَا، نَـفَّسَ اللهُ عَنْهُ كُـرْبَةً مِنْ كُـرَبِ يَوْمِ الْقِيَامَةِ، وَمَنْ يَسَّرَ عَلَـى مُـعْسِرٍ، يَسَّـرَ اللهُ عَلَيْهِ فِـي الدُّنْيَا وَالْآخِرَة، وَمَنْ سَتَـرَ مُسْلِمًـا، سَتَـرَهُ اللهُ فِـي الدُّنْيَا وَالْآخِرَةِ ، وَاللهُ فِـي عَوْنِ الْعَبْدِ مَا كَانَ الْعَبْدُ فِي عَوْنِ أَخِيهِ',
          'latin': '',
          'translation': 'Artinya: "Diriwayatkan dari Sahabat Abu Hurairah RA, Nabi Muhammad SAW bersabda: \'Siapa saja yang melapangkan satu kesusahan dunia dari seorang Mukmin, maka Allah melapangkan darinya satu kesusahan di hari kiamat.',
        },
        {
          'type': 'text',
          'content': '"Siapa saja memudahkan urusan orang yang sedang dalam kesulitan, niscaya Allah memudahkan baginya dari kesulitan di dunia dan akhirat. Siapa menutupi aib seorang Muslim, maka Allah akan menutup aibnya di dunia dan akhirat. Allah senantiasa menolong seorang hamba selama hamba tersebut menolong saudaranya." (HR Imam Muslim).\n\nSementara itu, jika kita merujuk pada beberapa literatur kitab klasik, kepedulian terhadap kerabat, misalnya bersedekah kepadanya, melebihi keutamaan kepada orang lain yang bukan kerabat. Imam an-Nawawi dalam salah satu karyanya menulis:',
        },
        {
          'type': 'arabic',
          'content': 'أَجْمَعَتْ الْأُمَّةُ عَلَى أَنَّ الصَّدَقَةَ عَلَى الْأَقَارِبِ أَفْضَلُ مِنْ الْأَجَانِبِ وَالْأَحَادِيثُ فِي الْمَسْأَلَةِ كَثِيرَةٌ مَشْهُورَةٌ',
          'latin': '',
          'translation': 'Artinya: "Ulama sepakat bahwa sedekah kepada sanak kerabat lebih utama daripada sedekah kepada orang lain. Hadits-hadits yang menyebutkan hal tersebut sangat banyak dan masyhur." (Imam an-Nawawi, Al-Majmu\' Syarhul Muhaddzab, [Beirut: Darul Fiqr, t.t.] jilid VI, hal. 238).',
        },
        {
          'type': 'text',
          'content': 'Nilai lebih dari kepedulian terhadap kerabat dibandingkan dengan orang lain non-kerabat ini tidak hanya dalam soal sedekah, tapi setiap hal kebaikan, sebagaimana kelanjutan dari penjelasan Imam an-Nawawi berikut:',
        },
        {
          'type': 'arabic',
          'content': 'ويستحب تخصيص الاقارب على الاجانب بالزكاة حيت يَجُوزُ دَفْعُهَا إلَيْهِمْ كَمَا قُلْنَا فِي صَدَقَةِ التَّطَوُّعِ وَلَا فَرْقَ بَيْنَهُمَا وَهَكَذَا الْكَفَّارَاتُ وَالنُّذُورُ وَالْوَصَايَا وَالْأَوْقَافُ وَسَائِرُ جِهَاتِ الْبِرِّ يُسْتَحَبُّ تَقْدِيمُ الْأَقَارِبِ فِيهَا حَيْثُ يَكُونُونَ بِصِفَةِ الِاسْتِحْقَاقِ وَاَللَّهُ تعالي أَعْلَمُ',
          'latin': '',
          'translation': 'Artinya: "Disunnahkan mengkhususkan para kerabat atas orang lain dalam pengalokasian zakat, yakni kerabat yang boleh diberi zakat, sebagaimana penjelasan yang saya jelaskan dalam bab sedekah sunnah dan tidak ada perbedaan antara keduanya. Begitu juga dalam hal (pengalokasian) kafarat, nazah, wasiat, wakaf, dan seluruh urusan kebaikan, disunnahkan mendahulukan kerabat yang berhak menerimanya. Wallahu Ta\'ala A\'lam," (Imam an-Nawawi/jilid VI, hal. 238—238).',
        },
        {
          'type': 'text',
          'content': 'Dari semua pemaparan di muka bisa dipahami bahwa bulan suci Ramadhan bisa kita manfaatkan sebagai peningkatan kualitas kesalehan spiritual dengan cara berpuasa, menahan haus dan lapar, mengendalikan hawa nafsu yang sifat tercela, memperbanyak amal kebaikan, dan sekaligus meningkatkan kesalehan sosial dengan menumbuhkan dan meningkatkan kepedulian kita terhadap sesama manusia, terutama kepada kerabat terdekat kita.\n\nCara meningkatkannya bagaimana? Cara paling efektif untuk meningkatkan kepedulian terhadap kerabat adalah dengan memulainya. Kita harus memerhatikan dan peka terhadap kerabat yang layak dibantu yang hidup di lingkungan kita, di setiap atau mungkin di satu daerah. Sederhananya, dimulai dengan yang paling memungkinkan untuk kita bantu.\n\nKarena kita sedang di bulan Ramadhan, jangan sampai kita berbuka puasa dengan menu melimpah, tapi ada kerabat kita yang kekurangan makanan untuk berbuka. Perhatikan juga apakah masih ada kerabat kita yang tidak bersahur karena tidak memiliki bahan pokok untuk memasak, tapi di kulkas kita ada bahan yang sampai hampir busuk karena tidak terpakai.\n\nInilah contoh sederhana yang bisa kita implementasikan dari kepedulian terhadap kerabat. Dan kepedulian ini juga bisa diwujudkan dalam bentuk apa pun, tidak harus dalam bentuk makanan saja. Bisa dalam bentuk menghilangkan kesusahan, menutup aib, dan lain-lain sebagaimana dijelaskan dalam hadits di atas.\n\nSemoga pada bulan suci Ramadhan ini, kita bisa memaksimalkan dan memanfaatkan waktu sebaik mungkin sehingga bisa mengamalkan setiap hal yang bisa meningkatkan kualitas kehidupan spiritual maupun sosial. Semoga bermanfaat. Wallahu a\'lam.\n\nSyifaul Qulub Amin, Alumnus PP Nurul Cholil Bangkalan dan Pengajar di PP Putri Al-Masyhuriyah Kebonan Bangkalan.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Kesabaran adalah Jalan Menuju Kemenangan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Dalam menjalani kehidupan, kita sering sekali tersandung oleh pahitnya takdir. Kita dihadapkan dengan kesulitan, kegagalan, dan kehilangan yang membuat kita merasa lemah dan tak berdaya. Namun, putus asa dan menyerah bukanlah solusi. Sebaliknya, kita harus menghadapi kesulitan itu dengan kepala tegak dan hati yang kuat.\n\nDalam Islam, menghadapi kesulitan hidup diistilahkan dengan sabar. Sabar dalam menghadapi pahitnya takdir bukanlah tanda kelemahan, tapi sebaliknya, sabar dalam menghadapi pahitnya takdir merupakan tanda kekuatan sejati. Allah Ta\'ala berfirman:',
        },
        {
          'type': 'arabic',
          'content': 'يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوا اسْتَعِيْنُوْا بِالصَّبْرِ وَالصَّلٰوةِۗ اِنَّ اللّٰهَ مَعَ الصّٰبِرِيْنَ',
          'latin': '',
          'translation': 'Artinya, "Wahai orang-orang yang beriman, mohonlah pertolongan (kepada Allah) dengan sabar dan salat. Sesungguhnya Allah beserta orang-orang yang sabar," (QS. Al-Baqarah. Ayat 153).',
        },
        {
          'type': 'text',
          'content': 'Ayat ini menegaskan bahwa sabar merupakan sarana penolong bagi orang-orang beriman dalam menghadapi setiap cobaan yang sedang dihadapi. Yang artinya sabar memungkinkan kita untuk menerima apa yang telah terjadi, dan mempercayai bahwa Allah SWT memiliki rencana yang lebih baik untuk kita. Dengan sabar, kita dapat mengatasi kesulitan, belajar dari kesalahan, dan tumbuh menjadi pribadi yang lebih kuat dan bijak.\n\nPenggalan ayat terakhir tersebut juga merupakan satu keistimewaan dari Allah Ta\'ala bagi hamba-hamba-Nya yang bersabar. Bahwa Allah akan selalu membersamai orang-orang yang sabar dalam menjalani segala ketentuan yang Allah berikan kepada mereka.\n\nMaka, sabar di sini menjadi salah satu jalan yang paling istimewa untuk mendapat kemenangan sejati, yaitu kebersamaan dengan Tuhan semesta alam yang mengatur seluruh jalan takdir yang kita lalui.\n\nMaka, tidaklah mengherankan apabila Sayyidina Ali bin Abi Thalib R.A pernah mengatakan:',
        },
        {
          'type': 'arabic',
          'content': '‎وَاعْلَمُوا أَنَّ الصَّبْرَ مِنَ الْأُمُورِ بِمَنْزِلَةِ الرَّأْسِ مِنَ الْجَسَدِ فَإِذَا فَارَقَ الرَّأْسُ الْجَسَدَ فَسَدَ الْجَسَدُ، وَإِذَا فَارَقَ الصَّبْرُ الْأُمُورَ فَسَدَتِ الْأُمُورُ',
          'latin': '',
          'translation': 'Artinya, "Ketahuilah bahwa kesabaran atas berbagai urusan (kehidupan) seperti halnya kepala bagi tubuh. Jika kepala terpisah dari tubuh, maka tubuh akan rusak. Begitu pula, jika kesabaran terpisah dari urusan (kehidupan), maka urusan (kehidupan) akan menjadi rusak". (Tanbih Al-Ghafilin halaman 90)',
        },
        {
          'type': 'text',
          'content': 'Maksudnya, kesabaran adalah kunci untuk menjaga kestabilan dan keselarasan mental dalam menjalani kehidupan. Tanpa kesabaran, mental dalam menjalani kehidupan akan menjadi tidak seimbang dan rusak, karena kehidupan ini tidak mungkin selalu sesuai dengan keinginan kita.\n\nMaka, salah satu upaya yang paling efektif untuk membangun mental kita dan generasi selanjutnya adalah dengan mengkaji tentang ilmu akhlak, khususnya sabar, sebab dengan sabar inilah semua hal yang terjadi dalam kehidupan akan dilalui dengan ketenangan dan keyakinan akan berlalunya badai kehidupan.\n\nTidak hanya sebagai kunci menuju kemenangan sejati, orang-orang yang sabar juga dijanjikan pahala yang agung dari Allah Ta\'ala. Hal ini tertuang dalam firman-Nya:',
        },
        {
          'type': 'arabic',
          'content': 'إِنَّمَا يُوَفَّى الصَّابِرُونَ أَجْرَهُمْ بِغَيْرِ حِسَابٍ',
          'latin': '',
          'translation': 'Artinya: "Sesungguhnya orang-orang yang bersabar akan dipenuhi pahala mereka tanpa hitungan."(QS. Az-Zumar. Ayat 10)',
        },
        {
          'type': 'text',
          'content': 'Bayangkan saja, dalam Al-Qur\'an pahala orang-orang yang bersabar diungkapkan dengan "Bighoiri Hisab" yang dalam terjemahan bahasa Indonesia dapat diartikan "tanpa hitungan". Hal ini sejatinya merupakan isyarat bahwa sabar adalah satu sifat yang tidak bisa diukur keutamaannya.\n\nTidak hanya sebagai kunci kemenangan sejati atau pahala yang amat agung yang dijanjikan kepada orang-orang yang bersabar, sikap sabar juga menjadi cerminan seorang hamba yang mendapatkan cinta dari Allah Ta\'ala. Baginda Nabi Muhammad SAW bersabda:',
        },
        {
          'type': 'arabic',
          'content': '‎عِظَمُ الْجَزَاءِ مَعَ عِظَمِ الْبَلَاءِ وَإِنَّ اللَّهَ إِذَا أَحَبَّ قَوْمًا ابْتَلَاهُمْ فَمَنْ رَضِيَ فَلَهُ الرِّضَا وَمَنْ سَخِطَ فَلَهُ السُّخْطُ',
          'latin': '',
          'translation': 'Artinya, "Besarnya pahala sesuai dengan besarnya cobaan, dan sesungguhnya apabila Allah mencintai suatu kaum maka Dia akan menguji mereka. Oleh karena itu, barangsiapa ridha (menerima cobaan tersebut) maka baginya keridhaan, dan barangsiapa murka maka baginya kemurkaan." (HR Ibnu Majah)',
        },
        {
          'type': 'text',
          'content': 'Terlebih saat ini kita berada di bulan suci Ramadhan, bulan yang begitu mulia. Mari kita manfaatkan bulan yang mulia ini, dengan menumbuhkan akhlak yang mulia juga yakni sabar.\n\nAbdul Karim Malik, alumni Al-Falah Ploso Kediri, pengurus LBM PCNU Kabupaten Bekasi.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Lebih Baik Sedikit tapi Istiqamah',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Bulan Ramadhan sebagai bulan istimewa penuh berkah dan ampunan sering kali hanya menjadi euforia sesaat saja. Di awal Ramadhan, semangat ibadah kita menggebu-gebu. Masjid penuh, tadarus Al-Qur\'an terdengar di mana-mana, sedekah mengalir dengan lancar, ibadah sunnah terlaksana dengan lengkap, dan kebaikan-kebaikan lainnya.\n\nNamun, ironisnya, ketika Ramadhan sudah sampai pada pertengahan, semangat itu mulai hilang. Amalan ibadah dan kebaikan yang awalnya terlaksana dengan rutin sudah mulai terlupakan, ibadah sunnah dan sedekah mulai terabaikan, dan semangat tadarus Al-Qur\'an mulai terasa seperti beban sehingga ditinggalkan.\n\nAtau ada juga sebagian orang yang berhasil menjaga konsistensinya selama bulan Ramadhan dalam menjalankan ibadah dan melakukan kebajikan, tetapi setelah Ramadhan selesai? Konsistensi itu tiba-tiba hilang, dan yang tersisa hanyalah kenangan-kenangan yang pernah dilakukan selama bulan puasa.\n\nDalam kondisi seperti inilah, menjadi penting bagi kita untuk kembali membahas hakikat istiqamah dalam beragama. Perlu kita ketahui bahwa istiqamah bukanlah tentang menjaga semangat tinggi di saat-saat tertentu saja, tetapi tentang senantiasa mempertahankan ketaatan dalam kondisi dan keadaan apa pun.\n\nLantas, apa yang akan didapatkan oleh orang-orang yang mampu istiqamah? Allah SWT telah menjanjikan balasan yang sangat istimewa bagi mereka, yaitu surga yang penuh dengan kenikmatan abadi di dalamnya. Hal ini sebagaimana ditegaskan dalam Al-Qur\'an, Allah SWT berfirman:',
        },
        {
          'type': 'arabic',
          'content': 'إِنَّ الَّذِينَ قَالُوا رَبُّنَا اللَّهُ ثُمَّ اسْتَقَامُوا تَتَنَزَّلُ عَلَيْهِمُ الْمَلائِكَةُ أَلَّا تَخَافُوا وَلا تَحْزَنُوا وَأَبْشِرُوا بِالْجَنَّةِ الَّتِي كُنْتُمْ تُوعَدُونَ',
          'latin': '',
          'translation': 'Artinya, "Sesungguhnya orang-orang yang berkata, \'Tuhan kami adalah Allah,\' kemudian tetap (dalam pendiriannya), akan turun malaikat-malaikat kepada mereka (seraya berkata), \'Janganlah kamu takut dan bersedih hati serta bergembiralah dengan (memperoleh) surga yang telah dijanjikan kepadamu\'." (QS. Fushshilat: 30).',
        },
        {
          'type': 'text',
          'content': 'Ayat di atas menjelaskan bahwa orang-orang yang beriman kepada Allah kemudian beristiqamah akan mendapatkan jaminan keamanan dan kebahagiaan dari Allah SWT. Istiqamah secara sederhana dapat diartikan sebagai keteguhan hati dalam beriman dan berislam, serta konsisten dalam menjalankan perintah Allah dan menjauhi larangan-Nya dalam kondisi apa pun.\n\nLantas, apakah istiqamah itu harus diwujudkan dengan perbuatan dan amal yang banyak, sehingga kita harus memaksakan diri untuk melakukan berbagai macam ibadah dan kebaikan sekaligus? Ataukah istiqamah itu bisa diwujudkan dengan amalan-amalan kecil saja, asalkan dilakukan secara terus-menerus dan konsisten? Mari kita bahas.\n\nLebih Baik Sedikit tapi Istiqamah\n\nPerlu kita ketahui bersama bahwa hakikat istiqamah tidak terletak pada sedikit atau banyaknya suatu amal ibadah, melainkan pada konsistensi dalam menjaganya. Dalam Islam, amal yang kecil tidak menjadi hina selama ia dilakukan secara terus-menerus. Sebaliknya, amal yang besar dan banyak bisa kehilangan nilainya jika hanya dilakukan sesaat lalu ditinggalkan. Berkaitan dengan hal ini, Rasulullah SAW bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'أَحَبُّ الأَعْمَالِ إِلَى اللَّهِ تَعَالَى أَدْوَمُهَا وَإِنْ قَلَّ',
          'latin': '',
          'translation': 'Artinya, "Perbuatan baik yang paling dicintai Allah Ta\'ala adalah yang paling konsisten (istiqamah) meskipun sedikit." (HR Muslim).',
        },
        {
          'type': 'text',
          'content': 'Alasan mengapa amal yang dilakukan secara istiqamah itu lebih utama dibandingkan ibadah yang banyak tetapi tidak istiqamah adalah karena dengan amal yang terus dijaga, ketaatan kepada Allah tetap hidup dari hari ke hari. Berbeda dengan amal yang banyak tetapi dilakukan sesekali, sering kali ia justru melelahkan, memberatkan jiwa, dan pada akhirnya ditinggalkan.\n\nSelain itu, amal yang sedikit namun istiqamah akan terus tumbuh, berkembang, dan bertambah nilainya, hingga pada akhirnya ia bisa mengalahkan amal besar yang terputus-putus berkali-kali lipat. Penjelasan ini sebagaimana disampaikan oleh Imam Jalaluddin as-Suyuthi, dalam salah satu karyanya ia berkata:',
        },
        {
          'type': 'arabic',
          'content': 'لِأَنَّ بِدَوَامِ الْقَلِيلِ يَسْتَمِرُّ الطَّاعَةُ بِالذِّكْرِ وَالْمُرَاقَبَةِ وَالْإِخْلَاصِ وَالْإِقْبَالِ عَلَى اللهِ بِخِلَافِ الْكَثِيرِ الشَّاقِّ حَتَّى يَنْمُو الْقَلِيلُ الدَّائِمُ بِحَيْثُ يَزِيدُ عَلَى الْكَثِيرِ الْمُنْقَطِعِ أَضْعَافًا كَثِيرَةً',
          'latin': '',
          'translation': 'Artinya, "Karena dengan terus-menerus melakukan amal yang sedikit, ketaatan akan tetap berlangsung melalui zikir, rasa diawasi oleh Allah (muraqabah), keikhlasan, dan kesungguhan menghadap kepada Allah. Berbeda dengan amal yang banyak namun terasa berat, amalan yang sedikit namun terus-menerus itu akan tumbuh hingga berlipat ganda melebihi amalan yang banyak namun terputus." (Hasyiyatus Suyuthi \'ala Sunan an-Nasai, [Aleppo: Maktabah al-Islamiyyah, 1986 M], jilid II, halaman 42).',
        },
        {
          'type': 'text',
          'content': 'Ada banyak sekali amal kecil yang dilakukan secara rutin dan dapat kita rasakan manfaatnya dalam kehidupan sehari-hari dan dapat membawa dampak yang besar. Misalnya, disiplin membuang sampah pada tempatnya, membayar gaji karyawan tepat waktu tanpa menunda-nunda tanpa alasan yang dibenarkan, selalu tersenyum dan bersikap ramah kepada orang lain, dan masih banyak contoh lainnya.\n\nOleh karena itu, marilah kita tata kembali ibadah kita. Tidak perlu memaksakan diri dengan amalan yang berat dan sulit dipertahankan. Cukup pilih amalan-amalan kecil yang realistis dan mampu kita jaga secara konsisten. Membaca Al-Qur\'an meski hanya beberapa ayat setiap hari, bersedekah meski dengan nominal yang kecil, atau menjaga shalat sunnah meski hanya satu atau dua rakaat, selama itu dilakukan dengan istiqamah, maka nilainya sangat besar di sisi Allah SWT.\n\nDemikianlah kultum Ramadhan tentang keutamaan amal yang sedikit tapi istiqamah. Semoga apa yang telah kita bahas bersama dapat menjadi pengingat bagi kita semua untuk senantiasa menjaga konsistensi dalam beribadah dan berbuat baik, tidak hanya di bulan Ramadhan saja, tetapi juga di bulan-bulan lainnya.\n\nSemoga Allah SWT memberikan kita kekuatan dan kemudahan untuk meraih istiqamah, sehingga kita termasuk ke dalam golongan orang-orang yang dicintai dan diridhai oleh-Nya. Amin ya Rabbal \'alamin.\n\nSunnatullah, Pengajar di Pondok Pesantren Al-Hikmah Darussalam Durjan Kokop Bangkalan Jawa Timur.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Makna Keberkahan Sahur',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Sahur sejatinya adalah salah satu anugerah indah yang dititipkan Allah bagi umat Islam dalam menjalankan ibadah puasa. Lebih dari sekadar aktivitas makan untuk mengisi cadangan energi sebelum berpuasa seharian, sahur merupakan manifestasi kecintaan kita terhadap sunnah Rasulullah SAW.\n\nDengan menyantap hidangan sahur, kita tidak hanya mempersiapkan fisik, tetapi juga menghidupkan anjuran Nabi Muhammad SAW yang sangat menekankan agar keberkahan dalam momentum ini tidak dilewatkan begitu saja.\n\nKeutamaan Waktu Sahur\n\nRasulullah SAW memberikan penekanan yang sangat kuat agar setiap Muslim menyempatkan diri untuk bersahur dan sebisa mungkin tidak mengabaikannya. Hal ini dikarenakan sahur memegang peran ganda dalam ibadah puasa: sebagai penopang stamina fisik agar tetap bugar, sekaligus sebagai wadah bagi turunnya keberkahan Ilahi. Berkaitan dengan pentingnya momentum ini, Nabi Muhammad SAW memberikan pesan melalui sabdanya:',
        },
        {
          'type': 'arabic',
          'content': 'تَسَحَّرُوا فَإِنَّ فِي السُّحُورِ بَرَكَةً',
          'latin': '',
          'translation': 'Artinya: "Sahurlah kalian, karena sesungguhnya dalam sahur itu terdapat keberkahan." (HR. Bukhari Muslim)',
        },
        {
          'type': 'text',
          'content': 'Mengenai keberkahan dalam sahur yang dimaksud dari hadits di atas, Syekh Hasan al-Masyath dalam kitab Is\'afu Ahlil Iman bi Wadza\'ifi Syahri Ramadhan, mengatakan,',
        },
        {
          'type': 'arabic',
          'content': 'وَفِي مَعْنَى كَوْنِهِ بَرَكَةً وُجُوهٌ، مِنْهَا أَنْ يُبَارَكَ فِي الْقَلِيلِ مِنْهُ بِحَيْثُ يَحْصُلُ بِهِ الْإِعَانَةُ عَلَى الصَّوْمِ. وَمِنْهَا أَنَّ الْمُرَادَ بِالْبَرَكَةِ نَفْيُ التَّبِعَةِ وَالْمُحَاسَبَةِ. وَمِنْهَا أَنَّ الْمُرَادَ التَّقَوِّي عَلَى الصِّيَامِ وَغَيْرِهِ مِنْ أَعْمَالِ النَّهَارِ. وَمِنْهَا أَنَّ الْمُرَادَ بِالْبَرَكَةِ الْأُمُورُ الْأُخْرَوِيَّةُ؛ فَإِنَّ إِقَامَةَ السُّنَّةِ تُوجِبُ الْأَجْرَ وَالزِّيَادَةَ',
          'latin': '',
          'translation': 'Artinya: "Mengenai makna bahwa sahur itu mengandung keberkahan, terdapat beberapa sudut pandang (penjelasan), di antaranya: 1) diberikannya keberkahan pada makanan yang sedikit, sehingga makanan tersebut cukup untuk membantu seseorang dalam menjalankan ibadah puasa; 2) ditiadakannya konsekuensi dosa (tabi\'ah) dan hisab (pertanggungjawaban yang memberatkan) atas apa yang dimakan saat sahur; 3) memberikan kekuatan fisik untuk menjalankan puasa serta amal-amal siang hari lainnya; 4) perkara-perkara ukhrawi (akhirat); karena menjalankan sunnah akan mendatangkan pahala dan tambahan kebaikan." (Is\'afu Ahlil Iman bi Wadza\'ifi Syahri Ramadhan, hal. 60-61).',
        },
        {
          'type': 'text',
          'content': 'Dari paparan di atas, dapat kita ketahui bahwa ada beberapa makna mengenai keberkahan sahur, yaitu:\n\nWalhasil, sahur merupakan titik temu yang indah antara pemenuhan kebutuhan fisik dan pendakian derajat spiritual. Di balik aktivitas santap sahur, terdapat hakikat yang lebih dalam: kita tidak sekadar mengonsumsi nutrisi, melainkan sedang memanifestasikan keberkahan melalui hidangan. Ia berperan sebagai benteng yang menjaga stamina raga, sekaligus menjadi wasilah untuk menjemput kasih sayang Allah di waktu dini hari, sebuah fase paling mustajab di mana doa-doa lebih mudah menembus langit. Wallahu a\'lam.\n\nMuhammad Ryan Romadhon, Alumni Ma\'had Aly Al-Iman Bulus, Purworejo, Jawa Tengah.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Keutamaan Tarawih dan Witir',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Sepanjang bulan Ramadhan, umat Islam berbondong-bondong merajut berbagai kebajikan demi menjemput kemuliaan di bulan yang penuh berkah ini. Di antara rangkaian ibadah yang paling dinanti adalah pelaksanaan shalat Tarawih dan Witir yang menghidupkan malam-malam suci.\n\nKeutamaan Shalat Tarawih\n\nShalat Tarawih menempati kedudukan yang sangat istimewa sebagai ibadah sunnah yang sangat ditekankan sepanjang bulan Ramadhan. Ibadah ini membawa janji pengampunan yang luar biasa; setiap sujud dan rukuknya menjadi wasilah bagi terhapusnya dosa-dosa masa lalu. Mengenai keutamaan besar ini, Rasulullah SAW memberikan penegasannya dalam sebuah hadits:',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ قَامَ رَمَضَانَ إيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ',
          'latin': '',
          'translation': 'Artinya, "Barang siapa yang menghidupkan malam Ramadhan dengan iman dan ikhlas (karena Allah ta\'ala) maka diampuni dosa-dosanya yang telah berlalu." (HR Muslim).',
        },
        {
          'type': 'text',
          'content': 'Mengacu pada penjelasan Imam An-Nawawi, beliau menegaskan bahwa terminologi \'menghidupkan malam Ramadhan\' dalam hadis riwayat Imam Muslim tersebut secara spesifik merujuk pada pelaksanaan Shalat Tarawih. Dalam kitabnya, Imam An-Nawawi menguraikan:',
        },
        {
          'type': 'arabic',
          'content': 'وَالْمُرَادُ بِقِيَامِ رَمَضَانَ صَلاَةُ التَّرَاوِيْحِ، وَاتَّفَقَ الْعُلَمَاءُ عَلىَ اسْتِحْبَابِهَا',
          'latin': '',
          'translation': 'Artinya, "Yang dimaksud dengan menghidupkan malam Ramadhan (qiyam Ramadhan) adalah shalat Tarawih. Para ulama telah sepakat tentang kesunnahannya." (Syarhun Nawawi \'alal Muslim, [Beirut, Daru Ihyait Turats: tt], jilid VI, halaman 39).',
        },
        {
          'type': 'text',
          'content': 'Para ulama memiliki pandangan yang berbeda mengenai cakupan dosa yang diampuni dalam hadits tersebut, sebagaimana dinamika ikhtilaf yang kerap muncul pada teks-teks serupa. Imam al-Haramain berpendapat bahwa pengampunan tersebut secara spesifik menyasar dosa-dosa kecil, mengingat dosa besar memerlukan mekanisme tobat khusus untuk dapat terhapuskan.\n\nDi sisi lain, Imam Ibnu al-Mundzir menawarkan perspektif yang lebih luas; beliau memandang redaksi \'mâ\' (dosa) sebagai bentuk lafaz \'âm (terminologi umum) yang menyapu bersih segala jenis dosa, baik itu kesalahan kecil maupun dosa besar.\n\nImam Syamsuddin Ar-Ramli mengatakan:',
        },
        {
          'type': 'arabic',
          'content': 'قَالَ الْإِمَامُ: (وَالْمُكَفَّرُ الصَّغَائِرُ دُونَ الْكَبَائِرِ) . قَالَ صَاحِبُ الذَّخَائِرِ: وَهَذَا مِنْهُ تَحَكُّمٌ يَحْتَاجُ إلَى دَلِيلٍ وَالْحَدِيثُ عَامٌّ وَفَضْلُ اللَّهِ وَاسِعٌ لَا يُحْجَرُ. قَالَ ابْنُ الْمُنْذِرِ فِي قَوْلِهِ - ﷺ - «مَنْ قَامَ رَمَضَانَ إيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ»: هَذَا قَوْلٌ عَامٌّ يُرْجَى أَنَّهُ يُغْفَرُ لَهُ جَمِيعُ ذُنُوبِهِ صَغِيرُهَا وَكَبِيرُهَا.',
          'latin': '',
          'translation': 'Artinya: "Imam (Al-Haramain) berpendapat: \'(Yang dihapuskan) adalah dosa-dosa kecil, bukan dosa besar\'. Namun, penulis kitab Adz-Dzakha\'ir menyanggah: \'Pendapat ini adalah klaim sepihak (tahakkum) yang butuh dalil, padahal haditsnya bersifat umum dan karunia Allah itu luas, tidak terbatas\'.',
        },
        {
          'type': 'text',
          'content': 'Ibnu Mundzir juga berkomentar mengenai sabda Nabi ﷺ (Barangsiapa shalat malam di bulan Ramadhan karena iman dan mengharap pahala, maka diampuni dosa-dosanya yang telah lalu): \'Ini adalah pernyataan umum, sehingga diharapkan (dengan amal tersebut) seluruh dosanya diampuni, baik yang kecil maupun yang besar\'." (Nihayatul Muhtaj, [Beirut, Darul Fikr: 1404 H], jilid. III, hal. 206).\n\nKeutamaan Shalat Witir\n\nMelengkapi keindahan malam Ramadhan, pengerjaan Shalat Witir juga menjadi amalan yang sangat ditekankan bagi setiap Muslim. Mengenai keistimewaan Shalat Witir, Rasulullah SAW memberikan gambaran yang sangat memukau bagi seluruh umat manusia.\n\nBeliau menegaskan bahwa shalat sunnah ini memiliki nilai yang sangat agung di hadapan Allah SWT, bahkan melampaui kemewahan unta merah, simbol harta paling prestisius dan tak ternilai pada zaman tersebut. Untuk memahami betapa berharganya posisi Witir dalam timbangan amal, mari kita renungkan sabda Baginda Nabi SAW berikut ini:',
        },
        {
          'type': 'arabic',
          'content': 'إِنَّ اللَّهَ قَدْ أَمَدَّكُمْ بِصَلَاةٍ هِيَ خَيْرٌ لَكُمْ مِنْ حُمْرِ النَّعَمِ: الْوِتْرُ، جَعَلَهُ اللَّهُ لَكُمْ فِيمَا بَيْنَ صَلَاةِ الْعِشَاءِ إِلَىٰ أَنْ يَطْلُعَ الْفَجْرُ',
          'latin': '',
          'translation': 'Artinya, "Sesungguhnya Allah telah memberi kalian suatu shalat yang lebih baik bagi kalian daripada unta merah, yaitu Shalat Witir. Allah menjadikannya untuk kalian antara waktu shalat Isya hingga terbit fajar." (HR Ahmad dan Abu Dawud).',
        },
        {
          'type': 'text',
          'content': 'Imam Ash-Shan\'ani dalam kitabnya, At-Tanwir Syarah Al-Jami\' Ash-Shaghir memberikan interpretasi mengenai hadits tersebut sebagai berikut,',
        },
        {
          'type': 'arabic',
          'content': 'فَإِنَّ الْعَرَبَ كَانَتْ تُحِبُّ حُمْرَ النَّعَمِ وَتَرَاهَا أَشْرَفَ مَا يُعْطَى',
          'latin': '',
          'translation': 'Artinya: "Sebab orang-orang Arab dahulu sangat menyukai unta merah dan menganggapnya sebagai pemberian yang paling mulia/berharga." (At-Tanwir Syarah Al-Jami\' Ash-Shaghir , [Riyadh, Maktabah Darussalam: 1432 H], jilid. III, hal. 317).',
        },
        {
          'type': 'text',
          'content': 'Dari keterangan tersebut, kita dapat mengetahui bahwa pada zaman Rasulullah SAW, unta merah bukan sekadar hewan ternak, melainkan simbol kemakmuran tertinggi dan harta yang paling didambakan.\n\nMelalui perumpamaan yang sangat kuat ini, Baginda Nabi ingin menyentuh kesadaran kita bahwa Shalat Witir memiliki nilai intrinsik yang jauh melampaui segala kemewahan duniawi. Terlebih di bulan Ramadhan, saat setiap ketaatan mendapat apresiasi pahala yang berlipat ganda, Witir bertransformasi menjadi investasi akhirat yang tak ternilai harganya.\n\nDari paparan di atas, dapat kita simpulkan bahwa menunaikan kedua shalat ini bukan sekadar rutinitas ibadah fisik semata, melainkan sebuah upaya untuk meniupkan ruh ke dalam malam-malam Ramadhan.\n\nDengan mengerjakannya, kita tidak hanya sedang memenuhi kewajiban sunnah, tetapi juga sedang merawat nyala spiritual agar malam-malam suci ini tetap hidup dan penuh makna di hadapan Sang Pencipta, sehingga kita akan mendapatkan ampunan-Nya seraya menyiapkan investasi akhirat yang tak ternilai harganya. Wallahu a\'lam.\n\nMuhammad Ryan Romadhon, Alumni Ma\'had Aly Al-Iman Bulus, Purworejo, Jawa Tengah.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Puasa dan Spirit Perlawanan terhadap Korupsi',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Korupsi merupakan tindakan kriminal yang dampaknya sangat merugikan bagi orang banyak. tidak hanya menyangkut soal hak yang dirampas, korupsi juga dapat menimbulkan ketidakadilan sosial yang masif, meningkatkan kemiskinan dan kesenjangan serta merusak masa depan suatu bangsa. Karenanya, korupsi dapat dikategorikan sebagai kejahatan luar biasa, baik dari sudut pandang negara maupun agama, yang harus kita perangi bersama.\n\nUpaya pencegahan dan pemberantasan sudah atau sedang dilakukan. Namun, kita perlu memahami bahwa sumber dari tindakan korupsi, begitu pula kejahatan yang lain, adalah nafsu. Orang-orang melakukan korupsi karena ia terdorong oleh keinginan untuk memuaskan hawa nafsu. Sehingga untuk mencerabut mental korupsi dalam diri adalah dengan menempa dan mendidik hawa nafsu.\n\nDi sinilah peran agama. Ia mengajarkan kepada manusia untuk mengendalikan hawa nafsu agar tidak terjerumus dalam tindakan nista yang dapat merugikan diri sendiri dan orang lain. Upaya mengendalikan nafsu adalah jihad yang terbesar, sehingga perang melawan korupsi juga adalah bagian dari perjuangan keagamaan. Dalam Islam sendiri, salah satu ajaran yang tujuannya adalah untuk menempa hawa nafsu adalah puasa.\n\nHakikat Ibadah Puasa\n\nSebagai salah satu rukun Islam, ibadah puasa menempati posisi yang sangat penting dalam keberislaman seseorang. Ia menjadi salah satu representasi dari ketundukan dan kepatuhan seorang hamba kepada tuhannya. Bahkan, dapat dikatakan bahwa puasa merupakan ibadah spesial karena merupakan medan rahasia yang hanya Allah dan hamba tersebutlah yang tahu.\n\nNamun, puasa bukan hanya tentang menahan lapar dan dahaga karena menjalankan perintah Allah semata. Lebih dari itu, ibadah puasa juga mengandung tujuan untuk menciptakan tenggang rasa dan empati kepada sesama. Ketika kita menahan rasa lapar dan dahaga selama seharian, di saat itulah kita dituntut untuk merasakan kondisi saudara-saudara kita yang sering dilanda kelaparan, dan kemudian akan tercipta perasaan empati yang berujung pada tindakan untuk menyejahterakan kehidupan sosial.\n\nPuasa dan Misi Menciptakan Manusia Bertakwa\n\nIbadah puasa diproyeksikan untuk menciptakan manusia-manusia yang bukan hanya saleh secara ritual, tapi juga saleh secara sosial. Inilah makna dari takwa yang menjadi tujuan utama dari disyariatkannya ibadah puasa. Sebab ketakwaan seseorang belum sempurna apabila ia hanya rajin melakukan ibadah ritual saja, tetapi kerap kali melakukan tindakan-tindakan yang merugikan dan menyakiti orang lain.\n\nDalam Q.S. Al-Baqarah ayat 183, Allah SWT berfirman,',
        },
        {
          'type': 'arabic',
          'content': 'يَاأَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ',
          'latin': '',
          'translation': 'Artinya, "Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa." (Q.S. Al-Baqarah [02]: 183)',
        },
        {
          'type': 'text',
          'content': 'Dalam kalimat terakhir dalam ayat di atas, Allah SWT menegaskan bahwa kewajiban puasa bertujuan untuk menciptakan manusia-manusia yang bertakwa. Imam Fakhruddin al-Razi dalam kitab tafsirnya menjelaskan bagaimana korelasi antara takwa dengan ibadah puasa. Beliau mengatakan:',
        },
        {
          'type': 'arabic',
          'content': 'أنه سبحانه بين بهذا الكلام أن الصوم يورث التقوى لما فيه من انكسار الشهوة وانقماع الهوى فإنه يردع عن الأشر والبطر والفواحش ويهون لذات الدنيا ورئاستها، وذلك لأن الصوم يكسر شهوة البطن والفرج، وإنما يسعى الناس لهذين، كما قيل في المثل السائر: المرء يسعى لعارية بطنه وفرجه، فمن أكثر الصوم هان عليه أمر هذين وخفت عليه مؤنتهما، فكان ذلك رادعا له عن ارتكاب المحارم والفواحش، ومهونا عليه أمر الرياسة في الدنيا وذلك جامع لأسباب التقوى',
          'latin': '',
          'translation': 'Artinya: "Dalam firman tersebut, Allah SWT menjelaskan bahwa puasa dapat melahirkan ketakwaan, karena puasa dapat melemahkan syahwat dan menundukkan hawa nafsu. Puasa mencegah sikap angkuh, sombong, dan perbuatan keji, serta menjadikan kenikmatan dunia dan ambisi terhadapnya terasa remeh. Hal itu karena puasa melemahkan syahwat perut dan kemaluan yang memang menjadi tujuan utama setiap upaya yang dilakukan manusia pada umumnya. Sebagaimana dikatakan dalam peribahasa yang masyhur: \'Seseorang berjuang demi kebutuhan perut dan kemaluannya.\'',
        },
        {
          'type': 'text',
          'content': 'Maka siapa yang banyak berpuasa, akan menjadi ringan baginya urusan kedua hal itu dan berkurang bebannya. Hal itu dapat menjadi penghalang baginya untuk melakukan hal-hal yang haram dan perbuatan keji, serta memudahkan baginya untuk tidak terobsesi pada kepemimpinan dan kedudukan duniawi. Semua itu merupakan sebab-sebab ketakwaan." (Fakhruddin ar-Razi, Mafatihul Ghaib, [Beirut: Dar ihyaut Turats al-\'Arabi, 1420 H.], juz V, hal. 240)\n\nPenjelasan di atas menunjukkan bahwa puasa merupakan sarana yang tepat untuk mendidik nafsu dan keserakahan yang sering kali menjadi sumber tindakan korupsi. Puasa bukan hanya tentang menahan makan dan minum seharian, tetapi ia juga melatih lidah agar tidak membicarakan hal-hal yang haram, melatih telinga untuk tidak mendengarkan pembicaraan yang dilarang, melatih tangan untuk tidak mengambil sesuatu yang bukan haknya dan melatih seluruh anggota badan untuk tidak melakukan tindakan-tindakan yang dilarang agama.\n\nPuasa Sebagai Pendidikan Karakter\n\nDalam Kitab Lathaiful Ma\'arif, dijelaskan bahwa orang yang masih sering melakukan maksiat, melakukan tindakan semena-mena dan mengambil hak orang lain, maka puasanya sia-sia. Sebab, puasa yang sempurna adalah ketika ia mampu menahan diri bukan hanya dari hal-hal yang membatalkan puasa secara zahir, tetapi juga meninggalkan perkara-perkara haram yang dapat menghilangkan pahala puasa.\n\nImam Ibnu Rajab al-Hanbali berkata',
        },
        {
          'type': 'arabic',
          'content': 'واعلم أنه لا يتم التقرب إلى الله تعالى بترك هذه الشهوات المباحة في غير حالة الصيام إلا بعد التقرب إليه بترك ما حرم الله في كل حال من الكذب والظلم والعدوان على الناس في دمائهم وأموالهم وأعراضهم',
          'latin': '',
          'translation': 'Artinya: "Ketahuilah bahwa upaya untuk mendekatkan diri kepada Allah dengan meninggalkan syahwat-syahwat yang mubah di luar keadaan berpuasa tidak akan sempurna kecuali setelah terlebih dahulu mendekatkan diri kepada-Nya dengan cara meninggalkan segala yang diharamkan dalam setiap keadaan, seperti dusta, berbuat zalim, dan tindakan melampaui batas terhadap manusia dalam darah (jiwa), harta, dan kehormatan mereka." (Ibnu Rajab al-Hanbali, Lathaiful Ma\'arif, [t.t.: Dar Ibn Hazm, 2002], hal. 155)',
        },
        {
          'type': 'text',
          'content': 'Maka dari itu, ibadah puasa merupakan sarana yang tepat untuk memperbaiki diri dan tatanan hidup berbangsa dan bernegara. Orang yang menjalankan ibadah puasa dengan baik dan benar akan menjadi individu yang saleh secara ritual maupun sosial. Orang yang mampu meresapi makna puasa tidak mengambil yang bukan hak miliknya, tidak menyalahgunakan waktu kerja, tidak memanipulasi laporan, dan akan selalu menjaga amanah sekecil apa pun.\n\nMuhammad Zainul Mujahid, Alumnus Ma\'had Aly Salafiyah Syafi\'iyah Situbondo, kini mengabdi di Pondok Pesantren Manhalul Ma\'arif Lombok Tengah.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Menjaga Lisan, Menjaga Keberkahan Puasa',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Alhamdulillah, hingga saat ini, semoga kita senantiasa masih diberikan kekuatan dan kemudahan oleh Allah SWT untuk menjalankan berbagai ibadah di bulan Ramadhan ini. Semoga dengan kita melaksanakan perintah ibadah wajib berpuasa ini, dapat menjadikan kita termasuk ke dalam orang-orang yang bertakwa, sebagaimana firman Allah SWT di dalam Al-Qur\'an:',
        },
        {
          'type': 'arabic',
          'content': 'يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ',
          'latin': '',
          'translation': 'Artinya, "Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa." (QS. Al-Baqarah: 183).',
        },
        {
          'type': 'text',
          'content': 'Ketakwaan ini hanya dapat terwujud dengan menjalankan perintah Allah dan menjauhi larangannya. Menjalankan perintah ibadah puasa di bulan Ramadhan, menjadi salah satu upaya kita untuk meraih predikat ketakwaan ini.\n\nPada saat menjalankan ibadah puasa, tentu tidak hanya perkara rukun atau wajib yang perlu kita perhatikan, tetapi termasuk juga di dalamnya kesunnahan serta hal-hal yang akan menjaga keberkahan puasa kita. Salah satu hal yang penting yang dapat menjaga keberkahan puasa kita, yakni menjaga lisan.\n\nPerintah untuk menjaga lisan ini sebetulnya tidak hanya terbatas pada saat kita sedang berpuasa, tetapi mestinya dilakukan pada saat kapan saja. Nabi Muhammad SAW bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ كَانَ يُؤْمِنُ بِاللّٰه وَالْيَوْمِ الْآخِرِ فَلْيَقُلْ خَيْرًا أَوْلِيَصْمُتْ',
          'latin': '',
          'translation': 'Artinya, "Barangsiapa yang beriman kepada Allah dan Hari Akhir, maka hendaklah dia berkata baik atau diam." (HR. Al-Bukhari dan Muslim)',
        },
        {
          'type': 'text',
          'content': 'Sedangkan di dalam konteks berpuasa, orang yang menjaga lisan akan mendapat keberkahan serta terhindar daripada beberapa perkara yang dapat menggugurkan pahala puasa. Rasulullah SAW bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'خَمْسٌ يُفْطِرْنَ الصَّائِمَ: الْغِيْبَةُ، وَالنَّمِيْمَةُ، وَالْكَذِبُ، وَالنَّظَرُ بِالشَّهْوَةِ، وَالْيَمِيْنُ الْكَاذِبَةُ',
          'latin': '',
          'translation': 'Artinya: "Lima hal yang bisa menggugurkan pahala orang berpuasa; membicarakan orang lain, mengadu domba, berbohong, melihat dengan syahwat, dan sumpah palsu." (HR Ad-Dailami)',
        },
        {
          'type': 'text',
          'content': 'Jangan sampai pahala ibadah puasa kita menjadi gugur, hanya karena kita tidak mampu menjaga lisan. Lebih dari itu, tentu juga akan mendapatkan balasan dosa dari kejelekan-kejelekan yang keluar dari lisan, seperti membicarakan orang lain, berbohong, dan lain sebagainya.\n\nLantas bagaimana agar kita terhindar dari perkara-perkara tidak baik dari lisan kita? Tentu cara terbaik adalah dengan menyibukkan lisan kita dengan berbagai hal kebaikan, seperti membaca Al-Qur\'an, berdzikir, berdoa, dan lain sebagainya. Dalam istilah lain, kita pergunakan lisan sesuai dengan tujuan Allah menciptakan lisan. Hal tersebut diterangkan oleh Imam Al-Ghazali dalam kitab Bidayatul Hidayah:',
        },
        {
          'type': 'arabic',
          'content': 'وَاَمَّا اللِّسَانُ فَإِنَّمَا خُلِقَ لَكَ لِتُكَثِّرَ بِهٖ ذِكْرَ اللّٰهِ تَعَالَى وَتِلَاوَةَ كِتَابِهِ ... الخ',
          'latin': '',
          'translation': 'Artinya, "Adapun lisan, sesungguhnya diciptakan untukmu (agar digunakan) untuk memperbanyak berdzikir kepada Allah SWT, membaca kitab Allah (Al-Qur\'an) dan lain-lain... "  (Al-Imam Abu Hamid Muhammad bin Muhammad al-Ghazali, Bidayatul Hidayah, [Beirut, Darul Minhaj: 2004 M/1425 H], hal 180-181)',
        },
        {
          'type': 'text',
          'content': 'Sesuai dengan keterangan dari Imam Al-Ghazali tersebut, kita dapat mempergunakan lisan untuk berbagai kebaikan. Pertama, memperbanyak dzikir, ingat kepada Allah SWT. Hal ini merupakan bentuk kita bersyukur kepada-Nya yang telah memberikan begitu banyak nikmat.\n\nBanyaknya menyebut asma-Nya dan mengingat-Nya dengan berdzikir juga merupakan wujud cinta kita kepada-Nya. Sebab salah satu tanda dari mencintai, adalah dengan semakin mengingat atau menyebut yang dicintai.\n\nKedua, dengan memperbanyak membaca Al-Qur\'an. Hal ini penting untuk dapat menuntun kita ke jalan agama Allah SWT, yakni agama Islam. Membaca Al-Qur\'an juga memberikan kita begitu banyak pahala, meskipun kita tidak memahami kandungan dari ayat-ayat yang kita baca. Memperbanyak membaca Al-Qur\'an juga akan memberikan kita syafaat kelak di hari kiamat.\n\nPada bulan Ramadhan, dengan kita membaca, mempelajari, dan mengajarkan Al-Qur\'an akan menambah pahala serta meneladani apa yang dilakukan oleh Rasulullah SAW. Sebagaimana diterangkan di dalam hadits riwayat Ibnu \'Abbas RA:',
        },
        {
          'type': 'arabic',
          'content': 'عَنْ ابْنِ عَبَّاسٍ قَالَ كَانَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ أَجْوَدَ النَّاسِ وَكَانَ أَجْوَدُ مَا يَكُونُ فِي رَمَضَانَ حِينَ يَلْقَاهُ جِبْرِيلُ وَكَانَ يَلْقَاهُ فِي كُلِّ لَيْلَةٍ مِنْ رَمَضَانَ فَيُدَارِسُهُ الْقُرْآنَ فَلَرَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ أَجْوَدُ بِالْخَيْرِ مِنْ الرِّيحِ الْمُرْسَلَةِ',
          'latin': '',
          'translation': 'Artinya, "Dari Ibnu Abbas berkata: Rasulullah SAW adalah manusia yang paling lembut terutama pada bulan Ramadhan ketika malaikat Jibril as menemuinya, dan Jibril mendatanginya setiap malam di bulan Ramadhan, di mana Jibril mengajarkannya Al-Qur\'an. Sungguh Rasulullah saw orang yang paling lembut daripada angin yang berhembus," (HR Bukhari).',
        },
        {
          'type': 'text',
          'content': 'Ketiga, memberikan petunjuk bagi makhluk Allah SWT mengenai agamanya yang benar, yang dijalankan oleh Rasulullah dan para sahabatnya, yakni agama Islam.\n\nKeempat, kita perlu memenuhi kebutuhan agama dan kebutuhan dunia secara seimbang. Artinya, kita belajar dan melakukan urusan dunia sebagai sarana untuk menunjang ibadah kepada Allah. Termasuk dalam hal pekerjaan, kita bekerja untuk mendapatkan rezeki dan memenuhi kebutuhan hidup, agar tubuh kita kuat dan mampu menjalankan ibadah dengan baik.\n\nJika lisan tidak digunakan untuk selain empat hal tersebut, maka tidak ada pilihan lain kecuali diam. Sebab jika lisan tidak digunakan sesuai dengan tujuan penciptaannya, maka hal tersebut merupakan bentuk kufur nikmat.\n\nTerlebih jika lisan kita justru digunakan untuk kejelekan seperti berdusta. Nabi Muhammad SAW bersabda dalam sebuah hadits:',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ لَمْ يَدَعْ قَوْلَ الزُّورِ وَالْعَمَلَ بِهِ فَلَيْسَ لِلَّهِ حَاجَةٌ فِى أَنْ يَدَعَ طَعَامَهُ وَشَرَابَهُ',
          'latin': '',
          'translation': 'Artinya, "Siapa yang tidak meninggalkan perkataan dusta malah mengamalkannya, maka Allah tidak butuh dari rasa lapar dan haus yang dia tahan." (HR. Bukhari)',
        },
        {
          'type': 'text',
          'content': 'Oleh karena itu, marilah kita senantiasa menjaga lisan kita dari perkara-perkara yang dibenci oleh Allah, sebaliknya, kita pergunakan lisan kita untuk hal-hal yang dicintai oleh Allah SWT. Terlebih di bulan Ramadhan ini, agar ibadah puasa yang kita laksanakan menjadi semakin berkah dan sempurna.\n\nDemikianlah kultum Ramadhan tentang menjaga lisan, menjaga keberkahan puasa. Semoga kita dapat mengamalkannya. Amin ya Rabbal \'alamin.\n\nAjie Najmuddin, Pengurus MWCNU Banyudono Boyolali.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Menjaga Mata, Menjaga Pahala Puasa',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Puasa sering kali kita maknai secara sempit hanya sebagai aktivitas "pindah jam makan". Jika biasanya aktivitas makan dilakukan di siang hari, saat puasa berpindah menjadi malam hari. Selebihnya, tidak ada usaha untuk menjaga pancaindra, terutama mata, dari memandang hal-hal yang tidak pantas dan mengandung kemaksiatan.\n\nPadahal, jika kita merujuk pada klasifikasi Hujjatul Islam al-Ghazali dalam kitab Ihya\' Ulumiddin (Semarang: Karya Thaha Putra, t.th) juz I, halaman 325, puasa model ini hanyalah puasanya orang awam (shaumul umum). Level yang lebih tinggi dari itu adalah puasa khusus (shaumul khusus), yakni puasa pancaindra, termasuk di dalamnya menjaga pandangan.\n\nAl-Ghazali menjelaskan bahwa tingkatan puasa ada tiga, yaitu puasa umum, puasa khusus, dan puasa khususul khusus.\n\nHakikat Puasa Pancaindra\n\nDalam kitab Bidayatul Hidayah, Imam Al-Ghazali menyampaikan: Janganlah engkau mengira bahwa puasa itu hanyalah sekadar meninggalkan makan, minum, dan hubungan suami istri saja. Rasulullah SAW telah bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'كَمْ مِنْ صَائِمٍ لَيْسَ لَهُ مِنْ صِيَامِهِ إِلَّا الْجُوْعَ وَالْعَطَشَ',
          'latin': '',
          'translation': 'Artinya, "Banyak orang yang berpuasa namun tidak mendapatkan apa-apa dari puasanya kecuali rasa lapar dan dahaga." (HR. An-Nasa\'i dan Ibnu Majah).',
        },
        {
          'type': 'text',
          'content': 'Sebaliknya, kesempurnaan puasa adalah dengan menahan seluruh anggota tubuh dari segala sesuatu yang dibenci oleh Allah SWT. Hendaknya engkau menjaga mata dari memandang hal-hal yang buruk, menjaga lisan dari mengucapkan hal-hal yang tidak bermanfaat bagimu, serta menjaga telinga dari mendengarkan apa yang diharamkan Allah.\n\nDemikian pula, engkau harus menahan seluruh anggota tubuhmu dari dosa sebagaimana engkau menahan perut dan kemaluanmu dari hal-hal yang membatalkan puasa. Disebutkan dalam sebuah riwayat, Rasulullah SAW bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'خَمْسٌ يُفْطِرْنَ الصَّائِمَ الْكَذِبُ وَالْغِيبَةُ وَالنَّمِيمَةُ وَالْيَمِينُ الْكَاذِبَةُ وَالنَّظَرُ بِشَهْوَةٍ',
          'latin': '',
          'translation': 'Artinya, "Lima hal yang dapat membatalkan (pahala) orang yang berpuasa: berdusta, ghibah (menggunjing), namimah (adu domba), sumpah palsu, dan memandang dengan syahwat." (Bidayatul Hidayah Hamisy Maraqil Ubudiyah, [Beirut: Darul Kutub Al-Ilmiyah, 2012], halaman 155).',
        },
        {
          'type': 'text',
          'content': 'Dalam syarahnya, Syekh Nawawi al-Bantani menjelaskan bahwa kesempurnaan puasa itu adalah dengan menahan seluruh anggota tubuh mulai dari pendengaran, penglihatan, lisan, tangan, kaki, dan selainnya dari segala sesuatu yang dibenci oleh Allah SWT berupa dosa-dosa. Itulah yang disebut dengan puasa orang-orang saleh (Shoum al-Khusus).\n\nBeliau juga menambahkan, hendaknya kita harus menjaga mata dari meluaskan pandangan melihat hal-hal yang dibenci Allah swt serta segala hal yang dapat memalingkan hati dari mengingat Allah SWT. Rasulullah SAW bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'النَّظَرَ سَهْمٌ مَسْمُومٌ مِنْ سِهَامِ إِبْلِيسَ لَعَنَهُ اللَّهُ فَمَنْ تَرَكَهُ خَوْفاً مِنَ اللهِ عَزَّ وَجَلَّ آتَاهُ اللَّهُ إِيْمَاناً يَجِدُ حَلَاوَتَهُ فِي قلبه',
          'latin': '',
          'translation': 'Artinya "Pandangan (haram) adalah salah satu anak panah beracun dari anak panah iblis. Barangsiapa meninggalkannya karena takut kepada Allah, maka Allah akan memberinya keimanan yang kemanisannya dapat ia rasakan di dalam hatinya." (Maraqi al-Ubudiyyah, [Beirut: Darul Kutub Al-Ilmiyah, 2012] halaman 155)',
        },
        {
          'type': 'text',
          'content': 'Syekh Muhammad Mahfudh At-Tarmasi menjelaskan bahwa sudah semestinya orang yang berpuasa menjaga anggota tubuhnya dari hal-hal yang diharamkan, karena itu semua dapat menghilangkan pahala puasa.\n\nBeliau juga mengutip penjelasan al-Mutawalli: \'Wajib bagi orang yang berpuasa untuk berpuasa dengan matanya, maka ia tidak melihat hal yang tidak halal; dengan pendengarannya, maka ia tidak mendengarkan hal yang tidak halal; dan dengan lisannya, maka ia tidak mengucapkan perkataan keji, tidak mencaci maki, tidak berdusta, dan tidak menggunjing (ghibah).\'" (Hasyiyah at-Tarmasyi, [Beirut: Darul Kutub Al-Ilmiyah, 2023] juz V, halaman 561)\n\nPenjelasan para ulama di atas secara tegas mendorong kita agar tidak terjerumus dalam puasa lahiriyah saja. Karena jika kita hanya menahan diri dari makanan, minuman, dan hubungan suami istri, anggota tubuh kita tetap melakukan dosa, maka yang kita dapatkan hanyalah lapar dan dahaga, bukan pahala.\n\nApalagi di era scroll media sosial saat ini, menjaga pandangan menjadi usaha yang jauh lebih berat. Karena godaan bukan lagi sekadar orang yang lewat di depan kita, melainkan algoritma yang menawarkan konten-konten negatif yang memancing syahwat.\n\nOleh karena itu, puasa di zaman ini menuntut kita untuk memiliki "puasa digital". Menahan diri untuk tidak mengklik atau memandangi hal-hal yang tidak bermanfaat adalah jihad besar di atas meja makan saat berbuka.\n\nMari kita jadikan Ramadhan kali ini sebagai momentum untuk melatih mata agar hanya melihat kebaikan. Sebagaimana pesan Rasulullah SAW di atas, "Barangsiapa yang menundukkan pandangannya karena Allah, maka Allah akan memberikan cahaya manisnya iman dalam hatinya."\n\nMari kita jadikan puasa kita tahun ini bukan sekadar menahan diri dari makanan, melainkan latihan bagi seluruh anggota tubuh, terutama pandangan, untuk tunduk kepada aturan Allah. Semoga kita tidak termasuk golongan yang hanya mendapatkan lapar dan haus semata.\n\nMuhammad Zainul Millah, Wakil Katib PCNU Kab. Blitar',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Puasa Ramadhan, Perekat Solidaritas dan Kerukunan Warga',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Puasa Ramadhan dalam kehidupan sosial menghadirkan pengaruh yang nyata, karena melalui pengalaman lapar, haus, dan pengendalian hawa nafsu, seseorang dilatih untuk lebih peka terhadap penderitaan dan keterbatasan orang lain. Ibadah puasa menumbuhkan rasa kebersamaan, kesetiakawanan, solidaritas, serta kepedulian sosial yang bermula dari lingkungan terdekat, terutama relasi bertetangga.\n\nDengan fondasi etika sosial yang dibentuk melalui puasa, sikap saling membantu dan menjaga kerukunan dapat tumbuh secara alami dalam kehidupan masyarakat, sejalan dengan ajaran Islam yang menekankan kepedulian dan tanggung jawab sosial terhadap sesama, terkhusus dengan tetangga. Allah berfirman dalam Al-Qur\'an Surat An-Nisa ayat 36.',
        },
        {
          'type': 'arabic',
          'content': 'وَاعْبُدُوا اللّٰهَ وَلَا تُشْرِكُوْا بِهٖ شَيْـًٔا وَّبِالْوَالِدَيْنِ اِحْسَانًا وَّبِذِى الْقُرْبٰى وَالْيَتٰمٰى وَالْمَسٰكِيْنِ وَالْجَارِ ذِى الْقُرْبٰى وَالْجَارِ الْجُنُبِ وَالصَّاحِبِ بِالْجَنْۢبِ وَابْنِ السَّبِيْلِۙ وَمَا مَلَكَتْ اَيْمَانُكُمْۗ اِنَّ اللّٰهَ لَا يُحِبُّ مَنْ كَانَ مُخْتَالًا فَخُوْرًا',
          'latin': '',
          'translation': 'Artinya, "Sembahlah Allah dan janganlah kamu mempersekutukan-Nya dengan sesuatu apa pun. Berbuat baiklah kepada kedua orang tua, karib kerabat, anak-anak yatim, orang-orang miskin, tetangga dekat dan tetangga jauh, teman sejawat, ibnu sabil, serta hamba sahaya yang kamu miliki. Sesungguhnya Allah tidak menyukai orang yang sombong lagi sangat membanggakan diri." (QS. An-Nisa ayat 36)',
        },
        {
          'type': 'text',
          'content': 'Imam Al-Qurthubi menjelaskan bahwa menunaikan hak tetangga adalah hal yang diperintahkan dan disunahkan kepada orang Muslim maupun kafir, dan ini adalah pandangan yang besar, sedangkan lhsan terkadang diartikan sebagai persamaan, terkadang juga bermakna mempergauli dengan baik, tidak mencela dan tidak menyakiti serta menjaga kehormatan mereka dan lainnya. (Imam Al-Qurthubi, Al-Jami\' li Ahkam al-Quran, [Beirut: Ar-Risalah, t.t], Jilid VI, hlm. 304).\n\nDi bulan Ramadhan misi sosial dalam membangun solidaritas dengan masyarakat merupakan kesadaran untuk memberi kelapangan kepada keluarga, berbuat baik kepada kerabat, tetangga, dan memperbanyak sedekah kepada kaum fakir miskin. Salah satu cara sederhana untuk membangun hubungan baik dengan tetangga adalah dengan berbagi. Tidak perlu mewah, cukup dengan membagikan takjil. Mengenai hal ini, Rasulullah SAW pernah bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ فَطَّرَ صَائِمًا كَانَ لَهُ مِثْلُ أَجْرِهِ غَيْرَ أَنَّهُ لاَ يَنْقُصُ مِنْ أَجْرِ الصَّائِمِ شَيْئًا',
          'latin': '',
          'translation': 'Artinya: "Siapa yang memberi makan orang yang berpuasa, maka baginya pahala seperti orang yang berpuasa tersebut, tanpa mengurangi pahala orang yang berpuasa itu sedikitpun pun juga." (HR. Tirmidzi)',
        },
        {
          'type': 'text',
          'content': 'Memberi menu takjil kepada orang lain merupakan ajaran Islam yang dianjurkan oleh Rasulullah SAW dan ulama. Hal ini menjadi bukti bahwa pengalaman spiritual seorang dalam berpuasa akan menumbuhkan empati yang mendorong lahirnya tindakan nyata dalam bulan Ramadhan Dan itu mengandung hikmah tersendiri bagi orang yang berpuasa, Syekh Wahbah az-Zuhaili dalam Kitab Al-Fiqhul Islami memberi penjelasan:',
        },
        {
          'type': 'arabic',
          'content': 'وَالْحِكْمْةُ فِي ذٰلِكَ تَفْرِيْغُ قُلُوْبِ الصَّائِمِيْنَ لِلْعِبَادَةِ بِدَفْعِ حَاجَاتِهِم',
          'latin': '',
          'translation': 'Artinya, "Hikmahnya adalah untuk memfokuskan hati orang-orang yang berpuasa dan para pelaksana qiyamul lail untuk ibadah semata, dengan cara memenuhi kebutuhan-kebutuhan mereka," (Syekh Wahbah Az-Zuhaili, Fiqhul Islami wa Adillatuhu, [Damaskus: Darul Fikri, t.t.], Juz II. hlm. 635).',
        },
        {
          'type': 'text',
          'content': 'Selain itu, kegiatan berbuka puasa bersama, tadarus berjamaah, menyalurkan zakat fitrah, serta pelaksanaan salat tarawih di masjid berfungsi sebagai ruang perjumpaan sosial yang menguatkan ikatan kebersamaan, baik di lingkungan keluarga, antartetangga, maupun dalam komunitas masyarakat yang lebih luas.\n\nDi sisi lain, dalam konteks bertetangga, puasa juga merupakan penahan lidah dan anggota tubuh lainnya dari perkataan sia-sia dan perbuatan-perbuatan yang tiada dosanya. Hal ini merupakan upaya mencegah konflik sosial dengan tetangga yang hanya dimulai dari hal-hal seperti ucapan yang kasar, amarah yang tidak bisa ditahan, dan sikap tidak peduli. Rasulullah SAW bersabda.',
        },
        {
          'type': 'arabic',
          'content': 'حَدَّثَنِي زُهَيْرُ بْنُ حَرْبِ حدَّثَنَا سُفْيَانُ بْنُ عُيَيْنَةَ، عَنْ أَبِي الزِّنَادِ عَنِ اْلأَعْرَجِ عَنْ أَبِي هُرَيرَةَ رَضِيَ الله عَنهُ رِوَايَةً، قَالَ إِذَ أَصْبَحَ أَحَدُكُمْ يَومًا صَائِمَا فَلاَ يَرْفُثْ وَلاَ يَجْهَلْ، فَإِنْ امْرُؤٌ شَاتَمَهُ أَوْ قَاتَلَهُ فَلْيَقُلْ إِنِّي صَائِمٌ إِنِّي صَائِمٌ',
          'latin': '',
          'translation': 'Artinya, "Zuhair bin Harb telah memberitahukan kepadaku, Sufyan bin Uyainah telah memberitahukan kepada kami dari Abu Az-Zinad, dari Al-A\'raj, dari Abu Hurairah RA sebuah riwayat dari Nabi SAW, beliau bersabda,\'Apabila salah seorang dari kalian dalam keadaan berpuasa pada suatu hari, maka janganlah ia berbuat keji dan jangan pula berbuat hal yang sia-sia. Lalu apabila ada yang mancelanya atau menantangnya, maka hendaklah ia mengatalan, "sesungguhnya aku sedang berpuasa, sesungguhnya aku sedang berpuasa," (HR. Muslim).',
        },
        {
          'type': 'arabic',
          'content': 'Kemudian, Imam an-Nawawi dalam Syarh Shahih Muslim menjelaskan di antaranya larangan bagi orang yang berpuasa untuk melakukan rafats, yakni perbuatan keji dan berkata-kata kotor. Lafaz رَفَثَ dibaca rafatsa, sedangkan يَرْفُثُ dibaca yarfutsu atau yarfitsu. Boleh juga dibaca rafitsa–yarfatsu–rafṡan. Ada pula yang membacanya dengan bentuk أَرْفَثَ. Adapun kata الجَهْل (al-jahl) hampir semakna dengan الرَّفَث, yaitu perbuatan dan ucapan yang sia-sia serta tidak benar. (Imam an-Nawawi, Al-Minhaj Syarh Shahih Muslim ibn al-Hajjaj, [Mesir: Dar al-Hadits, t.t.], hlm. 28).',
          'latin': '',
        },
        {
          'type': 'text',
          'content': 'Kemudian, Imam An-Nawawi juga menegaskan bahwa larangan untuk berbuat keji, sia-sia, permusuhan dan saling mencela tidak khusus untuk orang yang berpuasa saja, akan tetapi berlaku untuk setiap pribadi berdasarkan hukum asal dalam larangan tersebut, hanya saja untuk orang yang berpuasa lebih ditekankan.\n\nDengan demikian, marilah kita memaknai puasa Ramadhan tidak hanya sebagai peningkatan ibadah ritual, tetapi juga sebagai sarana menumbuhkan sikap sosial yang lebih ramah dan peduli. Jadikan puasa sebagai jalan menghadirkan rasa aman, saling menghargai, dan kepedulian terhadap tetangga, sehingga ibadah ini berujung pada terbentuknya solidaritas sosial, bukan sekadar pengalaman menahan kelaparan secara pribadi. Wallahu a\'lam.\n\nMuhammad Syaf\'ul Iktafi, Alumni Pondok Pesantren Tarbiyatul Islam Al-Falah Salatiga.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Bulan Puasa dan Semangat Amal yang Berkesinambungan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Bulan Ramadhan adalah bulan menjarah ibadah dan kebaikan sebanyak-banyaknya. Di bulan inilah pahala amal ibadah dan kebaikan berkali-lipat ganda dan jauh lebih besar dibandingkan dengan bulan-bulan lainnya. Ramadhan laksana musim panen bagi kaum mukmin.\n\nOleh karena itu, tidak selayaknya seorang Muslim menyia-nyiakan bulan yang mulia ini tanpa memaksimalkan diri dalam kebaikan. Ramadhan bukan sekadar bulan menahan lapar dan dahaga, tetapi momentum untuk memperbanyak amal, memperbaiki diri, dan membiasakan kebaikan secara berkesinambungan. Setiap kali satu kebaikan selesai dikerjakan, hendaknya disambung dengan kebaikan lainnya, agar Ramadhan benar-benar menjadi bulan yang mengubah ritme hidup menuju ketaatan yang hakiki.\n\nAllah SWT dalam surat As-Syarh Ayat 7 dan 8 berfirman:',
        },
        {
          'type': 'arabic',
          'content': 'فَإِذَا فَرَغْتَ فَٱنصَبْ * وَإِلَىٰ رَبِّكَ فَٱرْغَب',
          'latin': '',
          'translation': 'Artinya: (7) "Maka apabila kamu telah selesai (dari sesuatu urusan), kerjakanlah dengan sungguh-sungguh (urusan) yang lain. (8) Dan hanya kepada Tuhanmu berharaplah."',
        },
        {
          'type': 'text',
          'content': 'Syekh Nawawi Banten menafsirkan ayat "Faidza faraghta fanshab" dengan "apabila engkau telah selesai dari ibadah, maka susulkan ibadah lain dengan saling berkesinambungan antara sebagian ibadah dengan bagian yang lain dan dengan tidak mengosongkan satu waktu dari ibadah".\n\nKemudian beliau menyebutkan sebuah riwayat dari Ali bin Abi Thalhah dan riwayat Umar bin al-Khattab sebagai berikut.',
        },
        {
          'type': 'arabic',
          'content': 'وَقَالَ عَلِيُّ بْنُ أَبِي طَلْحَةَ: إِذَا كُنْتَ صَحِيحًا فَاجْعَلْ فَرَاغَكَ تَعَبًا فِي الْعِبَادَةِ',
          'latin': '',
          'translation': 'Artinya, "Ali bin Abi Thalhah berkata: "jika kamu dalam keadaan sehat, jadikan waktu luangmu untuk lelah dalam beribadah\'."',
        },
        {
          'type': 'text',
          'content': 'Ungkapan sahabat Ali bin Abi Thalhah tersebut menunjukkan pentingnya memaksimalkan kondisi sehat untuk terus beribadah. Kesehatan dan waktu luang adalah nikmat besar yang sering kali tidak disadari. Karena itu, jangan sampai rasa lelah yang kita rasakan berlalu tanpa bernilai ibadah.\n\nSejalan dengan ungkapan tersebut, Umar bin Khattab juga memberikan motivasi agar seorang Muslim tidak membiarkan waktunya kosong tanpa manfaat. Beliau tidak menyukai seseorang yang menganggur, tidak produktif dalam urusan dunia dan tidak pula dalam amal akhirat. Ini mengingatkan bahwa setiap detik kehidupan seharusnya diisi dengan hal yang bernilai, baik untuk kemaslahatan dunia maupun akhirat.',
        },
        {
          'type': 'arabic',
          'content': 'قَالَ عُمَرُ بْنُ الْخَطَّابِ رَضِيَ اللَّهُ عَنْهُ: إِنِّي أَكْرَهُ أَنْ أَرَى أَحَدَكُمْ فَارِغًا لَا فِي عَمَلِ الدُّنْيَا وَلَا فِي عَمَلِ الْآخِرَةِ',
          'latin': '',
          'translation': 'Artinya: Umar bin Khattab berkata, "Sungguh aku membenci melihat satu dari kalian semua seorang yang menganggur; tidak dari urusan dunia maupun akhirat".',
        },
        {
          'type': 'text',
          'content': 'Selanjutnya, Syekh Nawawi menafsirkan "wa ila rabbika farghab" dengan "ajukan kebutuhan-kebutuhanmu kepada Tuhanmu, jadikan harapanmu hanya kepada Allah, dan jangan meminta kecuali kemurahan (fadlh) Nya dengan bertawakal atau berserah diri kepada-Nya. (Muhammad Nawawi Al-Jawi, At-Tafsirul Munir li Ma\'alimit Tanzil, [Surabaya, al-Hidayah], juz II halaman 453).\n\nDari penafsiran surat as-Syarh atau al-Insyirah di atas dapat dipahami bahwa Islam tidak mengajarkan seorang mukmin untuk mengosongkan diri dan bermalas-malasan dalam hidup. Setiap kali satu ibadah atau urusan selesai, hendaknya segera disusul dengan amal dan ibadah lainnya secara berkesinambungan, sehingga tidak ada satu pun waktu yang berlalu tanpa nilai kebaikan, baik dalam urusan dunia maupun akhirat.\n\nBersamaan dengan hal tersebut, seluruh aktivitas dan kesungguhan tersebut harus dilandasi dengan ketergantungan kepada Allah semata. Harapan, kebutuhan, dan tujuan akhir seorang hamba hanya kepada-Nya dengan penuh tawakal.\n\nSyekh Wahbah az-Zuhaili dalam tafsirnya menjelaskan bahwa Surah al-Insyirah ayat 7 merupakan dalil untuk senantiasa berkesinambungan atau terus-menerus dalam melakukan amal saleh dan kebaikan. Hal ini karena memanfaatkan waktu dengan sebaik-baiknya merupakan tuntutan syariat, dan Allah tidak menyukai hamba-Nya yang menyia-nyiakan waktu dengan bermalas-malasan, menganggur, atau tidak melakukan aktivitas yang bernilai kebaikan. Berikut penjelasan beliau selengkapnya:',
        },
        {
          'type': 'arabic',
          'content': 'وَهَذَا دَلِيلٌ عَلَى طَلَبِ الِاسْتِمْرَارِ فِي الْعَمَلِ الصَّالِحِ وَالْخَيْرِ وَالْمُثَابَرَةِ عَلَى الطَّاعَةِ؛ لِأَنَّ اسْتِغْلَالَ الْوَقْتِ مَطْلُوبٌ شَرْعًا، وَإِنَّ اللَّهَ يَكْرَهُ الْعَبْدَ الْبَطَّالَ',
          'latin': '',
          'translation': 'Artinya: "Ayat ini merupakan dalil tentang tuntutan untuk terus-menerus melakukan amal saleh dan kebaikan serta bersungguh-sungguh dalam ketaatan; karena memanfaatkan waktu adalah sesuatu yang dituntut oleh syariat, dan Allah membenci hamba yang malas dan suka menganggur." (Wahbah bin Musthafa az-Zuhaili, At-Tafsir Munir, [Damaskus, Darul Fikr: 1418 H], juz XXX, halaman 298).',
        },
        {
          'type': 'text',
          'content': 'Dengan demikian, seorang Muslim hendaknya senantiasa istiqamah dalam melakukan amal saleh dan kebaikan secara berkelanjutan. Setiap kali satu kebaikan selesai ditunaikan, janganlah berhenti, tetapi segera lanjutkan dengan kebaikan berikutnya. Jangan biarkan waktu berlalu kosong tanpa amal yang bernilai dan bermanfaat.\n\nTerlebih lagi pada momentum Ramadhan, bulan yang penuh keberkahan, ketika pahala dilipatgandakan dan amal sunnah diberi ganjaran seperti pahala amal wajib. Maka sungguh merugi orang yang menyia-nyiakan kesempatan emas ini tanpa memperbanyak ibadah dan amal kebajikan untuk mengapai ridha Allah.\n\nUstadz Muhamad Hanif Rahman, Dosen Ma\'had Aly Al-Iman Bulus dan Pengurus LBM NU Purworejo.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Puasa sebagai Terapi Jiwa di Bulan Ramadhan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Menjadi pribadi yang sehat secara fisik dan mental merupakan tujuan yang diharapkan setiap orang. Untuk mencapai tujuan tersebut, Islam menghadirkan tuntunan kehidupan melalui berbagai ibadah yang disyariatkan. Salah satu contohnya adalah puasa. Puasa merupakan kewajiban yang diperintahkan oleh Allah SWT. dengan tujuan membentuk derajat takwa, sebagaimana disebutkan dalam QS. Al-Baqarah: 183. Di samping nilai spiritual tersebut, puasa juga memiliki manfaat preventif terhadap berbagai gangguan fisik maupun mental.\n\nSelama berpuasa, tubuh mengalami perubahan dalam cara mengelola energi ketika berada dalam kondisi defisit kalori. Pada saat yang sama, jiwa dilatih untuk menumbuhkan kesabaran, mengendalikan hawa nafsu, serta mengatur emosi dan respons terhadap stres. Hal ini sebagaimana ditegaskan dalam sabda baginda Nabi SAW,',
        },
        {
          'type': 'arabic',
          'content': 'لَيْسَ الصِّيَامُ مِنَ الأَكْلِ وَالشُّرْبِ إِنَّمَا الصِّيَامُ مِنَ اللَّغْوِ وَالرَّفَثِ فَإِنْ سَابَّكَ أَحَدٌ أَوْ جَهِلَ عَلَيْكَ فَقُلْ إِنِّي صَائِمٌ إِنِّي صَائِمٌ (رَوَاهُ ابن خزيمة وابن حبان)',
          'latin': '',
          'translation': 'Artinya, "Puasa itu bukan sekadar (menahan) dari makan dan minum. Sesungguhnya puasa itu adalah menahan diri dari perkataan sia-sia dan rafats (ucapan/perbuatan keji). Maka jika ada seseorang mencacimu atau berbuat bodoh (kasar) kepadamu, katakanlah: \'Sesungguhnya aku sedang berpuasa, sesungguhnya aku sedang berpuasa," (HR. Ibnu Khuzaimah dan Ibnu Hibban).',
        },
        {
          'type': 'text',
          'content': 'Syekh Ash-Shan\'ani dalam At-Tanwir Syarh Al-Jami\' Ash-Shaghir menjelaskan bahwa orang yang meninggalkan makan dan minum tetapi tetap mengatakan atau melakukan hal yang sia-sia dan keji, maka ia pada hakikatnya tidak dianggap berpuasa secara sempurna karena rusak pahalanya dan berkurang ganjarannya, hingga seakan-akan ia tidak berpuasa. (Ash-Shan\'ani, At-Tanwir Syarhul Jami\' Ash-Shaghir, [Riyadh, Darussalam, 2011], jilid IX, hlm. 229).\n\nJabir bin Abdillah pun berkomentar,',
        },
        {
          'type': 'arabic',
          'content': 'إِذَا صُمْتَ فَلْيَصُمْ سَمْعُكَ وَبَصَرُكَ وَلِسَانُكَ عَنِ الْكَذِبِ وَالْمَحَارِمِ وَدَعْ أَذَى الْجَارِ، وَلْيَكُنْ عَلَيْكَ سَكِينَةٌ وَوَقَارٌ يَوْمَ صَوْمِكَ وَلَا تَجْعَلْ يَوْمَ صَوْمِكَ وَيَوْمَ فِطْرِكَ سَوَاءً',
          'latin': '',
        },
        {
          'type': 'text',
          'content': '"Ketika engkau berpuasa, maka pendengaranmu, penglihatanmu, lisanmu juga harus puasa dari dusta dan hal-hal yang haram. Jangan mengganggu tetangga. Bersikap tenanglah ketika puasa. Jangan samakan antara hari puasa dan tidak puasamu." (Ibnu Rajab al-Hanbali, Lathoiful Ma\'arif, [Riyadh, Daar Ibnu Khuzaimah, 1428 H], hlm. 364)\n\nDari hadis dan penjelasan para ulama di atas, dapat dipahami bahwa puasa bukan sekadar menahan lapar dan dahaga, tetapi juga merupakan latihan pengendalian diri terhadap ucapan, perilaku, dan pengelolaan emosi yang berkaitan dengan mekanisme sistem saraf serta fungsi otak manusia.\n\nSebuah penelitian yang dilakukan oleh Bastani dkk. (2017) melaporkan bahwa individu yang menjalankan puasa Ramadhan mengalami peningkatan signifikan pada kadar brain-derived neurotrophic factor (BDNF), serotonin, dan nerve growth factor (NGF) dalam plasma darah. Ketiga zat ini berperan penting dalam fungsi kognitif, stabilitas suasana hati, serta kemampuan otak beradaptasi terhadap stres (Bastani et al, 2017, The Effects of Fasting During Ramadan on the Concentration of Serotonin, Dopamine, Brain-Derived Neurotrophic Factor and Nerve Growth Factor, [Neurology International, Vol. 9:7043], hlm. 29–32).\n\nBDNF merupakan protein yang berperan dalam pertumbuhan dan pemeliharaan sel saraf, proses belajar dan memori, serta regulasi suasana hati. Penurunan kadar BDNF diketahui berkaitan dengan meningkatnya gejala depresi. Stres kronis dan depresi dapat menyebabkan penurunan kadar BDNF, peningkatan kematian sel, serta berkurangnya pertumbuhan neuron baru di hipokampus. Sebaliknya, peningkatan kadar BDNF sering dikaitkan dengan perbaikan kondisi psikologis. (Correia, Ana Salomé et al. BDNF Unveiled: Exploring Its Role in Major Depression Disorder, Serotonergic Imbalance, and Associated Stress Conditions. [Pharmaceutics, Vol. 15,8 2081], hlm. 4).\n\nRespons biologis tubuh terhadap puasa dipengaruhi oleh berbagai faktor, seperti kondisi metabolik, durasi puasa, pola makan, serta karakteristik individu. Oleh karena itu, pola makan yang teratur, kendali emosi, serta ketenangan selama berpuasa sebagaimana dianjurkan Nabi SAW dalam haditsnya berpotensi memengaruhi keseimbangan neurokimia yang berkontribusi terhadap stabilitas emosional.\n\nSebab kondisi psikologis yang tidak stabil sering kali memicu ketidakteraturan pola makan yang dalam jangka panjang dapat berkontribusi terhadap gangguan metabolik. Oleh karena itu, puasa dapat menjadi salah satu bentuk terapi pengendalian diri yang membantu menata kembali pola hidup dan regulasi emosi.\n\nStabilitas jiwa yang diperoleh melalui peningkatan kualitas ibadah selama Ramadhan, seperti zikir, membaca Al-Qur\'an, bersedekah, dan menghindari perbuatan munkar, dapat mendorong terbentuknya pribadi yang lebih tenang sekaligus menebalkan dinding keimanan. Pada akhirnya, hal ini dapat mengarahkan energi tubuh dan jiwa untuk melakukan hal-hal yang positif dan bermanfaat.\n\nDengan demikian, puasa yang dilakukan sesuai dengan ajaran Nabi SAW bukan hanya ibadah wajib yang berdimensi spiritual, tetapi juga memiliki dampak positif bagi kesehatan psikologis dan neurobiologis manusia. Wallahu a\'lam.\n\nUstadzah Tuti Lutfiah Hidayah, Alumnus Pesantren Luhur Ilmu Hadis Darus-Sunnah Ciputat.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Selagi Masih Ada, Berbaktilah kepada Orang Tua',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Saat ini kita sedang berada di bulan Ramadhan. Bulan yang penuh berkah di mana seluruh umat Islam di seluruh dunia melaksanakan ibadah puasa satu bulan penuh. Dalam bulan yang penuh dengan keberkahan ini, umat Islam dianjurkan untuk memperbanyak amal saleh. Di antara amal saleh yang dianjurkan dalam Islam ialah berbakti kepada kedua orang tua.\n\nBerbakti kepada orang tua adalah bagian dari perintah agama dan merupakan kewajiban bagi umat Islam. Islam sangat mewajibkan bagi seorang anak untuk berbakti kepada kedua orang tua dengan menyayangi dan menghormati mereka. Sebab kedua orang tua merupakan sebab seorang anak ada di dunia dan mereka pula yang merawat, mendidik dan membesarkan anak hingga dewasa.\n\nDalam salah satu riwayat hadits, Nabi Muhammad SAW menyamakan derajat berbakti kepada kedua orang tua dengan berjihad.',
        },
        {
          'type': 'arabic',
          'content': 'عَنْ عَبْدِ اللهِ بْنِ عَمْرٍو، قَالَ: جَاءَ رَجُلٌ إِلَى النَّبِيِّ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ، يَسْتَأْذِنُهُ فِي الْجِهَادِ فَقَالَ: أَحَيٌّ وَالِدَاكَ؟ قَالَ: نَعَمْ، قَالَ: ‌فَفِيهِمَا ‌فَجَاهِدْ',
          'latin': '',
          'translation': 'Artinya: "Dari Abdullah bin Amr, berkata: Seorang laki-laki mendatangi Nabi Muhammad Saw meminta izin untuk mengikuti perang. Nabi Muhammad Saw bertanya: "Apakah kedua orang tuamu masih hidup?" "Masih, Nabi," jawab laki-laki tersebut. Nabi Muhammad bersabda: "Maka berjihadlah dengan berbakti kepada kedua orang tuamu," (HR. Muslim).',
        },
        {
          'type': 'text',
          'content': 'Orang tua memiliki derajat yang tinggi di dalam Islam. Dalam Al-Qur\'an, Allah SWT menempatkan perintah bersyukur kepada orang tua setelah perintah bersyukur kepada-Nya.\n\nAllah Ta\'ala berfirman dalam surat Luqman ayat 14:',
        },
        {
          'type': 'arabic',
          'content': 'وَوَصَّيْنَا الْاِنْسَانَ بِوَالِدَيْهِۚ حَمَلَتْهُ اُمُّهٗ وَهْنًا عَلٰى وَهْنٍ وَّفِصَالُهٗ فِيْ عَامَيْنِ اَنِ اشْكُرْ لِيْ وَلِوَالِدَيْكَۗ اِلَيَّ الْمَصِيْرُ',
          'latin': '',
          'translation': 'Artinya: "Kami mewasiatkan kepada manusia (agar berbuat baik) kepada kedua orang tuanya. Ibunya telah mengandungnya dalam keadaan lemah yang bertambah-tambah dan menyapihnya dalam dua tahun. (Wasiat Kami,) "Bersyukurlah kepada-Ku dan kepada kedua orang tuamu. Hanya kepada-Ku (kamu) kembali." (Qs. Luqman: 14).',
        },
        {
          'type': 'text',
          'content': 'Pada ayat di atas, Allah SWT memerintahkan kepada kita selaku umat Islam agar selalu berbakti kepada orang tua. Kedua orang tua, terutama ibu yang mengandung selama sembilan bulan dalam kepayahan, melahirkan dengan mempertaruhkan nyawa dan setelahnya dengan kasih sayang menyusui anaknya selama 2 tahun lamanya.\n\nDalam ayat ini, Allah juga menempatkan posisi bersyukur kepada kedua orang tua setelah bersyukur kepada-Nya yang menjadikan kedua orang tua memiliki derajat yang tinggi di sisi-Nya.\n\nSyekh Nawawi Al-Bantani dalam tafsirnya menjelaskan bahwa maksud dari perintah bersyukur kepada Allah pada ayat di atas ialah dengan menaati perintah-Nya sebab pada hakikatnya Allah yang memberikan nikmat. Sedangkan perintah bersyukur kepada kedua orang tua dengan berbakti, sebab keduanya merupakan sebab adanya anak.\n\nSyekh Nawawi berkata:',
        },
        {
          'type': 'arabic',
          'content': 'أَنِ اشْكُرْ لِي بِالطَّاعَةِ لِأَنِّيْ الْمُنْعِمُ فِيْ الْحَقِيْقَةِ وَلِوَالِدَيْكَ بِالتَّرْبِيَّةِ، لِأَنَّهُمَا سَبَبٌ لِوُجُوْدِكَ',
          'latin': '',
          'translation': 'Artinya: "Bersyukurlah kepada-Ku sebab Aku yang memberikan nikmat, dan kepada orang tuamu dengan berbakti, sebab keduanya merupakan sebab adanya dirimu," (Nawawi Banten, Marah Labid, [Beirut, Darul Kutub Al-Ilmiyah, 1417 H], juz II hal 237).',
        },
        {
          'type': 'text',
          'content': 'Dalam ayat setelahnya, bahkan Allah memerintahkan untuk tetap berbakti kepada orang tua meski berbeda keyakinan. Allah memerintahkan untuk membersamai keduanya dengan baik di dunia dengan menaati perintah keduanya selagi tidak bertentangan dengan perintah-Nya.\n\nAllah Ta\'ala berfirman:',
        },
        {
          'type': 'arabic',
          'content': 'وَاِنْ جَاهَدٰكَ عَلٰٓى اَنْ تُشْرِكَ بِيْ مَا لَيْسَ لَكَ بِهٖ عِلْمٌ فَلَا تُطِعْهُمَا وَصَاحِبْهُمَا فِى الدُّنْيَا مَعْرُوْفًاۖ وَّاتَّبِعْ سَبِيْلَ مَنْ اَنَابَ اِلَيَّۚ  ثُمَّ اِلَيَّ مَرْجِعُكُمْ فَاُنَبِّئُكُمْ بِمَا كُنْتُمْ تَعْمَلُوْنَ',
          'latin': '',
          'translation': 'Artinya: "Jika keduanya memaksamu untuk mempersekutukan-Ku dengan sesuatu yang engkau tidak punya ilmu tentang itu, janganlah patuhi keduanya, (tetapi) pergaulilah keduanya di dunia dengan baik dan ikutilah jalan orang yang kembali kepada-Ku. Kemudian, hanya kepada-Ku kamu kembali, lalu Aku beri tahukan kepadamu apa yang biasa kamu kerjakan," (Qs. Luqman: 15).',
        },
        {
          'type': 'text',
          'content': 'Ayat 15 surat Luqman di atas mempertegas posisi kedua orang tua yang memiliki kedudukan tinggi di sisi Allah Swt. Allah SWT tetap memerintahkan untuk berbakti kepada orang tua dan menemaninya dengan baik meski orang tua mengajak bermaksiat kepada-Nya.\n\nSyekh Nawawi Al-Bantani berkata:',
        },
        {
          'type': 'arabic',
          'content': 'أَنَّ خِدْمَتَهُمَا وَاجِبَةٌ وَطَاعَتَهُمَا لَازِمَةٌ مَا لَمْ يَكُنْ فِيْهَا تَرْكُ طَاعَةِ اللهِ، أَمَّا إِذَا أَفْضَى إِلَيْهِ فَلَا تُطِعْهُمَا وَصَاحِبْهُما فِي الدُّنْيا مَعْرُوفاً، أي صَحَابًا مَعْرُوْفًا يَرْتَضِيْهِ الشَّرْعُ وَتَقْتَضِيْهِ',
          'latin': '',
        },
        {
          'type': 'arabic',
          'content': 'الْمُرُوْءَةُ',
          'latin': '',
          'translation': 'Artinya: "Berbakti dan menaati kedua orang tua dihukumi wajib selagi tidak ada unsur meninggalkan perintah taat kepada Allah. Adapun jika sampai menghantarkan kepada maksiat maka jangan mengikutinya. Namun tetaplah pergauli keduanya di dunia dengan baik yang sesuai dengan tuntunan syariat," (Marah Labid, hal. 237).',
        },
        {
          'type': 'text',
          'content': 'Beberapa ayat berbakti kepada orang tua seperti yang dicontohkan di atas memberikan penjelasan yang tegas bahwa berbakti kepada orang tua sangat diwajibkan dalam Islam selagi tidak memerintahkan kepada kemaksiatan.\n\nDalam konteks di zaman sekarang, berbakti kepada orang tua bisa dilakukan dengan berbagai macam cara. Misal secara ekonomi, dari uang penghasilan hasil kerja selama sebulan, kita bisa menyisihkannya untuk sedikit membantu meringankan ekonomi orang tua. Atau mungkin misal kita berbeda pandangan politik dengan orang tua, kita tetap menghormatinya dan tidak menjauhinya karena hal tersebut.\n\nKesimpulannya, berbakti kepada orang tua merupakan kewajiban dalam Islam. Pada momen Ramadhan yang dipenuhi keberkahan ini, bagi seorang anak yang masih memiliki kedua orang tua, hendaknya memanfaatkannya dengan baik, yaitu dengan berbakti dan membersamai keduanya selagi masih diberikan kesempatan. Dianjurkan pula bagi seorang anak untuk selalu mendoakan yang terbaik untuk kedua orang tuanya sebagaimana mereka selalu mendoakan yang terbaik untuk kita.\n\nAlwi Jamalulel Ubab, Penulis Tinggal di Indramayu.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Allah Selalu Bersama Orang-Orang yang Sabar',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Di dalam kehidupan ini, setiap manusia pasti tak luput dari ujian dan cobaan. Sikap kita ketika mendapatkan ujian dan cobaan ini, tiada lain, yakni harus menghadapinya dengan sabar. Sifat sabar merupakan salah satu karakter yang dimiliki oleh orang-orang yang beriman. Bahkan, Allah senantiasa beserta orang-orang yang sabar. Sebagaimana firman Allah SWT dalam Al-Qur\'an:',
        },
        {
          'type': 'arabic',
          'content': 'يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوا اسْتَعِيْنُوْا بِالصَّبْرِ وَالصَّلٰوةِۗ اِنَّ اللّٰهَ مَعَ الصّٰبِرِيْنَ',
          'latin': '',
          'translation': 'Artinya, "Wahai orang-orang yang beriman, mohonlah pertolongan (kepada Allah) dengan sabar dan salat. Sesungguhnya Allah beserta orang-orang yang sabar," (QS Al-Baqarah ayat 153).',
        },
        {
          'type': 'text',
          'content': 'Meski terlihat mudah dilaksanakan, tetapi pada kenyataannya banyak orang yang terkadang merasa tidak sabar, ketika ia tengah mendapatkan ujian atau cobaan dari Allah SWT. Hal tersebut dapat kita maklumi, sebab setiap manusia memiliki kadar atau tingkat kesabaran masing-masing. Imam Al-Ghazali dalam kitab Ihya Ulumiddin, membagi sabar dalam beberapa tingkatan:',
        },
        {
          'type': 'arabic',
          'content': 'وَقَالَ بَعْضُ الْعَارِفِينَ: أَهْلُ الصَّبْرِ عَلَى ثَلَاثَةِ مَقَامَاتٍ',
          'latin': '',
          'translation': 'Artinya, "Sebagian ulama makrifat mengatakan: Orang sabar terdiri atas tiga tingkatan," (Imam Al-Ghazali, Ihya Ulumiddin, [Beirut, Darul Fikr: 2018 M/1439-1440 H], juz IV, halaman 72).',
        },
        {
          'type': 'text',
          'content': 'Tingkat sabar yang pertama yakni tingkatan bagi orang yang bertobat, yang ditandai dengan tarku syahwat atau sabar dalam meninggalkan syahwat. Sebagai contoh, pada bulan Ramadhan ini, kita melaksanakan perintah puasa, yang di dalamnya kita dilatih untuk bersabar atau menahan diri dari perkara-perkara yang membatalkan puasa, seperti makan, minum, dan lain-lain.\n\nMaka, bulan Ramadhan menjadi salah satu momen yang tepat bagi kita untuk melatih kesabaran. Selaras dengan hal tersebut, Nabi Muhammad SAW bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'الصَّوْمُ نِصْفُ الصَّبْرِ',
          'latin': '',
          'translation': 'Artinya, "Puasa adalah separuh kesabaran," (HR At-Tirmidzi dan Ahmad).',
        },
        {
          'type': 'text',
          'content': 'Pada saat berpuasa, kita juga dilatih untuk menahan diri dengan tidak melakukan hal-hal yang dapat menghilangkan keberkahan dan bahkan menggugurkan pahala puasa kita, semisal dengan menjaga lisan kita dari perkataan bohong, ghibah, fitnah, dan lain sebagainya.\n\nKemudian, tingkatan sabar yang kedua yakni ridha (menerima) atas takdir. Ini derajat sabar bagi orang-orang yang zuhud. Ridha atas takdir yang terkadang terasa menyakitkan seperti halnya musibah berupa bencana, penyakit, perlakuan buruk dari orang lain, kemiskinan, kecelakaan, kemalingan, kehilangan harta benda, kebakaran, dan lain sebagainya.\n\nMusibah ini jika dihadapi dengan sabar serta sikap ridha, akan meninggikan derajat atau menghapus dosa. Rasulullah shallallahu \'alaihi wa sallam bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'مَا يُصِيْبُ الْمُسْلِمَ مِنْ نَصَبٍ وَلَا وَصَبٍ وَلَا هَمٍّ وَلَا حَزَنٍ وَلَا أَذًى وَلَا غَمٍّ حَتَّى الشَّوْكَة يُشَاكُهَا، إِلَّا كَفَّرَ اللّٰهُ بِهَا مِنْ خَطَايَاهُ',
          'latin': '',
          'translation': 'Artinya, "Tidaklah seorang Muslim tertimpa keletihan dan penyakit, kekhawatiran dan kesedihan, gangguan dan kesusahan, bahkan duri yang melukainya, melainkan dengan sebab itu semua Allah akan menghapus dosa-dosanya." (HR al-Bukhari).',
        },
        {
          'type': 'text',
          'content': 'Kemudian, tingkatan sabar yang ketiga adalah mencintai apa yang dilakukan Allah terhadapnya. Ini derajat orang yang as-shiddiq. Seringkali, semakin Allah semakin mencintai seorang hamba dan begitu juga sebaliknya, maka ia juga akan memberikan ujian yang semakin berat kepada hamba-Nya tersebut. Dalam sebuah hadits, Rasulullah shallallahu \'alaihi wa sallam bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ يُرِدِ اللّٰهُ بِهِ خَيْرًا يُصِبْ مِنْهُ',
          'latin': '',
          'translation': 'Artinya: "Siapa saja yang Allah kehendaki kebaikan pada dirinya, maka Allah akan menimpakan musibah kepadanya," (HR al-Bukhari).',
        },
        {
          'type': 'text',
          'content': 'Jadi, orang yang dikehendaki baik oleh Allah akan ditimpa musibah dan diberi kekuatan oleh Allah untuk bersikap sabar dalam menanggung dan menghadapi musibah yang menimpanya. Seberapa kuat dan sabar, seorang hamba ketika mendapatkan ujian dan musibah dari Allah SWT. Dan seperti yang telah kita tahu, mereka yang paling berat mendapatkan ujian dari Allah adalah para nabi. Rasulullah shallallahu \'alaihi wa sallam bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'أَشَدُّ النَّاسِ بَلَاءً الأَنْبِيَاءُ ثُمَّ الْأَمْثَلُ فَالْأَمْثَلُ، يُبْتَلَى الرَّجُلُ عَلَى حَسَبِ دِيْنِهِ',
          'latin': '',
          'translation': 'Artinya, "Manusia yang paling berat ujian dan musibahnya adalah para nabi, kemudian orang-orang yang di bawah derajat mereka, kemudian orang-orang yang di bawah derajat mereka. Seseorang diuji berdasarkan sekuat apa ia pegangteguh agamanya," (HR at-Tirmidzi, Ahmad dan lainnya).',
        },
        {
          'type': 'text',
          'content': 'Oleh karena itu, marilah kita jadikan puasa ini sebagai saat yang tepat bagi kita untuk melatih kesabaran kita. Dengan bersabar, insyaAllah kita akan tergolong ke dalam orang-orang yang beruntung dan mendapatkan pahala yang besar, bahkan tak terhitung. Sebagaimana janji Allah SWT bagi orang yang sabar:',
        },
        {
          'type': 'arabic',
          'content': 'إِنَّمَا يُوَفَّى الصَّابِرُونَ أَجْرَهُم بِغَيْرِ حِسَابٍ',
          'latin': '',
          'translation': 'Artinya, "Orang-orang yang sabar akan digenapi ganjarannya dengan tak terhitung," (Surat Az-Zumar ayat 10).',
        },
        {
          'type': 'text',
          'content': 'Demikianlah kultum Ramadhan tentang sikap sabar dan khususnya dalam konteks kita selama melaksanakan ibadah di bulan Ramadhan ini. Semoga kita semua termasuk ke dalam golongan orang-orang yang sabar dan dicintai oleh Allah SWT. Amin ya Rabbal \'alamin.\n\nAjie Najmuddin, Pengurus MWCNU Banyudono Boyolali.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Memprioritaskan Kebahagiaan Keluarga',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Pernahkah kita selalu merasa senang ketika sering berbuat baik kepada orang lain, namun dalam melakukan hal yang sama kepada keluarga, khususnya anak dan istri di rumah, merasa biasa-biasa saja?\n\nMemang tidak ada yang salah dengan perilaku yang hampir menjadi kebiasaan kita itu. Justru berbuat baik kepada orang lain merupakan pekerjaan yang sangat mulia.\n\nAkan tetapi, di sisi lain, kita dianjurkan oleh Allah swt untuk memberi perlakuan spesial kepada orang-orang terdekat, bahkan penting sekali untuk kita prioritaskan. Kemudian, setelah itu berbuat baik kepada orang lain yang tidak memiliki ikatan kekerabatan dengan kita.\n\nDi dalam Al-Qur\'an urutan ini dijelaskan secara langsung pada surat An-Nisa ayat 36:',
        },
        {
          'type': 'arabic',
          'content': 'وَاعْبُدُوا اللّٰهَ وَلَا تُشْرِكُوْا بِهٖ شَيْـًٔا وَّبِالْوَالِدَيْنِ اِحْسَانًا وَّبِذِى الْقُرْبٰى وَالْيَتٰمٰى وَالْمَسٰكِيْنِ وَالْجَارِ ذِى الْقُرْبٰى وَالْجَارِ الْجُنُبِ وَالصَّاحِبِ بِالْجَنْۢبِ وَابْنِ السَّبِيْلِۙ وَمَا مَلَكَتْ اَيْمَانُكُمْ ۗ اِنَّ اللّٰهَ لَا يُحِبُّ مَنْ كَانَ مُخْتَالًا فَخُوْرًاۙ',
          'latin': '',
          'translation': 'Artinya: "Sembahlah Allah dan janganlah kamu mempersekutukan-Nya dengan sesuatu apa pun. Berbuat baiklah kepada kedua orang tua, karib kerabat, anak-anak yatim, orang-orang miskin, tetangga dekat dan tetangga jauh, teman sejawat, ibnu sabil, serta hamba sahaya yang kamu miliki. Sesungguhnya Allah tidak menyukai orang yang sombong lagi sangat membanggakan diri."',
        },
        {
          'type': 'text',
          'content': 'Ayat 36 menyebutkan bahwa urutan berbuat baik yang harus kita dahulukan ialah kedua orang tua dan kerabat atau keluarga. Baru setelahnya kita diperintahkan untuk melakukan kebaikan kepada anak-anak yatim, orang-orang miskin, tetangga, teman dan orang lain yang membutuhkan.\n\nIni dilandasi sabda Rasulullah saw riwayat Al-Baihaqi, bersumber dari Jabir bin Abdillah:',
        },
        {
          'type': 'arabic',
          'content': 'عَنْ جَابِرِ بْنِ عَبْدِ اللّٰهِ، قَالَ: قَالَ رَسُولُ اللّٰهِ صَلَّى اللّٰهُ عَلَيْهِ وَسَلَّمَ: ‌ابْدَءُوْا ‌بِمَا ‌بَدَأَ ‌اللّٰهُ عَزَّ وَجَلَّ بِهِ',
          'latin': '',
          'translation': 'Artinya: "Dari Jabir bin Abdillah, ia berkata, bahwa Rasulullah Saw bersabda: "Mulailah (mengerjakan sesuatu) sesuai dengan apa yang dimulai (atau yang diurutkan) oleh Allah dengannya."',
        },
        {
          'type': 'text',
          'content': 'Meskipun hadits menjelaskan tentang urutan pelaksanaan Sa\'i yang harus mulai dari bukit Shafa ke bukit Marwah, sebagaimana petunjuk yang diberikan oleh Allah dalam Al-Baqarah ayat 158, namun, hadits tersebut juga dipakai oleh ulama untuk menetapkan urutan berwudhu, dimulai dengan membasuh wajah hingga membasuh kaki, seperti yang dijelaskan Al--Maidah ayat 6.\n\nKaitannya dengan An-Nisa ayat 36 yang menjelaskan urutan orang-orang yang harus diperlakukan secara spesial, dimulai dari orang yang paling terdekat terlebih dahulu, yakni: dari orang tua, lalu karib kerabat atau keluarga, anak-anak yatim, orang-orang miskin, tetangga, teman sejawat, dan siapa saja yang membutuhkan.\n\nMengutamakan berbuat baik kepada keluarga juga disebutkan oleh Nabi Muhammad saw dengan narasi bahwa pemberian yang terbaik, ialah sesuatu yang diserahkan kepada keluarga terlebih dahulu.\n\nDirincikan dalam hadits yang diriwayatkan oleh Imam Muslim, bersumber dari Tsauban:',
        },
        {
          'type': 'arabic',
          'content': 'قَالَ رَسُولُ اللّٰهِ صَلَّى اللّٰهُ عَلَيْهِ وَسَلَّمَ: ‌أَفْضَلُ ‌دِينَارٍ ‌يُنْفِقُهُ الرَّجُلُ دِينَارٌ يُنْفِقُهُ عَلَى عِيَالِهِ، وَدِينَارٌ يُنْفِقُهُ الرَّجُلُ عَلَى دَابَّتِهِ فِي سَبِيلِ اللّٰهِ، وَدِينَارٌ يُنْفِقُهُ عَلَى أَصْحَابِهِ فِي سَبِيلِ اللّٰهِ',
          'latin': '',
          'translation': 'Artinya: "Rasulullah Saw bersabda: "Sebaik-baik Dinar (yakni, uang emas atau alat transaksi di masa Nabi) pemberian laki-laki ialah yang ia berikan kepada keluarganya, kemudian Dinar yang ia belanjakan untuk hewan ternaknya di jalan Allah, dan Dinar yang ia berikan kepada sahabatnya."',
        },
        {
          'type': 'text',
          'content': 'Nabi saw juga membuktikan bahwa berbuat baik kepada keluarga adalah amal yang tidak bisa disepelekan. Karena hal tersebut, beliau secara tegas mengatakan, bahwa beliau pun selalu memperlakukan keluarganya dengan sangat baik.\n\nDisebutkan dalam hadits yang diriwayatkan oleh Ibnu Majah, bersumber dari Ibnu Abbas:',
        },
        {
          'type': 'arabic',
          'content': 'عَنِ النَّبِيِّ صَلَّى اللّٰهُ عَلَيْهِ وَسَلَّمَ قَالَ: خَيْرُكُمْ ‌خَيْرُكُمْ ‌لِأَهْلِهِ، وَأَنَا خَيْرُكُمْ لِأَهْلِي',
          'latin': '',
          'translation': 'Artinya: "Dari Nabi Saw, beliau bersabda: "Sebaik-baik kalian ialah yang paling baik kepada keluarganya. Dan aku merupakan orang yang paling baik kepada keluargaku di antara kalian."',
        },
        {
          'type': 'text',
          'content': 'Tidak hanya pengakuan sepihak dari Nabi saw saja, akan tetapi testimoni tentang beliau yang berperilaku baik kepada keluarga ini, juga bersumber dari istri-istrinya. Salah satunya disebutkan oleh Aisyah binti Abu Bakar:',
        },
        {
          'type': 'arabic',
          'content': 'مَا كَانَ النَّبِيُّ صَلَّى اللّٰهُ عَلَيْهِ وَسَلَّمَ ‌يَصْنَعُ ‌فِي ‌أَهْلِهِ؟ قَالَتْ: كَانَ فِي مِهْنَةِ أَهْلِهِ، فَإِذَا حَضَرَتِ الصَّلَاةُ قَامَ إِلَى الصَّلَاةِ',
          'latin': '',
          'translation': 'Artinya: "Apa yang dilakukan oleh Nabi saw ketika berada di tengah-tengah keluarganya?" Aisyah menjawab: "Nabi saw biasanya melakukan pekerjaan rumah. Namun apabila waktu shalat telah tiba, ia bergegas melaksanakannya."',
        },
        {
          'type': 'text',
          'content': 'Sering kali kita merasa senang dan puas hati telah membahagiakan teman dan sahabat, akan tetapi ketika melakukan perbuatan yang sama kepada keluarga, kita cenderung biasa-biasa saja.\n\nPadahal, di dalam Al-Qur\'an QS. An-Nisa ayat 36 disebutkan, bahwa kebaikan itu dimulai dari yang paling dekat hubungannya dengan kita. Dimulai dari orang tua, lalu kerabat, tetangga, kemudian orang yang memiliki hubungan yang jauh, seperti teman atau sahabat.\n\nKita juga perlu mencontoh apa yang dilakukan Nabi kepada keluarganya. Beliau selalu mendahulukan kebahagiaan untuk keluarganya. Sampai-sampai ia gemar membantu mengerjakan urusan rumah tangga. Wallahu a\'lam.\n\nUstadz Muhaimin Yasin, Alumnus Pondok Pesantren Ishlahul Muslimin Lombok Barat dan Pegiat Kajian Keislaman',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Menjemput Pertolongan Allah Lewat Kesabaran di Ramadhan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Pada bulan suci Ramadhan, sebagai Muslim kita tidak hanya memanfaatkan waktu untuk berpuasa, memperbanyak membaca Al-Qur\'an, dan melakukan berbagai amal kebaikan. Ramadhan juga menjadi momentum untuk memahami nilai-nilai penting yang sering kali luput dari perhatian, padahal merupakan bagian tak terpisahkan dari makna bulan yang mulia ini.\n\nSalah satu nilai tersebut adalah kesabaran. Ia melekat erat dengan Ramadhan, terutama melalui kewajiban puasa. Ibadah ini bukan sekadar menahan lapar dan dahaga, melainkan latihan membentuk kesabaran dalam seluruh aspek kehidupan.\n\nKarena itu, Ramadhan bukan hanya waktu yang tepat untuk melatih kesabaran secara fisik, tetapi juga kesempatan untuk memperdalam pemahaman kita tentang hakikat dan peran kesabaran dalam kehidupan sehari-hari.\n\nDi antara yang penting untuk kita pahami adalah, pertama, bahwa kesabaran sangat berkaitan erat dengan bulan Ramadhan. Kedua, kesabaran merupakan rezeki dari Allah SWT. Ketiga, bersabar merupakan awal dari pertolongan Allah SWT.\n\nMengenai poin pertama, bahwa kesabaran erat dengan bulan Ramadhan, Allah SWT berfirman dalam Surat al-Baqarah ayat 153:',
        },
        {
          'type': 'arabic',
          'content': 'يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوا اسْتَعِيْنُوْا بِالصَّبْرِ وَالصَّلٰوةِۗ اِنَّ اللّٰهَ مَعَ الصّٰبِرِيْنَ',
          'latin': '',
          'translation': 'Artinya: "Wahai orang-orang yang beriman, mohonlah pertolongan (kepada Allah) dengan sabar dan shalat. Sesungguhnya Allah beserta orang-orang yang sabar." (QS. Al-Baqarah [2]: 153).',
        },
        {
          'type': 'text',
          'content': 'Dalam menafsirkan ayat ini, Imam Abu Hayyan dalam tafsir Al-Bahrul Muhith memaparkan beberapa pendapat para mufassir terkait makna sabar. Di antaranya seperti redaksi berikut:',
        },
        {
          'type': 'arabic',
          'content': 'وَقَدْ قَيَّدَ بَعْضُهُمُ الصَّبْرَ هُنَا: بِأَنَّهُ الصَّبْرُ عَلَى أَذَى الْكُفَّارِ بِالطَّعْنِ عَلَى التَّحَوُّلِ وَالصَّلَاةِ إِلَى الْكَعْبَةِ، وَبَعْضُهُمْ بِالصَّبْرِ عَلَى أَدَاءِ الْفَرَائِضِ. وَرُوِيَ عَنِ ابْنِ عَبَّاسٍ وَبَعْضِهِمْ قَالَ: هُوَ كِنَايَةٌ عَنِ الصَّوْمِ، وَمِنْهُ قِيلَ لِرَمَضَانَ: شَهْرُ الصَّبْرِ',
          'latin': '',
          'translation': 'Artinya: "Sebagian ulama mengartikan sabar dalam ayat ini dengan kesabaran atas cacian orang-orang kafir soal perpindahan kiblat (yang sebelumnya shalat menghadap ke Baitul Maqdis) lalu berganti ke Ka\'bah. Sebagian lagi ada yang mengartikan sabar dalam melaksanakan kewajiban. Diriwayatkan dari Ibnu Abbas dan sebagian ulama, ia berkata, \'sabar itu adalah kinayah dari puasa; ada juga yang mengartikan bahwa Ramadhan bulan kesabaran." (Imam Abu Hayyan, Al-Bahrul Muhith, [Beirut: Darul Fikr, 1420 H], jilid II, hal. 51).',
        },
        {
          'type': 'text',
          'content': 'Jadi, antara kesabaran dan Ramadhan merupakan dua unsur yang sangat berkaitan, tak terpisahkan, hingga dikatakan bahwa Ramadhan merupakan bulan kesabaran, sebagaimana penafsiran paling akhir.\n\nKemudian, yang kedua, kesabaran merupakan rezeki dari Allah. Buktinya, Rasulullah SAW pun memosisikan kesabaran yang kita punya sebagai rezeki yang sangat berharga, bahkan sampai disebut pemberian yang paling baik dan luas. Berikut bunyi haditsnya:',
        },
        {
          'type': 'arabic',
          'content': 'مَا رُزِقَ عَبْدٌ خَيْرًا لَهُ وَلَا أَوْسَعَ مِنَ الصَّبْرِ',
          'latin': '',
          'translation': 'Artinya: "Seorang hamba tidak diberikan rezeki yang lebih baik dan luas daripada rezeki kesabaran." (HR Imam Hakim).',
        },
        {
          'type': 'text',
          'content': 'Dalam riwayat yang lain disebutkan:',
        },
        {
          'type': 'arabic',
          'content': 'وَمَنْ يَسْتَعْفِفْ يُعِفَّهُ اللهُ، وَمَنْ يَسْتَغْنِ يُغْنِهِ اللهُ، وَمَنْ يَتَصَبَّرْ يُصَبِّرْهُ اللهُ، وَمَا أُعْطِيَ أَحَدٌ مِنْ عَطَاءٍ خَيْرًا وَأَوْسَعَ مِنَ الصَّبْرِ',
          'latin': '',
          'translation': 'Artinya: "Siapa saja menjaga kesucian dirinya, maka Allah akan menjaga kesuciannya, siapa saja mencukupkan dirinya tanpa meminta-minta, maka Allah akan menjadikannya kaya, dan siapa yang berlatih untuk bersabar, Allah akan beri kesabaran, dan tidaklah seseorang diberi pemberian yang lebih baik daripada kesabaran." (HR Imam Bukhari)',
        },
        {
          'type': 'text',
          'content': 'Dalam dua hadits di muka terdapat diksi ash-shabru, kesabaran dan yatashabbar, berlatih bersabar. Artinya, yang dimaksud dengan pemberian yang paling baik dan luas tersebut adalah kesabaran. Dalam konteks ini, kesabaran itu murni pemberian/rezeki dari Allah SWT. Ini makna dari hadits pertama dan kalimat terakhir dari hadits kedua.\n\nBagaimana cara mendapatkannya? Dengan berusaha bersabar, sebagaimana tersurat dalam kalimat awal dalam hadits kedua yang memakai diksi yatashabbar.\n\nDalam ilmu gramatika Arab, setiap kata yang mengikuti wazan tafa\'alah-yatafa\'alu, tashabbara-yatashabbaru, berfaedah takalluf. Artinya, harus ada usaha untuk mendapatkan hal tersebut; dalam konteks ini, adalah mendapatkan kesabaran.\n\nKenapa kesabaran dikategorikan sebagai rezeki paling baik dan luas? Simak jawaban berikut:',
        },
        {
          'type': 'arabic',
          'content': 'لِأَنَّهُ إِكْلِيلٌ لِلْإِيمَانِ، وَأَوْفَرُ الْمُؤْمِنِينَ حَظًّا مِنَ الصَّبْرِ أَوْفَرُهُمْ حَظًّا مِنَ الْقُرْبِ مِنَ الرَّبِّ، وَالصَّبْرُ رِزْقٌ مِنَ اللَّهِ، لَا يَسْتَبِدُّ الْعَبْدُ بِكَسْبِهِ، وَمَا يُضَافُ إِلَى كَسْبِ الْعَبْدِ هُوَ التَّصَبُّرُ، فَإِذَا حَمَلَ عَلَى نَفْسِهِ التَّصَبُّرَ أَمَدَّهُ اللَّهُ بِكَمَالِ الصَّبْرِ، وَفِي الْخَبَرِ: مَنْ يَتَصَبَّرْ يُصَبِّرْهُ اللَّهُ، فَإِذَا رَزَقَهُ الصَّبْرَ كَانَ أَوْسَعَ مِنْ كُلِّ نِعْمَةٍ وَاسِعَةٍ، لِأَنَّهُ يُسَهِّلُ بِالصَّبْرِ جَمِيعَ الْخَيْرَاتِ، وَتَرْكَ الْمُنْكَرَاتِ، وَتَحَمُّلَ الْمَكْرُوهَاتِ الْمُقَدَّرَاتِ',
          'latin': '',
          'translation': 'Artinya: "Karena sabar layaknya mahkota bagi keimanan, dan karena semakin sempurna bagian kesabaran Mukminin, semakin sempurna bagian kedekatannya kepada Tuhannya. Kesabaran merupakan rezeki dari Allah. (Sejatinya) hamba-Nya tidak memiliki daya dengan cara ber-kasab/ikhtiar (mendapatkannya). Sedangkan penisbatan kasab pada seorang hamba itu merupakan proses/usaha bersabar.  Jadi, jika ia bisa menanggung usaha bersabar tersebut, Allah akan memberikan kesabaran yang sempurna.',
        },
        {
          'type': 'text',
          'content': '"Dalam hadits dikatakan, \'siapa saja berusaha bersabar niscaya Allah akan berikan kesabaran. Dan ketika ia diberi rezeki kesabaran, hal tersebut lebih luas daripada seluruh kenikmatan yang luas. Karena kesabaran akan mempermudah melaksanakan segala kebaikan, meninggal kemungkaran, dan sekaligus meringankan semua beban perkara yang tidak disukai tapi ditakdirkan." (Syekh Zainuddin Al-Munawi, Faydhul Qadir, [Mesir, Maktabah at-Tijariyyah al-Kubra, 1356 H], jilid V, hlm. 447).\n\nSelanjutnya, yang ketiga, sikap bersabar atas sesuatu yang terjadi merupakan tahap awal dari datangnya pertolongan Allah. Hal ini tersirat dalam ayat yang telah disebut sebelumnya, yaitu secara tegas Allah SWT memerintahkan orang-orang Mukmin untuk meminta pertolongan dengan kesabaran dan shalat.\n\nImam Mawardi mengutip beberapa kalam ulama tentang kesabaran yang menunjukkan bahwa pertolongan sangat erat kaitannya dengan kesabaran. Di antaranya adalah redaksi berikut:',
        },
        {
          'type': 'arabic',
          'content': 'وَاعْلَمْ أَنَّ النَّصْرَ مَعَ الصَّبْرِ .... وَقَالَ بَعْضُ الْحُكَمَاءِ: بِمِفْتَاحِ عَزِيمَةِ الصَّبْرِ تُعَالَجُ مَغَالِيقُ الْأُمُورِ',
          'latin': '',
          'translation': 'Artinya: "Ketahuilah! Sungguh pertolongan bersama dengan kesabaran. Sebagian filsuf berkata, \'Dengan kunci komitmen kesabaran, akan terbuka gembok-gembok segala urusan." (Imam Mawardi, Adabud Dunya wad Din, [Daru Maktabatul Hayat, t.t.], hal. 290).',
        },
        {
          'type': 'text',
          'content': 'Dari semua pemaparan di atas, bisa kita simpulkan bahwa bulan Ramadan merupakan momen yang sangat tepat untuk melatih bersabar dalam segala aspek kehidupan, baik secara vertikal dengan bersabar dalam menjalankan amal yang diperintahkan Allah SWT dan menjauhi larangan-Nya, atau secara horizontal dengan bersabar terhadap hal-hal yang tidak kita suka yang bersumber dari sesama manusia.\n\nLatihan bersabar tersebut merupakan ikhtiar kita agar diberi rezeki kesabaran yang menjadi kunci untuk membuka gembok-gembok dan bisa menyingkirkan kesulitan yang sedang menimpa. Jika kesulitan itu tak kunjung pergi, yakinlah bahwa pertolongan-Nya akan datang di waktu yang tepat berkat kesabaran kita. Wallahu a\'lam.\n\nSyifaul Qulub Amin, Alumnus PP Nurul Cholil Bangkalan dan Pengajar di PP Putri Al-Masyhuriyah Kebonan Bangkalan.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: 2 Tanda Puasa Ramadhan Diterima Oleh Allah',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Menjadi hamba yang jerih payah ibadah puasanya diterima merupakan tujuan utama dalam bulan Ramadhan. Pasalnya, puasa adalah ibadah yang cukup berat dalam pelaksanaannya.\n\nSelain menahan diri dari hal-hal yang dihalalkan syariat, seperti makan, minum, dan hubungan intim suami istri bagi yang telah menikah, aspek lain seperti kejujuran menjadi hal krusial saat menjalankan ibadah puasa.\n\nOleh karena itu, mendapatkan penerimaan dari Allah atas ibadah puasa sangatlah penting. Apalagi, puasa adalah satu-satunya ibadah yang pahalanya sepenuhnya bergantung pada penilaian Allah semata.\n\nBegitu juga sebaliknya, ibadah puasa yang tidak diterima menjadi hal yang harus dihindari sekaligus ditakuti oleh seorang hamba. Usaha yang dilakukan dari terbitnya fajar kedua (berkumandangnya adzan subuh) sampai terbenamnya matahari (berkumandangnya adzan maghrib) menjadi sia-sia.\n\nBahkan puasa yang dilakukan menjadi tidak bernilai sama sekali. Nabi sudah memperingatkan, bahwa fenomena seseorang yang berpuasa namun hanya menyisakan lapar dan haus benar adanya. Sebagaimana sabda beliau:',
        },
        {
          'type': 'arabic',
          'content': 'كَمْ مِنْ صَائِمٍ لَيْسَ لَهُ مِنْ صِيَامِهِ إِلَّا الْجُوْع وَالْعَطْش',
          'latin': '',
          'translation': 'Artinya, "Begitu banyak seseorang yang sedang berpuasa hanya menyisakan lapar dan haus," (HR. Imam Ibnu Majah).',
        },
        {
          'type': 'text',
          'content': 'Kita berpotensi melaksanakan ibadah puasa dengan menyisakan lapar dan dahaga. Seyogyanya, kita dari awal  menyadari akan hal ini. Bisa jadi yang dimaksud oleh Nabi adalah diri kita sendiri.\n\nBeruntungnya, para ulama merumuskan tanda diterimanya puasa seseorang. Kendatipun segala hal yang berkaitan dengan puasa sepenuhnya ada dalam prerogatif Allah, terdapat tanda-tanda yang mengindikasikan Allah menerima ibadah puasa seseorang.\n\nSalah satu ulama dari kalangan Hanabilah (madzhab Hanbali) bernama Ibnu Rajab menjelaskan tanda-tanda yang mengindikasikan diterimanya ibadah puasa. Dalam kitabnya Lathaiful Ma\'arif setidaknya dijelaskan bahwa ada dua tanda ibadah puasa seseorang diterima.\n\nWalaupun tanda yang dijelaskan tidak absolut, kemungkinan diterimanya cukup besar. Uniknya, tanda-tanda itu berdasar pada pola tindakan seseorang dalam berpuasa, bukan dari eksternal.\n\nTerbiasa Berpuasa di Bulan Syawal\n\nSalah satu tanda seseorang diterima ibadah puasanya selama bulan Ramadhan adalah melanjutkan berpuasa di bulan Syawal. Lebih tepatnya hari kedua pada bulan Syawal sampai pada hari ketujuh. Tidak hanya mendapatkan keutamaan-keutamaan berpuasa di bulan Syawal seperti setara berpuasa selama satu tahun penuh, namun menjadi indikator diterimanya puasa seseorang.',
        },
        {
          'type': 'arabic',
          'content': 'أَنَّ مُعَاوَدَةَ الصِّيَامِ بَعْدَ صَامَ رَمَضَانَ عَلاَمَةٌ عَلىَ قَبُولِ صَوْمِ رَمَضَانَ؛ فَإِنَّ اللّٰهَ تَعَالى إِذَا تَقَبَّلَ عَمَلَ عَبْدٍ وَفَّقَهُ لِعَمَلٍ صَالِحٍ بَعْدَهُ',
          'latin': '',
          'translation': 'Artinya, "Memiliki kebiasaan berpuasa setelah puasa bulan Ramadhan (puasa bulan Syawal) merupakan tanda dari diterimanya puasa Ramadhan. Sebab Allah menerima amal seseorang bergantung pada amal shalih sesudahnya," (Ibnu Rajab al-Hanbali, Lathaiful Ma\'arif, [Riyadh, Dar Ibnu Khuzaimah: 2007], halaman 494).',
        },
        {
          'type': 'text',
          'content': 'Berdasar pada kaidah "suatu amal saleh dapat diterima jika melaksanakan amal saleh setelahnya" menjadikan berpuasa di bulan Syawal menjadi salah satu tanda diterimanya puasa Ramadhan. Hal yang sama berlaku pada setiap amal. Dengan demikian, setiap orang dituntut untuk terus melakukan amal saleh terus menerus secara berturut-turut untuk memungkinkan diterimanya amal. Sehingga dalam kehidupan sehari-harinya selalu diiringi dengan amal saleh.\\n\\nBerbeda ketika melakukan amal buruk setelah amal saleh. Jika seseorang mulanya beramal saleh namun diakhiri dengan amal yang buruk, maka amal saleh yang sebelumnya dilakukan akan tertolak dengan sendirinya (Lathaiful Ma\'arif, halaman 494).\\n\\nBerkomitmen Tidak Mengulangi Maksiat\\n\\nTanda berikutnya adalah memiliki kecondongan hati untuk tidak mengulangi maksiat di waktu mendatang. Hal ini merupakan poin utama dalam bertobat. Melaksanakan peribadatan berbanding lurus dengan komitmen untuk tidak terjerumus pada kemaksiatan, baik maksiat yang pernah dilakukan, maupun yang belum pernah dilakukan.\\n\\nHanya saja, kondisi hati yang masih cenderung untuk mengulangi maksiat memiliki konsekuensi tersendiri. Kendatipun secara tampak seseorang sedang melaksanakan suatu peribadatan tetapi kondisi hatinya masih condong pada kemaksiatan, peribadatan yang demikian tidak dapat diterima.\\n\\nBegitu pun dalam beribadah puasa di saat Ramadhan. Seseorang benar-benar harus memiliki keteguhan hati untuk tidak melakukan maksiat di luar waktu bulan puasa. Sebab seseorang yang berpuasa lalu berucap istighfar namun hatinya bertautan pada kemaksiatan, potensi diterimanya ibadah puasa sangat kecil.',
        },
        {
          'type': 'arabic',
          'content': 'فمَنِ اسْتَغْفَرَ بِلِسَانِهِ وَقَلْبُهُ عَلَى الْمَعْصِيَةِ مَعْقُوْد، وَعَزْمُهُ أنْ يَرْجِعَ إلَى المَعَاصِي بَعْدَ الشَّهْرِ ويَعُوْدُ؛ فَصَوْمُهُ عَلَيْهِ مَرْدُوْدٌ، وَبَابُ القَبُولِ عَنْهُ مَسْدُوْدٌ',
          'latin': '',
          'translation': 'Artinya, "Siapa yang meminta ampunan secara lisan akan tetapi hatinya bertaut pada kemaksiatan, serta merencanakan untuk kembali melakukan maksiat setelah bulan puasa, maka puasanya ditolak dan pintu penerimaan tobat ditutup," (Lathaiful Ma\'arif, halaman 484).',
        },
        {
          'type': 'text',
          'content': 'Tajuddin As-Subki mengutip pernyataan salah satu ulama syafi\'iyah bernama Abu Ali Al-Ashbahani. Dalam sebuah majelis, Al-Ashbahani ditanya oleh seseorang mengenai tanda diterimanya ibadah puasa Ramadhan. Beliau menjawab, bahwa tanda ibadah puasa diterima ketika seseorang meninggal di bulan Syawal tanpa melakukan tindakan buruk (maksiat). Al-Ashbahani meninggal pada bulan Syawal di hari Senin pada tahun lima ratus dua puluh lima hijriah," (Thabaqatus Syafi\'iyah, [Beirut, Dar Ihya\': 1992], Juz VII, halaman 26).\n\nDua tanda yang sudah dipaparkan dapat dijadikan acuan serta indikasi puasa Ramadhan kita akan diterima oleh Allah atau tidak. Walakin, sekali lagi, segala pertimbangan ibadah puasa sepenuhnya bergantung pada Allah, setidaknya kita memiliki gambaran atas kualitas puasa kita sendiri. Semoga puasa tahun ini dan puasa tahun-tahun berikutnya diterima oleh Allah. Amin. Wallahu A\'lam\n\nUstadz Shofi Mustajibullah, Mahasiswa Pascasarjana UNISMA dan Pengajar Pesantren Kampus Ainul Yaqin.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Adab dan Sunnah di Hari Idul Fitri',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Tak terasa, bulan Ramadhan akan usai, dan hari Idul Fitri pun tiba. Tentu, di satu kita mesti merasa sedih sebab kita akan ditinggalkan oleh tamu agung Ramadhan yang penuh dengan keberkahan dan ampunan.\n\nNamun, di sisi lain kita juga perlu untuk mempersiapkan diri dalam menyambut Hari Raya Idul Fitri. Persiapan yang perlu kita perhatikan menjelang Hari Raya Idul Fitri, yakni perihal adab dan sunahnya, agar kita juga mendapatkan pahala dan keberkahan di Hari Raya. Jika kita runut dari awal masuk waktu malam 1 Syawal hingga pagi harinya, maka dapat kita lakukan di antaranya sebagai berikut:\n\nPertama, ketika sudah resmi keluar pengumuman dari pemerintah terkait Hari Raya Idul Fitri, kita dianjurkan untuk mengumandangkan takbir atau biasa kita sebut takbiran. Anjuran takbiran ini sebagai bentuk rasa syukur kita, berdasarkan firman Allah:',
        },
        {
          'type': 'arabic',
          'content': 'وَلِتُكْمِلُوا الْعِدَّةَ وَلِتُكَبِّرُوا اللّٰهَ عَلٰى مَا هَدٰىكُمْ وَلَعَلَّكُمْ تَشْكُرُوْنَ',
          'latin': '',
          'translation': 'Artinya, "Hendaklah kamu mencukupkan bilangannya (Ramadhan) dan mengagungkan Allah atas petunjuk-Nya yang diberikan kepadamu agar kamu bersyukur," (QS. Al-Baqarah: 185).',
        },
        {
          'type': 'text',
          'content': 'Dalam Kitab Fathul Qarib dijelaskan terdapat dua macam takbir di Hari Raya Idul Fitri. Pertama, muqayyad (dibatasi), yaitu takbir yang dilakukan setelah shalat, baik fardhu atau sunnah. Setiap selesai shalat, dianjurkan untuk membaca takbir.\n\nKedua, mursal (dibebaskan), yaitu takbir yang tidak terbatas setelah shalat, bisa dilakukan di setiap kondisi. Takbir Idul Fitri bisa dikumandangkan di mana saja, di rumah, jalan, masjid, pasar atau tempat lainnya.\n\nKesunnahan takbir Idul fitri dimulai sejak tenggelamnya matahari pada malam 1 Syawal sampai takbiratul Ihramnya Imam shalat Id bagi yang berjamaah, atau takbiratul Ihramnya mushalli sendiri, bagi yang shalat sendirian.\n\nSalah satu contoh bacaan takbir yang utama sebagaimana diterangkan Syekh Ibnu Hajar al-Haitami dalam Tuhfatul Muhtaj juz 3 hal 54 adalah:',
        },
        {
          'type': 'arabic',
          'content': 'اللّٰهُ أَكْبَرُ اللّٰهُ أَكْبَرُ اللّٰهُ أَكْبَرُ لَا إلَهَ إلَّا اللّٰهُ اللّٰهُ أَكْبَرُ اللّٰهُ أَكْبَرُ وَلِلّٰهِ الْحَمْدُ، اللّٰهُ أَكْبَرُ كَبِيرًا وَالْحَمْدُ لِلّٰهِ كَثِيرًا وَسُبْحَانَ اللّٰهِ بُكْرَةً وَأَصِيلًا لَا إلَهَ إلَّا اللّٰهُ وَلَا نَعْبُدُ إلَّا إيَّاهُ مُخْلِصِينَ لَهُ الدِّينَ وَلَوْ كَرِهَ الْكَافِرُونَ لَا إلَهَ إلَّا اللّٰهُ وَحْدَهُ صَدَقَ وَعْدَهُ وَنَصَرَ عَبْدَهُ وَهَزَمَ الْأَحْزَابَ وَحْدَهُ لَا إلَهَ إلَّا اللّٰهُ وَاللهُ أَكْبَرُ',
          'latin': '',
        },
        {
          'type': 'text',
          'content': 'Selain mengkumandangkan takbir, biasanya kita juga akan saling mengucapkan selamat Hari Raya Idul Fitri, dengan redaksi yang beragam. Baik mengucapkan secara langsung dengan bersalaman secara fisik, maupun sekadar mengirim ucapan melalui media sosial. Bahkan, ucapan tersebut tak jarang ditambahi dengan pantun nan jenaka, maupun kalimat yang mengharu biru.\n\nHal demikian boleh-boleh saja, dengan catatan dilakukan dengan cara yang baik dan tidak melanggar syariat seperti bersalaman dengan lawan jenis yang bukan mahram, sebagaimana diterangkan oleh Syekh Abdul Hamid asy-Syarwani dalam Hasyiyatusy Syarwani, juz 3, hlm. 56:',
        },
        {
          'type': 'arabic',
          'content': 'وَقَدْ يُقَالُ لَا مَانِعَ مِنْهُ أَيْضًا إذَا جَرَتْ الْعَادَةُ بِذَلِكَ لِمَا ذَكَرَهُ مِنْ أَنَّ الْمَقْصُودَ مِنْهُ التَّوَدُّدُ وَإِظْهَارُ السُّرُورِ وَيُؤَيِّدُهُ نَدْبُ التَّكْبِيرِ فِي لَيْلَةِ الْعِيدِ',
          'latin': '',
          'translation': 'Artinya, "Terkadang diucapkan, tidak ada yang menghalangi hal tersebut apabila kebiasaan terlaku demikian, Karena alasan yang telah disampaikan bahwa tujuan dari tahniah adalah saling mengasihi dan menampakkan kebahagiaan. Sudut pandang ini dikuatkan dengan kesunnahan takbir di hari raya."',
        },
        {
          'type': 'text',
          'content': 'Ketiga, di malam Hari Raya, kita dianjurkan untuk menghidupkan malam Idul Fitri dengan ibadah. Dianjurkan menghidupkan malam hari raya dengan shalat, membaca shalawat, membaca Al-Qur\'an, membaca kitab, memperbanyak doa, berdzikir, dan bentuk ibadah lainnya. Anjuran ini berdasarkan hadits Nabi:',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ أَحْيَا لَيْلَتَيْ الْعِيدِ لَمْ يَمُتْ قَلْبُهُ يَوْمَ تَمُوتُ الْقُلُوبُ',
          'latin': '',
          'translation': 'Artinya, "Barangsiapa menghidupi dua malam hari raya, hatinya tidak mati di hari matinya beberapa hati," (HR. Ad-Daraquthni).',
        },
        {
          'type': 'text',
          'content': 'Hadits ini memang tergolong lemah, namun tetap bisa dipakai sebab berkaitan dengan keutamaan amal, tidak berbicara halal-haram atau akidah. Kesunnahan ini bisa hasil dengan menghidupkan sebagian besar malam Hari Raya.\n\nKemudian, pada pagi Hari Raya Idul Fitri kita disunnahkan untuk melaksanakan Shalat Idul Fitri, dengan tata cara yang telah diajarkan dalam kitab-kitab fiqih. Sebelum berangkat melaksanakan shalat Id, terlebih dahulu kita disunnahkan untuk mandi dan berhias diri. Hal ini juga bertujuan untuk menebarkan syiar kebahagiaan di hari raya Idul Fitri.\n\nWaktu mandi ini dimulai sejak tengah malam Idul Fitri sampai tenggelamnya matahari di keesokan harinya. Lebih utama dilakukan dilakukan setelah terbit fajar. Keterangan ini sebagaimana disampaikan oleh Syekh Sulaiman al-Bujairimi dalam Tuhfatul Habib \'ala Syarh al-Khathib, juz 1, hal. 252. Contoh niatnya adalah:',
        },
        {
          'type': 'arabic',
          'content': 'نَوَيْتُ غُسْلَ عِيْدِ الْفِطْرِ سُنَّةً لِلهِ تَعَالَى',
          'latin': '',
          'translation': 'Artinya, "Aku niat mandi Idul fitri, sunnah karena Allah".',
        },
        {
          'type': 'text',
          'content': 'Berhias bisa dilakukan dengan membersihkan badan, memotong kuku serta rambut, memakai wewangian dan pakaian terbaik, yang tidak melanggar syariat seperti terlihat aurat pemakainya. Tak lupa, sebelum berangkat kita juga dianjurkan untuk makan terlebih dahulu sekadarnya, sebagai penanda bahwa di hari itu kita tidak lagi berpuasa.\n\nPerjalanan berangkat dan pulang, untuk menunaikan shalat Idul Fitri juga perlu kita perhatikan. Sebab kita dianjurkan untuk memilih jalur yang berbeda antara rute berangkat dan pulang.\n\nDi antara hikmahnya adalah agar memperbanyak pahala menuju tempat ibadah. Anjuran ini juga berlaku saat perjalanan haji, membesuk orang sakit dan ibadah lainnya, sebagaimana ditegaskan Imam Nawawi dalam kitab Riyadhus Shalihin (Lihat: Syekh Khathib al-Syarbini, Mughnil Muhtaj, juz 1, hal. 591).\n\nHal terakhir, yang tak kalah penting, yang dapat kita lakukan di Hari Raya Idul Fitri, yakni saling meminta ataupun memberikan maaf. Setelah selama satu bulan kita berpuasa dan mengeluarkan zakat fitrah, maka kita sempurnakan dengan meminta dan memberikan maaf kepada sesama, dengan harapan segala kesalahan dan dosa kita diampuni sepenuhnya oleh Allah.\n\nSemoga kita diberikan umur yang panjang dan berkah serta sehat wal afiat, untuk menjalani Ramadhan di tahun ini hingga akhir, dan diperkenankan untuk bertemu kembali pada Ramadhan-Ramadhan mendatang. Amin Ya Rabbal Alamin.\n\nUstadz Ajie Najmuddin, Ustadz Ajie Najmuddin, Pengurus MWCNU Banyudono Boyolali',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Merawat Semangat Ibadah Setelah Ramadhan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Bulan suci Ramadhan tahun ini tak terasa hampir pergi. Padahal, seakan baru kemarin ia menyapa kita. Ia berjalan seperti angin, berlalu begitu cepat. Tapi sayang, kita terlalu santai dan lambat meresponsnya, tidak memanfaatkan waktu bersamanya dengan baik. Bahkan banyak waktu terlewati begitu saja. Banyak amalan yang luput, kadang kita juga melewati hari-hari Ramadhan ini seperti hari-hari biasa di bulan lain.\n\nPotret Para Sahabat dan Ulama Salaf ketika Berada di Penghujung Ramadhan\n\nDalam kitab Lathaiful Ma\'arif, Imam Ibnu Rajab al-Hanbali, menyatakan bahwa para sahabat dan ulama salaf adalah orang-orang yang paling antusias dalam menyempurnakan dan melakukan hal terbaik dalam beramal.\n\nSelain itu, mereka juga sangat antusias agar amal mereka diterima dan merasa takut jika amal tersebut ditolak. Mereka itulah sekelompok manusia yang Allah sebutkan dalam Al-Qur\'an melalui firman-Nya:',
        },
        {
          'type': 'arabic',
          'content': 'وَالَّذِينَ يُؤْتُونَ مَا آتَوْا وَقُلُوبُهُمْ وَجِلَةٌ أَنَّهُمْ إِلَى رَبِّهِمْ رَاجِعُونَ',
          'latin': '',
          'translation': 'Artinya: "Dan orang-orang yang memberikan sesuatu yang telah mereka berikan, dengan hati yang takut, (karena mereka tahu bahwa) sesungguhnya mereka akan kembali kepada Tuhan mereka," (QS. al-Mu\'minun: 60).',
        },
        {
          'type': 'text',
          'content': 'Menurut Imam Ibnu Rajab, para sahabat dahulu berdoa selama enam bulan sebelum Ramadhan agar Allah mempertemukan mereka dengannya, dan enam bulan setelahnya mereka berdoa agar amal mereka diterima, (Imam Ibnu Rajab Al-Hanbali, Lathaiful Ma\'arif, [Beirut, Dar Ibnu Hazm: 1424 H], hlm. 209).\n\nSetelah Ramadhan: Menjaga Semangat Ibadah Sepanjang Tahun\n\nBulan suci Ramadhan itu bagaikan seorang kekasih, yang kehadirannya selalu dinantikan dan kepergiannya selalu membuat kesedihan serta kerinduan. Maka tidak mengherankan, jika tiba saatnya harus berpisah dengan Ramadhan, para sahabat dan ulama salaf bersedih, berharap agar dapat dipertemukan lagi dengan bulan Ramadhan tahun depan. Oleh karena itu, Imam Ibnu Rajab, dalam kitab Lathaiful Ma\'arif-nya berkata:',
        },
        {
          'type': 'arabic',
          'content': '‏كَيْفَ لَا تَجْرِيْ لِلْمُؤْمِنِ عَلَى فِرَاقِ رَمَضَان دُمُوْعٌ؟ وَهُوَ لَا يَدْرِيْ هَلْ بَقِيَ لَهُ في عُمرِهِ إليه رُجُوعٌ',
          'latin': '',
          'translation': 'Artinya: "Bagaimana bisa seorang mukmin tidak menetes air mata ketika berpisah dengan Ramadhan, sementara ia tak tahu pasti, apakah di sisa umurnya masih bisa berjumpa dengan bulan suci tersebut," (hlm. 217).',
        },
        {
          'type': 'text',
          'content': 'Akan tetapi yang lebih penting dari pada itu semua adalah jangan sampai ungkapan kesedihan dan tangisan kita dengan perginya bulan Ramadhan adalah hanya kepura-puraan saja atau sekedar ikut-ikutan saja. Kita buktikan perpisahan dengan bulan Ramadhan dengan tetap melakukan ibadah-ibadah yang sudah sering dilakukan di bulan Ramadhan atau minimal tidak kita tinggalkan secara total.\n\nBahkan Syekh Nawawi al-Bantani dalam kitabnya berjudul Nihayatuz Zain fi Irsyad al-Mubtadi\'in, menyatakan bahwa salah satu dari kesepuluh amaliah sunah Ramadhan adalah melanjutkan amaliah-amaliah yang telah dilakukan di bulan Ramadhan di bulan-bulan berikutnya (Nihayahtuz Zain, [Beirut, Darul Kutub al-Islamiyyah: tt], hlm. 190).\n\nOleh karena itu, Sayyid Abdullah al-Haddad juga pernah berkata,',
        },
        {
          'type': 'arabic',
          'content': 'لاَ تَسْكُب الدَّمَعَاتِ لِرَحِيْلِ رَمَضَانَ، فَرَمَضَانُ سَيَعُوْدُ، وَلَكِن اسْكُبْ الدَّمَعَاتِ خَشْيَةَ أَنْ يَعُودَ رَمَضَانُ وَ أنْتَ رَاحِلٌ',
          'latin': '',
          'translation': 'Artinya, "Kau tak perlu menyucurkan air mata karena kepergian Ramadhan, sebab bulan Ramadhan pasti akan kembali. Tapi cucurkanlah air mata karena khawatir ketika Ramadhan datang kembali, tapi kau telah pergi (sudah meninggal/ belum meninggal tapi telah pergi dari sebuah ketaatan)."',
        },
        {
          'type': 'text',
          'content': 'Masih Ada Asa agar Semua Tak Sia-sia\n\nSejatinya, sebelum bulan Ramadhan pergi, kita masih mempunyai kesempatan untuk menyelesaikan target-target yang belum terlaksana, walaupun waktu yang tersisa begitu singkat, seperti mengkhatamkan al-Qur\'an, memperbanyak sedekah, dan lain sebagainya.\n\nKalau kita ibaratkan, hari-hari akhir Ramadhan ini seperti babak final dalam sebuah kompetisi, para peserta semakin sedikit. Hanya mereka yang bersungguh-sungguh dan istiqamah berhasil lolos dari babak sebelumnya.\n\nLayaknya seekor kuda pacu, yang mana jika sudah mendekati garis finis, ia akan mengerahkan segenap tenaganya untuk meraih kemenangan. Oleh karena itu, jika kita merasa tak baik dalam menyambut bulan Ramadhan, maka marilah melakukan yang baik di detik-detik perpisahan dengannya.\n\nDo\'a Akhir Ramadhan\n\nSyekh Mutawalli asy-Sya\'rawi dalam salah satu kesempatan pernah berkata dengan mengutip sebuah hadits, bahwa Nabi Muhammad SAW ketika berpisah dengan bulan suci Ramadhan berdoa sebagai berikut:',
        },
        {
          'type': 'arabic',
          'content': 'أَللَّهُمَّ لاَ تَجْعَلْهُ آخِرَ الْعَهْدِ مِنْ صِيَامِنَا إِيَّاهُ، فَإِنْ جَعَلْتَهُ فَاجْعَلْنِيْ مَرْحُوْمًا وَ لاَ تَجْعَلْنِيْ مَحْرُوْمًا',
          'latin': '',
          'translation': 'Artinya: "Ya Allah, janganlah Engkau jadikan bulan Ramadhan tahun ini sebagai bulan Ramadhan terakhir dalam hidupku. Namun, jika Engkau menjadikannya sebagai Ramadhan terakhir bagiku, maka jadikanlah aku sebagai orang yang Engkau sayangi dan jangan jadikan aku orang yang Engkau murkai."',
        },
        {
          'type': 'text',
          'content': 'Lalu, Syekh Mutawalli asy-Sya\'rawi  mengutip riwayat dari sahabat Jabir bin Abdillah RA, dari Nabi Muhammad SAW, bahwa barang siapa yang membaca doa ini di malam terakhir bulan Ramadhan, maka ia akan mendapatkan salah satu dari dua kebaikan: yakni menjumpai bulan Ramadhan mendatang atau pengampunan dan rahmat Allah. Wallahu a\'lam.\n\nUstadz Muhammad Ryan Romadhon, Alumni Ma\'had Aly Al-Iman Bulus, Purworejo, Jawa Tengah.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Mari Perkuat Kesalehan Sosial Lewat Puasa',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Saat ini kita sedang berada di bulan yang sangat dinanti oleh semua umat Islam. Bulan Ramadhan yang kehadirannya selalu dirindukan, bahkan jauh sebelum ia benar-benar datang. Banyak doa dipanjatkan agar kita bisa dipertemukan dengannya dan bisa menjalani hari-harinya dengan sebaik-baiknya. Dan alhamdulillah, pada hari ini kita tidak lagi menunggunya, tetapi sedang berada di dalamnya.\n\nOleh karena itu, inilah kesempatan emas yang telah Allah SWT berikan kepada kita semua, karena Ramadhan merupakan bulan yang disediakan untuk saling berlomba-lomba dalam meningkatkan ketakwaan. Di dalamnya, semua amal ibadah dan kebaikan yang kita lakukan akan dilipatgandakan pahalanya oleh Allah. Allah SWT berfirman dalam Al-Qur\'an:',
        },
        {
          'type': 'arabic',
          'content': 'يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ',
          'latin': '',
          'translation': 'Artinya, "Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa," (QS. Al-Baqarah: 183).',
        },
        {
          'type': 'text',
          'content': 'Ayat ini menegaskan bahwa tujuan final dari ibadah puasa kita adalah meraih gelar "muttaqin", yaitu menjadi orang-orang yang bertakwa. Namun, sering kali makna takwa ini kita persempit hanya sebagai rasa takut kepada Allah yang membuat kita rajin beribadah ritual saja. Padahal takwa adalah sebuah konsep yang sangat luas dan dinamis.\n\nSalah satu bukti kuat bahwa puasa Ramadhan tidak hanya dimaksudkan untuk meningkatkan ritual ibadah semata adalah peringatan Rasulullah tentang seseorang yang masih terus berkata dusta, mengucapkan perkataan bohong, serta melakukan perbuatan yang menyakiti sesama, maka puasanya tidak bernilai di hadapan Allah. Dalam salah satu haditsnya, Nabi bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'مَنْ لَمْ يَدَعْ قَوْلَ الزُّورِ وَالْعَمَلَ بِهِ وَالْجَهْلَ فَلَيْسَ لِلَّهِ حَاجَةٌ أَنْ يَدَعَ طَعَامَهُ وَشَرَابَهُ',
          'latin': '',
          'translation': 'Artinya, "Barang siapa yang tidak meninggalkan perkataan dusta, mengamalkannya, dan perbuatan bodoh (yang menyakiti), maka Allah tidak membutuhkan ia meninggalkan makan dan minumnya (puasanya)." (HR. Bukhari).',
        },
        {
          'type': 'text',
          'content': 'Oleh karena itu, puasa yang kita jalani pada bulan Ramadhan ini tidak hanya tentang peningkatan ibadah spiritual semata, tetapi juga tentang peningkatan kesalehan sosial. Kita tidak hanya dituntut untuk rajin shalat, membaca Al-Qur\'an, dan berzikir, tetapi juga dituntut untuk peduli terhadap sesama, membantu orang yang kesusahan, menyantuni anak yatim, menjenguk orang sakit, dan berbuat baik kepada tetangga kita.\n\nSpirit tentang kesalehan sosial ini pada hakikatnya telah ditegaskan dalam Al-Qur\'an bahwa Allah tidak menjadikan ukuran kebaikan dan ketakwaan hanya pada simbol-simbol ritual semata, tetapi juga pada sejauh mana ketakwaan itu melahirkan kepedulian sosial yang nyata. Allah berfirman:',
        },
        {
          'type': 'arabic',
          'content': 'لَيْسَ الْبِرَّ أَنْ تُوَلُّوا وُجُوهَكُمْ قِبَلَ الْمَشْرِقِ وَالْمَغْرِبِ وَلَكِنَّ الْبِرَّ مَنْ آمَنَ بِاللَّهِ وَالْيَوْمِ الآخِرِ وَالْمَلائِكَةِ وَالْكِتَابِ وَالنَّبِيِّينَ وَآتَى الْمَالَ عَلَى حُبِّهِ ذَوِي الْقُرْبَى وَالْيَتَامَى وَالْمَسَاكِينَ وَابْنَ السَّبِيلِ وَالسَّائِلِينَ وَفِي الرِّقَابِ وَأَقَامَ الصَّلاةَ وَآتَى الزَّكَاةَ وَالْمُوفُونَ بِعَهْدِهِمْ إِذَا عَاهَدُوا وَالصَّابِرِينَ فِي الْبَأْسَاءِ وَالضَّرَّاءِ وَحِينَ الْبَأْسِ أُولَئِكَ الَّذِينَ صَدَقُوا وَأُولَئِكَ هُمُ الْمُتَّقُونَ',
          'latin': '',
          'translation': 'Artinya, "Kebajikan itu bukanlah menghadapkan wajahmu ke arah timur dan barat, melainkan kebajikan itu ialah (kebajikan) orang yang beriman kepada Allah, hari Akhir, malaikat-malaikat, kitab suci, dan nabi-nabi; memberikan harta yang dicintainya kepada kerabat, anak yatim, orang miskin, musafir, peminta-minta, dan (memerdekakan) hamba sahaya; melaksanakan salat; menunaikan zakat; menepati janji apabila berjanji; sabar dalam kemelaratan, penderitaan, dan pada masa peperangan. Mereka itulah orang-orang yang benar dan mereka itulah orang-orang yang bertakwa." (QS. Al-Baqarah: 177).',
        },
        {
          'type': 'text',
          'content': 'Oleh sebab itu, mari kita jadikan puasa di bulan Ramadhan ini tidak hanya sebagai ladang untuk meningkatkan kesalehan individual saja, tetapi juga sebagai momentum untuk berusaha sekuat mungkin meningkatkan kesalehan sosial.\n\nLantas, bagaimana caranya agar kita bisa meningkatkan kesalehan sosial di bulan Ramadhan ini? Caranya bisa kita mulai dari hal yang paling dekat dengan kita, yaitu menjaga lisan agar tidak melukai perasaan orang lain, menahan diri dari ghibah, adu domba, dan ucapan yang menyakitkan, sebab sering kali dosa sosial justru lahir dari kata-kata yang dianggap sepele tapi berdampak kepada yang lain.\n\nSelain itu, mari jadikan puasa sebagai madrasah kehidupan yang menumbuhkan kepekaan sosial. Rasa lapar yang kita rasakan hendaknya menyadarkan kita betapa beratnya perjuangan saudara-saudara yang hidup dalam kekurangan setiap hari. Dari kesadaran itu, lahirkan kepedulian yang nyata, misalnya dengan berbagi takjil atau membantu mereka yang membutuhkan.\n\nDan memang demikianlah salah satu sebab disyariatkannya puasa yang perlu kita pahami dan kita sadari, sebagaimana disampaikan oleh Syekh Muhammad Ali as-Shabuni dalam salah satu karya tafsirnya,',
        },
        {
          'type': 'arabic',
          'content': 'فَلَيْسَ الصِّيَامُ حِرْمَانًا لِلْإِنْسَانِ عَنِ الطَّعَامِ وَالشَّرَابِ، بَلْ هُوَ تَفْجِيرٌ لِلطَّاقَةِ الرُّوحِيَّةِ فِي نَفْسِ الْإِنْسَانِ، لِيَشْعُرَ بِشُعُورِ إِخْوَانِهِ، وَيُحِسَّ بِإِحْسَاسِهِمْ، فَيَمُدَّ إِلَيْهِمْ يَدَ الْمُسَاعَدَةِ وَالْعَوْنِ، وَيَمْسَحَ دُمُوعَ الْبَائِسِينَ، وَيُزِيلَ أَحْزَانَ الْمَنْكُوبِينَ، بِمَا تَجُودُ بِهِ نَفْسُهُ الْخَيِّرَةُ الْكَرِيمَةُ الَّتِي هَذَّبَهَا شَهْرُ الصِّيَامِ',
          'latin': '',
          'translation': 'Artinya, "Puasa tidak hanya menghalangi manusia dari makan dan minum, tetapi juga menghalangi pancaran energi spiritual dalam jiwa manusia, sehingga ia mampu merasakan apa yang dirasakan oleh saudara-saudaranya, ikut merasakan perasaan mereka, lalu mengulurkan tangan pertolongan dan bantuan, mengusap air mata orang-orang yang menderita, serta menghilangkan kesedihan mereka yang tertimpa musibah, disebabkan kemurahan jiwa yang baik dan mulia, yang telah ditempa dan dibina oleh bulan puasa." (Rawai\'ul Bayan fi Tafsiri Ayatil Ahkam, [Damaskus: Maktabah al-Ghazali, 1400 H], halaman 93).',
        },
        {
          'type': 'text',
          'content': 'Oleh karena itu, setelah kita merasakan lapar dan dahaga di siang hari Ramadhan, jangan biarkan rasa itu berlalu begitu saja. Jadikan ia sebagai pengingat akan saudara-saudara kita yang kurang beruntung, yang setiap hari harus berjuang untuk mendapatkan sesuap nasi. Kemudian, wujudkan kepedulian itu dalam tindakan nyata.\n\nKemudian jangan lupa, bahwa di era digital ini kesalehan sosial juga berarti menggunakan media sosial dengan bijak, menyebarkan kebaikan, menahan diri dari komentar yang buruk, dan menjadi agen perdamaian di tengah hiruk-pikuk informasi. Dengan begitu, kita tidak hanya berhasil meningkatkan kesalehan individual, tetapi juga kesalehan sosial.\n\nDemikianlah kultum Ramadhan tentang puasa dan kesalehan sosial. Semoga apa yang telah dijelaskan ini tidak hanya berhenti sebagai pengetahuan dan nasihat di lisan saja, tetapi benar-benar meresap ke dalam hati dan terwujud dalam perilaku keseharian kita. Aamiin ya Rabbal \'alamin.\n\nUstadz Sunnatullah, Pengajar di Pondok Pesantren Al-Hikmah Darussalam Durjan Kokop Bangkalan Jawa Timur.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Menghidupkan Hati dengan Tadarus Al-Qur’an',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Sebagai mukjizat paling agung yang dianugerahkan kepada Nabi Muhammad SAW, Al-Qur\'an hadir sebagai kompas sejati bagi umat manusia dalam menghadapi kompleksitas kehidupan. Lembaran sejarah mencatat bahwa momen sakral turunnya kalam ilahi yang kita kenal sebagai peristiwa Nuzulul Qur\'an ini bermula di tengah keagungan bulan suci Ramadhan.\n\nPeristiwa ini bukan sekadar catatan masa lalu, melainkan titik awal di mana cahaya petunjuk mulai menerangi jalan manusia menuju kebenaran. Allah berfirman dalam surat Al-Baqarah ayat 185:',
        },
        {
          'type': 'arabic',
          'content': 'شَهْرُ رَمَضَانَ الَّذِيْٓ اُنْزِلَ فِيْهِ الْقُرْاٰنُ هُدًى لِّلنَّاسِ وَبَيِّنٰتٍ مِّنَ الْهُدٰى وَالْفُرْقَانِۚ',
          'latin': '',
          'translation': 'Artinya, "Bulan Ramadhan adalah (bulan) yang di dalamnya diturunkan Al-Quran sebagai petunjuk bagi manusia dan penjelasan-penjelasan mengenai petunjuk itu serta pembeda (antara yang hak dan yang batil)." (QS. Al-Baqarah: 185)',
        },
        {
          'type': 'text',
          'content': 'Imam Al-Qurthubi dalam kitab tafsirnya,  Al-Jami\' li Ahkamil Qur\'an, memberikan klasifikasi mengenai waktu turunnya kitab-kitab samawi yang semuanya berpusat pada bulan Ramadan. Mengutip sabda Rasulullah melalui jalur periwayatan Watsilah bin Asqa\', beliau merinci bahwa Shuhuf Ibrahim hadir pada malam pertama, Taurat pada tanggal keenam, dan Injil pada tanggal ketiga belas Ramadhan.\n\nInformasi ini memperkuat argumen teologis mengapa Ramadhan disebut sebagai bulan Al-Qur\'an, karena secara historis, bulan ini memang dipilih sebagai waktu diturunkannya cahaya petunjuk bagi umat manusia lintas zaman. (Imam Al-Qurthubi, Al-Jami\' li Ahkamil Qur\'an, [Beirut, Muassasah Ar-Risalah: 2006], jilid. III, halaman 161).\n\nTadarus Al-Qur\'an, Menghidupkan Hati di Bulan Ramadhan\n\nBulan suci Ramadhan hadir sebagai momentum emas bagi setiap Muslim untuk kembali merajut kedekatan dengan Al-Qur\'an. Mengingat kaitan erat antara Ramadhan dan Al-Qur\'an, memperbanyak tadarus bukan sekadar rutinitas, melainkan upaya menghidupkan kembali hati kita di bulan yang penuh berkah tersebut. Allah SWT. berfirman dalam surat Al-Isra\':',
        },
        {
          'type': 'arabic',
          'content': 'وَنُنَزِّلُ مِنَ الْقُرْاٰنِ مَا هُوَ شِفَاۤءٌ وَّرَحْمَةٌ لِّلْمُؤْمِنِيْنَۙ وَلَا يَزِيْدُ الظّٰلِمِيْنَ اِلَّا خَسَارًا',
          'latin': '',
          'translation': 'Artinya: "Kami turunkan dari Al-Qur\'an sesuatu yang menjadi penawar dan rahmat bagi orang-orang mukmin, sedangkan bagi orang-orang zalim (Al-Qur\'an itu) hanya akan menambah kerugian." (QS. Al-Isra\': 82)',
        },
        {
          'type': 'text',
          'content': 'Syekh Mutawalli Asy-Sya\'rawi dalam kitab Khawathir Haulal Qur\'an-nya memberikan interpretasi terhadap ayat tersebut sebagai berikut:',
        },
        {
          'type': 'arabic',
          'content': 'وَالشِّفَاءُ: أَنْ تُعَالِجَ دَاءً مَوْجُودًا لِتَبْرَأَ مِنْهُ. وَالرَّحْمَةُ: أَنْ تَتَّخِذَ مِنْ أَسْبَابِ الْوِقَايَةِ مَا يَضْمَنُ لَكَ عَدَمَ مُعَاوَدَةِ الْمَرَضِ مَرَّةً أُخْرَى، فَالرَّحْمَةُ وِقَايَةٌ، وَالشِّفَاءُ عِلَاجٌ.',
          'latin': '',
          'translation': 'Artinya: "Syifa\' (penawar/obat) yang dimaksud dalam ayat tersebut adalah mengobati penyakit yang sedang ada agar sembuh darinya. Sedangkan maksud dari \'Rahmat\' adalah mengambil sebab-sebab pencegahan (preventif) yang menjamin Anda tidak akan tertular atau kambuh oleh penyakit itu lagi. Jadi, Rahmat adalah pencegahan, sedangkan Syifa\' adalah pengobatan." (Khawathir Haulal Qur\'an, [Kairo, Mathabi\' Akhbarul Yaum: 1997 M], jilid XIV, halaman 8712).',
        },
        {
          'type': 'text',
          'content': 'Syekh Sya\'rawi menawarkan distingsi yang sangat tajam sekaligus cerdas dalam membedah makna Syifa\' dan Rahmat pada ayat tersebut. Beliau memandang Syifa\' sebagai penawar bagi luka atau penyakit yang tengah merundung jiwa, sementara Rahmat adalah bentuk proteksi Ilahi yang menjaga kita agar tidak terperosok kembali ke dalam kesalahan yang sama.\n\nDalam konteks ini, tadarus Al-Qur\'an menghasilkan dampak ganda: ia tidak hanya menyembuhkan penyakit hati yang sedang diderita, tetapi juga menjadi perisai preventif yang menghidupkan hati dan menjaganya dari mati suri.\n\nNamun, apakah kesembuhan (syifa\') dari Al-Qur\'an itu hanya bersifat maknawi (psikologis) untuk penyakit hati dan gangguan jiwa, sehingga membebaskan seorang Muslim dari kecemasan, kebingungan, dan rasa iri, serta mencabut akar dendam, kedengkian, dan hasad dari dalam jiwanya, ataukah ia juga merupakan obat bagi hal-hal fisik dan penyakit badan?\n\nMenurut Syekh Asy-Sya\'rawi, pendapat yang paling kuat, bahkan yang dipastikan tanpa keraguan sedikit pun, adalah bahwa Al-Qur\'an merupakan \'obat\' dalam makna yang umum dan menyeluruh bagi kata tersebut. Artinya, Al-Qur\'an adalah obat bagi penyakit fisik (materiil) sebagaimana ia juga obat bagi penyakit jiwa (maknawi).\n\nLalu, apa yang dimaksud dengan hidupnya hati lantaran bertadarus Al-Qur\'an? Hati yang hidup adalah hati yang mudah merasakan sensitivitas spiritual. Ia akan mudah merasakan manis, pahit, dan asamnya spiritualitas sehingga hatinya merasakan kelezatan ibadah dan kepedihan atas kesempatan ibadah yang luput.\n\nSyekh Ibnu Athaillah As-Sakandari dalam Al-Hikam-nya menyebut salah satu dari beberapa tanda kematian hati:',
        },
        {
          'type': 'arabic',
          'content': 'مِنْ عَلَامَاتِ مَوْتِ الْقَلْبِ عَدَمُ الْحُزْنِ عَلَى مَا فَاتَكَ مِنَ الْمُوَافَقَاتِ، وَتَرْكُ النَّدَمِ عَلَى مَا فَعَلْتَ مِنْ وُجُودِ الزَّلَّاتِ',
          'latin': '',
          'translation': 'Artinya, "Salah satu tanda kematian hati adalah tidak adanya kesedihan atas kesempatan ibadah yang terlewat dan tidak adanya penyesalan atas kekhilafan yang pernah dilakukan."',
        },
        {
          'type': 'text',
          'content': 'Syekh Ibnu Ajibah menyebutkan tiga tanda kematian hati: pertama, tidak bersedih atas kesempatan ibadah yang terlewat; kedua, tidak menyesali perbuatan buruk yang telah dilakukan; dan ketiga, persahabatan dengan orang-orang lalai yang juga mati hatinya. (Syekh Ibnu Ajibah, Iqazhul Himam, [Beirut, Darul Fikr: tanpa tahun], jilid. I, halaman 82).\n\nArtinya, dengan tadarus Al-Qur\'an, seorang Muslim hatinya akan hidup sehingga mudah merasakan sensitivitas spiritual, seperti bersedih atas kesempatan ibadah yang terlewat; menyesali perbuatan buruk yang telah dilakukan; dan tidak akan bersahabat dengan orang-orang lalai yang juga mati hatinya.\n\nDengan demikian, dapat disimpulkan bahwa tadarus Al-Qur\'an bukanlah sekadar rutinitas membaca saja, akan tetapi merupakan aksi nyata sebuah metode pengobatan menyeluruh yang bekerja secara serentak. Ia berfungsi sebagai solusi penyembuhan untuk penyakit hati yang ada, sekaligus menjadi benteng pencegahan agar hati tidak mengalami degradasi spiritual atau bahkan \'mati suri\', sehingga akan hidup dan mudah merasakan sensitivitas spiritual, seperti bersedih atas kesempatan ibadah yang terlewat; menyesali perbuatan buruk yang telah dilakukan; dan tidak akan bersahabat dengan orang-orang lalai yang juga mati hatinya.\n\nMenyitir perspektif Syekh Asy-Sya\'rawi, tadarus menawarkan kesehatan yang bersifat holistik; ia memulihkan stabilitas psikologis dari jeratan kecemasan serta hasad, dan secara pasti diyakini membawa energi pemulihan bagi kesehatan fisik. Melalui keselarasan syifa\' dan rahmat ini, Al-Qur\'an hadir sebagai penjaga keutuhan manusia secara lahir dan batin.\n\nMomentum Ramadhan adalah ruang terbaik untuk menghidupkan hati dan memperkuat iman melalui tadarus yang konsisten. Mari kita sambut ajakan kebaikan ini dengan tekad yang bulat untuk memperbanyak membaca Al-Qur\'an di sepanjang bulan suci ini. Wallahu a\'lam.\n\nMuhammad Ryan Romadhon, Alumni Ma\'had Aly Al-Iman Bulus, Purworejo, Jawa Tengah.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Agar Puasa Tak Hanya Menjadi Rutinitas Tahunan',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Coba kita renungkan sejenak, sudah berapa kali Ramadhan datang lalu pergi meninggalkan kita? Setiap tahun kita menjalani puasa, menahan lapar dan dahaga sejak terbit fajar hingga terbenam matahari. Namun, pertanyaannya, apa hasil yang benar-benar kita peroleh dari puasa tersebut?\n\nApakah ia telah membentuk kita menjadi pribadi yang lebih baik, lebih taat, dan lebih bertakwa, ataukah ia berlalu begitu saja tanpa meninggalkan bekas yang berarti dalam sikap dan perilaku kita?\n\nJangan-jangan, puasa yang selama ini kita laksanakan hanyalah rutinitas tahunan yang dikerjakan berulang-ulang, tetapi belum sungguh-sungguh menghadirkan nilai dan perubahan nyata dalam kehidupan kita.\n\nBahkan bisa jadi, yang kita peroleh dari puasa tersebut hanyalah rasa lapar dan dahaga semata, sebagaimana peringatan Rasulullah SAW:',
        },
        {
          'type': 'arabic',
          'content': 'كَمْ مِنْ صَائِمٍ لَيْسَ لَهُ مِنْ صِيَامِهِ إِلَّا الْجُوعُ',
          'latin': '',
          'translation': 'Artinya: "Betapa banyak orang yang berpuasa, namun tidak ada yang ia peroleh dari puasanya selain rasa lapar." (HR. Ahmad)',
        },
        {
          'type': 'text',
          'content': 'Padahal, tujuan utama puasa bukan sekadar menahan diri dari makan dan minum, melainkan untuk menumbuhkan ketakwaan. Hal ini ditegaskan langsung oleh Allah Subhanahu wa ta\'ala dalam firman-Nya:',
        },
        {
          'type': 'arabic',
          'content': 'يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوْا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَۙ',
          'latin': '',
          'translation': 'Artinya: "Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa." (QS. Al-Baqarah [2]: 183).',
        },
        {
          'type': 'text',
          'content': 'Ayat tersebut bukan sekadar ayat perintah puasa Ramadhan, akan tetapi juga menjelaskan tujuan atau hikmah di balik disyariatkannya puasa. Sebagaimana dijelaskan oleh Ibnu Asyur dalam tafsirnya, at-Tahrir Wat Tanwir.',
        },
        {
          'type': 'arabic',
          'content': 'Menurut beliau frasa  (لعل) pada kalimat (لَعَلَّكُمْ تَتَّقُوْنَۙ) "agar kamu bertakwa" merupakan mus\'taarah yang mempunyai makna (كَي / agar) sebagai isti\'arah tabi\'iyyah, dan adakalanya merupakan tamtsiliyyah (penyerupaan), yaitu dengan menyerupakan keadaan Allah dalam menghendaki terwujudnya ketakwaan melalui pensyariatan puasa seperti orang yang berharap kepada orang lain agar melakukan suatu perbuatan.',
          'latin': '',
        },
        {
          'type': 'text',
          'content': 'Pengertian takwa menurut syariat adalah menjauhi perbuatan maksiat. Puasa menjadi sebab terhindar dari maksiat karena maksiat itu terbagi menjadi dua macam: Pertama, maksiat yang  efektif dapat ditinggalkan dengan tafakur atau perenungan, seperti meminum khamar, judi, mencurian, dan merampas. Meninggalkannya dapat terwujud dengan merenungkan janji pahala bagi yang meninggalkannya, ancaman siksa bagi pelakunya, serta nasihat untuk mengambil ibrah atau pelajaran dari keadaan orang lain.\n\nKedua, maksiat yang bersumber dari dorongan-dorongan tabiat, seperti perbuatan yang timbul dari amarah dan syahwat , yang terkadang sulit ditinggalkan hanya dengan perenungan atau tafakur semata. Maka puasa sebagai sarana untuk menghindarinya, karena puasa menyeimbangkan kekuatan-kekuatan tabi\'at yang menjadi pendorong terjadinya maksiat-maksiat tersebut.\n\nDengan puasa, seorang Muslim derajatnya akan naik dari jurang keterjerumusan materi menuju puncak alam ruhani. Puasa menjadi sarana latihan diri dengan sifat-sifat malaikat dan kebangkitan dari debu kekeruhan sifat-sifat kebinatangan .(Muhammad at-Thahir Asyur, At-Tahrir wa At-Tanwir, [Tunis, Dar-At-Tunisia: 1984 M], juz II, halaman 158).\n\nOleh karena itu, dapat kita pahami bahwa nilai puasa sejatinya terletak pada sejauh mana puasa tersebut mampu melahirkan ketakwaan dan membentuk perubahan akhlak, sehingga mengantarkan seorang Muslim menjadi pribadi yang lebih baik, lebih bertakwa, dan semakin dekat kepada Allah.\n\nTujuan mulia ini tidak akan terwujud apabila puasa hanya dikerjakan sebatas sah menurut fikih semata. Lebih dari itu, puasa perlu dihayati dan diamalkan secara menyeluruh dengan menjaga lahir dan batin. Dalam hal ini, al-Imam al-Ghazali memberikan enam tuntunan penting agar puasa benar-benar bernilai dan membekas. Berikut kami ringkaskan enam poin tersebut sebagaimana termaktub dalam kitab Mauizhatul Mu\'minin min Ihya\' \'Ulumid Din:\n\nPertama, menundukkan pandangan dan menahannya dari memandang segala sesuatu yang tercela dan dibenci, serta dari segala hal yang dapat menyibukkan hati dan melalaikan dari mengingat Allah Ta\'ala.\n\nKedua, menjaga lisan dari perkataan sia-sia, dusta, ghibah, adu domba, ucapan keji, sikap kasar, pertengkaran, dan perdebatan.\n\nKetiga, menjaga pendengaran dari mendengarkan segala hal yang dibenci, karena setiap sesuatu yang diharamkan untuk diucapkan, haram pula untuk didengarkan.\n\nKeempat, menahan seluruh anggota tubuh seperti tangan dan kaki dari perbuatan dosa dan hal-hal yang dibenci, serta menjaga perut dari perkara syubhat ketika berbuka. Tidak ada artinya puasa, menahan diri dari makanan halal, lalu berbuka dengan yang haram. Perumpamaan orang yang seperti ini adalah orang yang membangun istana tetapi meruntuhkan sebuah kota.\n\nKelima, tidak berlebihan dalam mengonsumsi makanan halal saat berbuka hingga perut menjadi penuh. Bagaimana mungkin tujuan puasa yaitu menundukkan musuh Allah  dan mematahkan syahwat dapat terwujud, jika seorang yang berpuasa justru mengganti seluruh kekurangan makannya di siang hari saat berbuka, bahkan menambahnya dengan beragam jenis hidangan? Padahal tujuan puasa adalah mengosongkan perut dan melemahkan hawa nafsu, agar jiwa menjadi kuat dalam ketakwaan.\n\nKeenam, setelah berbuka, hendaknya hatinya berada dalam keadaan gelisah, harap-harap cemas karena ia tidak mengetahui apakah puasanya diterima sehingga ia termasuk orang-orang yang didekatkan kepada Allah, ataukah ditolak sehingga ia termasuk orang-orang yang dimurkai. Sikap seperti ini seharusnya menyertai setiap ibadah yang telah ia selesaikan. (Muhammad Jamaluddin al-Qasimi, Mauizhatul Mu\'minin min Ihya\' \'Ulumid Din, [Beirut, Darul Kutub al-Ilmiyah: 1995] halaman 61-62).\n\nDengan demikian, apabila puasa dilaksanakan dengan memenuhi syarat dan rukunnya serta disempurnakan dengan adab-adabnya, maka tujuan puasa yang hakiki, yaitu melahirkan ketakwaan, akan benar-benar terwujud. Puasa menjadi sarana transformasi diri yang melatih manusia untuk mengendalikan nafsu terhadap perkara yang halal, agar lebih mampu menahan diri dari yang haram. Dari sinilah tumbuh kemampuan mengontrol diri dan bersikap lurus meskipun tanpa pengawasan manusia, lebih menjaga lisan dan emosi, serta hidup sederhana dalam konsumsi tanpa berlebih-lebihan.\n\nUstadz Muhamad Hanif Rahman, Dosen Ma\'had Aly Al-Iman Bulus dan Pengurus LBM NU Purworejo.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Mengenal Hikmah Disyariatkannya Puasa',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Salah satu ciri khas keutamaan bulan Ramadhan yang dapat kita rasakan bersama adalah keberadaannya yang selalu menjadi istimewa bagi umat Islam. Pada bulan mulia ini, kita bisa melihat masjid seolah menjadi lebih hidup, Al-Qur\'an lebih sering dibaca dan terdengar di mana-mana, dan ibadah ditunaikan dengan lebih khusuk.\n\nDan dari sekian banyak ibadah yang kita lakukan di dalamnya, puasa menjadi ibadah yang paling menonjol dan lebih terasa daripada ibadah-ibadah yang lain. Mengapa demikian? Karena puasa tidak hanya tentang menahan diri dari makan dan minum saja, tetapi juga melibatkan pengendalian diri secara menyeluruh, baik fisik maupun mental.\n\nKarena itu, penting bagi kita untuk mengetahui lebih lanjut perihal hikmah-hikmah diwajibkannya puasa. Sehingga kita tidak hanya merasakan lapar dan dahaga, tetapi benar-benar meresapi makna puasa dengan sebenar-benarnya.\n\nHikmah Disyariatkannya Puasa\n\nSebagaimana kita ketahui bersama, puasa memiliki hikmah yang sangat luar biasa. Ia merupakan sarana untuk membersihkan diri dari dosa, meningkatkan ketakwaan, dan mendekatkan diri kepada Allah swt. Puasa melatih kita untuk bersabar, jujur, dan peduli terhadap sesama. Ia juga menjadi momentum untuk introspeksi diri, memperbaiki diri, dan meningkatkan kualitas ibadah kita.\n\nSetidaknya ada empat hikmah luar biasa di balik disyariatkannya puasa yang penting untuk kita ketahui bersama, sebagaimana disampaikan oleh Syekh Muhammad Ali as-Shabuni dalam kitab Rawai\'ul Bayan fi Tafsiri Ayatil Ahkam halaman 93, yaitu:\n\n1. Bentuk Penghambaan\n\nHikmah pertama dari puasa adalah wujud penghambaan diri kepada Allah SWT. Puasa mengajarkan kita untuk tunduk dan patuh sepenuhnya terhadap perintah-Nya, serta menjauhi segala larangan-Nya. Dalam puasa, seseorang harus meninggalkan makan, minum, dan berbagai kenikmatan yang sebenarnya halal bukan karena tidak mampu, tetapi semata-mata karena ketaatan kepada Allah. Hal ini berdasarkan salah satu hadits Rasulullah, yaitu:',
        },
        {
          'type': 'arabic',
          'content': 'قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ يَقُولُ اللَّهُ عَزَّ وَجَلَّ الصَّوْمُ لِي وَأَنَا أَجْزِي بِهِ يَدَعُ طَعَامَهُ وَشَرَابَهُ وَشَهْوَتَهُ مِنْ أَجْلِي',
          'latin': '',
          'translation': 'Artinya, "Rasulullah SAW bersabda: Allah Azza wa Jalla berfirman: \'Puasa itu untuk-Ku, dan Aku sendiri yang akan membalasnya. Dia meninggalkan makanan, minuman, dan syahwatnya karena Aku\'." (HR. Ahmad).',
        },
        {
          'type': 'text',
          'content': 'Melalui puasa, manusia dilatih untuk benar-benar merasakan dirinya sebagai hamba yang senantiasa berserah diri kepada keputusan dan ketetapan Allah. Dan inilah puncak tujuan dari semua ibadah, yaitu menumbuhkan sikap tunduk, patuh, dan pasrah kepada Rabb semesta alam.\n\n2. Mendidik Jiwa dan Melatih Kesabaran\n\nHikmah kedua dari disyariatkannya puasa adalah untuk mendidik jiwa dan melatihnya agar terbiasa bersabar serta tabah dalam menghadapi kesulitan di jalan Allah. Puasa menumbuhkan kekuatan tekad dan kemauan, serta menjadikan manusia mampu mengendalikan hawa nafsu dan keinginannya. Dengan berpuasa, kita tidak menjadi budak jasmani atau tawanan syahwat, tetapi mampu berjalan di atas petunjuk syariat Islam dan akal sehat.\n\n3. Menumbuhkan Rasa Cinta, Kasih Sayang, dan Empati\n\nHikmah ketiga dari disyariatkannya puasa adalah menumbuhkan rasa cinta, kasih sayang, dan kepekaan sosial dalam diri manusia. Puasa menjadikan hati lebih lembut, jiwa lebih peka, dan perasaan lebih halus terhadap penderitaan orang lain. Karena rasa lapar dan haus yang kita rasakan tidak hanya bentuk pengekangan diri, melainkan sarana untuk membangkitkan energi spiritual agar kita mampu merasakan apa yang dirasakan oleh saudara-saudara kita yang kekurangan.\n\nDari sinilah tumbuh dorongan untuk berbagi, mengulurkan bantuan, menghapus air mata orang-orang yang lemah, serta meringankan beban mereka yang tertimpa kesusahan. Dengan puasa pula, ia akan menjadi pribadi yang dermawan dan penuh empati, karena hati yang telah ditempa oleh ibadah puasa tidak akan tega berpaling dari penderitaan sesama.\n\nDemikianlah salah satu contoh yang pernah dilakukan oleh Nabi Yusuf alaihissalam. Meski ia pernah memegang perbendaharaan negaranya, namun ia tidak pernah makan hingga sangat kenyang dan senantiasa merasakan lapar, hingga suatu saat ia ditanya perihal alasan dari perbuatan itu, maka ia menjawab:',
        },
        {
          'type': 'arabic',
          'content': 'أَخْشَى إِنْ أَنَا شَبعْتُ أَنْ أَنْسَى الْجَائِعَ',
          'latin': '',
          'translation': 'Artinya, "Aku khawatir jika aku kenyang, aku akan melupakan orang yang kelaparan."',
        },
        {
          'type': 'text',
          'content': '4. Menyucikan Jiwa dan Mencapai Derajat Takwa\n\nHikmah keempat dari disyariatkannya puasa adalah untuk menyucikan jiwa manusia dengan menanamkan rasa takut kepada Allah, serta kesadaran akan pengawasan-Nya baik dalam keadaan tersembunyi maupun terang-terangan, puncaknya adalah menjadikan orang-orang yang berpuasa menjadi hamba yang benar-benar bertakwa kepada Allah, sebagaimana ditegaskan dalam Al-Qur\'an, Allah berfirman:',
        },
        {
          'type': 'arabic',
          'content': 'يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ',
          'latin': '',
          'translation': 'Artinya, "Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa." (QS. Al-Baqarah: 183).',
        },
        {
          'type': 'text',
          'content': 'Dan ini pula alasan mengapa Allah SWT pada ayat di atas menegaskan bahwa tujuan puasa adalah agar manusia meraih derajat takwa, bukan agar manusia merasakan lapar, dahaga, atau sekadar memperoleh manfaat jasmani, yaitu agar tumbuh dalam dirinya sikap takwa yang sejati. Dan inilah manfaat terbesar yaitu kesiapan jiwa untuk kembali menjadi hamba Allah yang senantiasa berkomitmen untuk menjalani perintah-Nya, dan konsisten menjauhi larangan-Nya.\n\nDemikianlah kultum Ramadhan tentang hikmah disyariatkannya puasa. Semoga apa yang telah dijelaskan ini tidak hanya berhenti sebagai pengetahuan dan nasihat di lisan saja, tetapi benar-benar meresap ke dalam hati dan terwujud dalam perilaku keseharian kita. Aamiin ya Rabbal \'alamin.\n\nSunnatullah, Pengajar di Pondok Pesantren Al-Hikmah Darussalam Durjan Kokop Bangkalan Jawa Timur.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Puasa dan Transformasi Spiritual Seorang Mukmin',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Puasa dalam Islam bukan sekadar ibadah fisik, melainkan menjadi suatu bentuk komunikasi spiritual dengan Allah SWT serta alat untuk mempererat hubungan sosial antarsesama. Puasa menjadi ibadah yang memiliki makna spiritual yang sangat dalam, terutama sebagaimana dijelaskan dalam Al-Qur\'an dan dicontohkan oleh Rasulullah SAW. Jika dirincikan, ada beberapa aspek peningkatan spiritualitas melalui puasa:\n\n1. Meningkatkan Ketakwaan\n\nDalam Surah Al-Baqarah/2: 183. Allah berfirman:',
        },
        {
          'type': 'arabic',
          'content': 'يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوْا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَۙ ۝١٨٣',
          'latin': '',
          'translation': 'Artinya, "Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa."',
        },
        {
          'type': 'text',
          'content': 'Allah mewajibkan puasa kepada kalian sebagaimana puasa telah diwajibkan kepada orang-orang beriman terdahulu, yaitu para pemeluk agama-agama sejak zaman Nabi Adam a.s. Puasa melatih hubungan batin dengan Allah, menguatkan kontrol diri, dan menumbuhkan kepekaan sosial secara bersamaan. Puasa disebut sebagai ibadah yang khusus diperuntukkan bagi Allah, meskipun pada dasarnya semua ibadah dilakukan untuk-Nya.\n\nMenurut Imam Al-Qurthubi, hal ini karena dua alasan. Pertama, puasa lebih efektif dalam menahan dan mengendalikan hawa nafsu dibandingkan dengan ibadah lainnya. Kedua, puasa merupakan rahasia antara seorang hamba dan Tuhannya. Tidak ada yang benar-benar mengetahui seseorang berpuasa atau tidak selain Allah.\n\nKarena sifatnya yang tersembunyi inilah, puasa menjadi ibadah yang sangat khusus bagi-Nya, berbeda dengan ibadah lain yang tampak secara lahiriah dan terkadang dapat disusupi oleh riya. (Wahbah az-Zuhaili, Tafsir Al-Munir, [Jakarta: Gema Insani, 2013], hlm. 383).\n\n2. Membersihkan Hati dan Jiwa\n\nAllah SWT menyerukan untuk berpuasa karena puasa mengandung penyucian, pembersihan, dan penjernihan diri dari kebiasaan-kebiasaan yang jelek dan akhlak tercela. (Ibnu Katsir, Tafsir Ibnu Katsir, terj. M. Abdul Ghoffar, (Jakarta: Pustaka Imam Asy-Syafi\'i, 2004), jil. 1, hlm. 343).\n\nPuasa melatih kesabaran, keikhlasan, dan kejujuran dalam diri seorang hamba. Sebab puasa adalah ibadah yang tersembunyi; hanya diri sendiri dan Allah yang benar-benar mengetahui kualitasnya. Mereka yang menjalankannya dengan sungguh-sungguh sesuai tuntunan syariat akan secara bertahap membentuk pribadi yang jujur, berintegritas, percaya diri, dan berakhlak mulia.\n\nJika kita menyadari bahwa kita sedang berada di bawah pengawasan Allah sebagai orang yang berusaha mencapai derajat muttaqin, kita dapat secara otomatis menghilangkan sifat-sifat yang tidak baik.\n\n3. Melatih Empati dan Kepedulian\n\nDengan merasakan lapar dan dahaga, seseorang lebih mampu memahami penderitaan orang lain. Ini mendorong tumbuhnya rasa syukur dan kepedulian sosial. Orang-orang yang rajin berpuasa akan menumbuhkan kepedulian sosial yang mendalam dan selalu membantu orang-orang miskin.\n\nKondisi seperti ini mendorong kita untuk mengingat puasa sebagai contoh sifat penyayang dan pengasih Allah Ta\'ala. Puasa memunculkan perasaan yang peka dan melahirkan rasa kasih sayang yang mendorong seseorang untuk memberi.\n\nKetika lapar, ia akan teringat kepada orang-orang yang sengsara yang tidak punya makanan, sehingga puasa mendorongnya untuk membantu mereka, dan ini adalah salah satu ciri orang-orang beriman. Puasa merealisasikan konsep persamaan antara si kaya dan si miskin, antara orang terpandang dan rakyat biasa, dalam pelaksanaan satu kewajiban yang sama. (Wahbah az-Zuhaili, Tafsir Al-Munir, hlm. 379-380).\n\n4. Mendekatkan Diri kepada Allah\n\nPuasa sering disertai dengan peningkatan ibadah lain seperti shalat malam, membaca Al-Qur\'an, dan dzikir. Menjaga lidah dari ucapan yang sia-sia, dusta, gunjingan, fitnah, menyinggung perasaan orang lain, menimbulkan pertengkaran dan perdebatan yang berlarut-larut. Sebagai gantinya, hendaknya seseorang memaksa lidahnya agar diam serta menyibukkannya dengan dzikir. (Al-Ghazali, Ihya\' Ulum al-din, diterjemahkan Muhammad Al-Baqir, Rahasia Puasa dan Zakat: Mencapai Kesempurnaan Ibadah, Jakarta Selatan: Mizan, 2015, hlm. 30)\n\nTerutama pada bulan Ramadhan, suasana spiritual menjadi lebih kuat dan mendalam. Kepada Allah dan tilawah Al-Qur\'an. Demikian itulah puasanya lidah. Bisyr bin Harits meriwayatkan ucapan Sufyan, "Gunjingan merusak puasa." Ketika berpuasa, seseorang menyadari nikmat Allah swt yang telah diberikan kepadanya, berupa nikmat kenyang dan hilangnya dahaga. Sesungguhnya suatu nikmat tidak dapat diketahui kadar dan nilainya kecuali setelah merasakan kehilangan. (Izzuddin bin Abdissalam, Maqashid As-Shaum, [Beirut: Darul Kutub Ilmiyah. Cet. 1, tt], hlm. 17).\n\nRasulullah SAW bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'إِنَّمَا الصَّوْمُ جُنَّةٌ، فَإِذَا كَانَ أَحَدُكُمْ صَائِمًا فَلَا يَرْفُثْ وَلَا يَجْهَلْ، وَإِنِ امْرُؤٌ قَاتَلَهُ أَوْ شَاتَمَهُ فَلْيَقُلْ: إِنِّي صَائِمٌ، إِنِّي صَائِمٌ',
          'latin': '',
          'translation': 'Artinya, "Sesungguhnya puasa adalah tabir penghalang (dari perbuatan dosa). Maka, apabila seseorang dari kamu sedang berpuasa, janganlah dia mengucapkan sesuatu yang keji dan janganlah dia berbuat jahil. Dan, seandainya ada orang lain yang mengajaknya berkelahi ataupun menunjukkan cercaan kepadanya, hendaknya dia berkata, \'Aku dengan berpuasa. Aku sedang berpuasa." (HR Imam Malik dalam Muwaththa).',
        },
        {
          'type': 'text',
          'content': '5. Menguatkan Disiplin dan Pengendalian Diri\n\nPuasa melatih kita untuk hidup lebih disiplin, mengendalikan keinginan, dan menata diri sejak waktu sahur hingga berbuka. Ia bukan sekadar menahan lapar dan dahaga, tetapi juga latihan menahan hawa nafsu dan menjaga hati. Betapa banyak orang berpuasa, namun tidak mendapatkan apa-apa selain rasa haus dan lapar, karena mereka hanya menahan diri secara fisik, bukan secara lahir dan batin.\n\nMenjauhi hal-hal yang membatalkan puasa secara kasatmata harus disertai dengan meninggalkan hal-hal yang merusak nilai puasa secara batin, seperti berkata dusta, bergunjing, dan berbuat maksiat. Puasa hanya berlangsung dalam waktu yang terbatas, satu bulan dalam setahun, dan sering terasa begitu cepat berlalu. Karena itu, jangan sampai bulan yang penuh berkah, kebaikan, dan rahmat ini berlalu tanpa meninggalkan bekas kebaikan dalam diri kita. Wallahu a\'lam.\n\nBesse Herlina Taha, Pembina Pondok Pesantren Al-Ikhlas Ujung Bone.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Hikmah Puasa dalam Membentuk Kesadaran Sosial',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Kita semua mengetahui dan menyaksikan dengan mata kepala sendiri bahwa kehidupan ini tidak pernah berjalan di atas garis yang sama rata. Ada di antara kita  yang sejak lahir hidup dalam kelapangan, rezekinya mengalir, makan dan minumnya terjamin, bahkan tidak pernah mengenal bagaimana rasanya lapar dan dahaga.\n\nNamun di sisi lain, ada pula hamba Allah yang sejak kecil harus berjibaku dengan kekurangan, bersahabat akrab dengan lapar dan dahaga. Kelompok masyarakat terpinggirkan mereka adalah orang-orang yang mengalami keterbatasan akses terhadap sumber daya, pendidikan, layanan kesehatan, pekerjaan layak, serta perlindungan sosial. Kondisi ini membuat mereka rentan terhadap kemiskinan struktural, ketidakadilan, dan diskriminasi sosial.\n\nSyariat Islam tidak membedakan hamba-hamba-Nya dengan pilih kasih. Yang kaya tidak diberi keringanan hanya karena hartanya, dan yang miskin tidak dibebaskan hanya karena keadaannya.\n\nSeperti perintah puasa Ramadhan yang mewajibkan seluruh lapisan umat. Kaya atau miskin, kuat atau lemah, terbiasa kenyang ataupun akrab dengan lapar, semuanya diwajibkan berpuasa.\n\nKewajiban puasa yang menyeluruh ini mengandung hikmah sebab-sebab ketakwaan, yaitu menjalankan perintahnya dan menjauhi larangannya. Ibnu Sa\'di dalam tafsirnya saat menjelaskan ayat perintah puasa Ramadhan yakni firman Allah surat Al-Baqarah ayat 183.',
        },
        {
          'type': 'arabic',
          'content': 'يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوْا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَۙ',
          'latin': '',
          'translation': 'Artinya: "Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa." (Al-Baqarah:183)',
        },
        {
          'type': 'arabic',
          'content': 'Beliau mengatakan bahwa kalimat (لَعَلَّكُمْ تَتَّقُونَ) "agar kamu bertakwa" merupakan hikmah disyariatkannya puasa, sebab puasa merupakan lebih besar-besarnya ketakwaan, karena di dalam mengerjakan puasa termuat melaksanakan perintah-Nya dan menjauhi larangannya, di antaranya orang kaya dapat ikut merasakan pedihnya yang dirasakan oleh orang-orang miskin, dan dari itu akan menimbulkan empati dan keprihatinannya terhadap orang miskin. Berikut selengkapnya:',
          'latin': '',
        },
        {
          'type': 'arabic',
          'content': 'ومنها: أن الغني إذا ذاق ألم الجوع، أوجب له ذلك، مواساة الفقراء المعدمين، وهذا من خصال التقوى',
          'latin': '',
          'translation': 'Artinya: "Di antara sebab-sebab ketakwaan adalah ketika orang kaya merasakan pedihnya rasa lapar, hal itu akan mendorongnya untuk ikut merasakan dan menghibur penderitaan kaum fakir yang serba kekurangan. Dan sikap seperti ini termasuk bagian dari sifat ketakwaan." (Abdurrahman As-Sa\'di, Tafsir as-Sa\'di, [Muassasah Ar-Risalah: 2000] juz I halaman 87).',
        },
        {
          'type': 'text',
          'content': 'Puasa adalah sarana terbaik untuk menumbuhkan pada diri orang kaya perasaan seperti yang dirasakan orang miskin dan paling efektif untuk membangkitkan dorongan kasih sayang, rahmat, dan kepedulian sosial pada orang kaya. Dengan demikian, kasih sayang dan empati di antara kaum Muslimin akan benar-benar terwujud dan inilah pilar tegaknya masyarakat Islam. Berikut keterangan kitab Fiqih Manhaji:',
        },
        {
          'type': 'arabic',
          'content': 'إن من أهم المبادئ التي ينهض عليها المجتمع الإسلامي تراحم المسلمين وتعاطفهم، وهيهات أن يرحم الغني الفقير رحمة صادقة من غير أن يتخلله شعور بآلام الفقر وشدته، ومرارة الجوع وضراوته. وشهر الصيام خير ما يكسب الغني شعور الفقير، ويجعله يعيش معه في آلامه وحرمانه، ومن ثم كان الصوم خير ما يثير في نفس الأغنياء دوافع العطف والرحمة والمواساة',
          'latin': '',
          'translation': 'Artinya: "Di antara prinsip paling penting yang menjadi pilar tegaknya masyarakat Islam adalah adanya kasih sayang dan empati di antara kaum Muslimin. Dan mustahil orang kaya dapat benar-benar mengasihi orang miskin dengan tulus, tanpa ikut merasakan penderitaan kemiskinan dan beratnya hidup, pahitnya rasa lapar dan kerasnya tekanannya. Bulan puasa adalah sarana terbaik untuk menumbuhkan pada diri orang kaya perasaan seperti yang dirasakan orang miskin, membuatnya seakan hidup bersama mereka dalam penderitaan dan kekurangan. Oleh karena itu, puasa menjadi ibadah yang paling efektif dalam membangkitkan dorongan kasih sayang, rahmat, dan kepedulian sosial pada orang-orang kaya." (Musthafa al-Khin, Musthafa al-Bugha dan Ali As-Syarbini, Al-Fiqh al-Manhaji [Damaskus, Darul Qalam, cetakan ketiga: 1992] juz II, halaman 76).',
        },
        {
          'type': 'text',
          'content': 'Dalam Kitab Shiyam karya Darul Ifta al-Mishriyyah yang diterbitkan pada 1426 H, halaman 18, dijelaskan bahwa puasa merupakan sarana untuk menumbuhkan rasa syukur. Dengan menahan diri dari berbagai nikmat yang Allah anugerahkan, seperti makan, minum, dan seluruh syahwat yang dibolehkan, seseorang menjadi lebih sadar akan nilai besar nikmat-nikmat tersebut.\n\nMelalui pengalaman menahan diri itu, manusia menyadari betapa ia sangat membutuhkan nikmat Allah serta memahami beratnya penderitaan orang-orang yang terhalang dari kenikmatan tersebut. Puasa menghadirkan kesadaran batin bahwa apa yang selama ini dinikmati bukanlah sesuatu yang sepele.\n\nDari sinilah jiwa terdorong untuk mensyukuri Sang Pemberi nikmat Yang Maha Besar lagi Maha Kaya, yang memberi tanpa mengharap balasan. Hati pun dipenuhi rasa rahmat, kasih sayang, dan empati terhadap kaum fakir, miskin, dan mereka yang membutuhkan.\n\nDan makna-makna inilah yang ditunjukkan oleh firman Allah Ta\'ala di penutup ayat-ayat tentang puasa:',
        },
        {
          'type': 'arabic',
          'content': 'وَلَعَلَّكُمْ تَشْكُرُون',
          'latin': '',
          'translation': 'Artinya, "Agar kamu bersyukur," (QS. Al-Baqarah: 185).',
        },
        {
          'type': 'text',
          'content': 'Dari uraian tersebut dapat dipahami bahwa puasa Ramadhan bukan sekadar ibadah individual yang berdimensi ritual, melainkan ibadah sosial yang memiliki daya besar dalam membangun empati dan kepedulian terhadap kelompok masyarakat terpinggirkan, terutama kaum fakir dan miskin.\n\nMelalui rasa lapar dan dahaga yang dirasakan bersama, orang-orang yang hidup dalam kelapangan diajak untuk merasakan sekelumit penderitaan yang setiap hari dialami oleh mereka yang kekurangan.\n\nDari sinilah tumbuh rasa iba, kasih sayang, dan dorongan untuk berbagi sebagai bagian dari manifestasi ketakwaan yang hakiki. Selain itu, puasa dapat juga melahirkan rasa syukur kepada Allah atas nikmat-Nya, sekaligus menggerakkan hati untuk lebih peduli terhadap sesama.\n\nUstadz Muhamad Hanif Rahman, Dosen Ma\'had Aly Al-Iman Bulus dan Pengurus LBM NU Purworejo.',
        },
      ]
    },
    {
      'title': 'Kultum Ramadhan: Puasa sebagai Rem Pengendali Tabdzir',
      'date': '12 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': 'Salah satu pelajaran penting dari puasa adalah kemampuan membedakan antara kebutuhan dan sekadar keinginan. Saat lapar dan dahaga terasa, kita tidak hanya belajar menahan diri, tetapi juga diajak merasakan bagaimana saudara-saudara kita yang hidup dalam keterbatasan menjalani hari-harinya. Dalam bahasa Arab, puasa disebut ash-shiyam, yang berarti menahan diri dari sesuatu dan meninggalkannya (Wahbah az-Zuhaili, Tafsir Al-Munir, Jakarta: Gema Insani, 2013, hlm. 377).\n\nNamun, realitasnya, Ramadhan kadang justru identik dengan lonjakan konsumsi. Hidangan berbuka berlimpah, makanan tersisa dan terbuang. Fenomena ini tentu tidak sejalan dengan ruh puasa yang mengajarkan kesederhanaan dan pengendalian diri. Dalam ajaran Islam, perilaku seperti ini dikenal dengan istilah tabdzir. Islam tidak melarang menikmati rezeki yang halal, tetapi melarang sikap berlebihan dan menghambur-hamburkan.\n\nSecara bahasa, tabdzir berarti menghamburkan atau menyia-nyiakan harta. Secara etimologis, ia bermakna membelanjakan harta secara boros dan tidak tepat guna. Dalam Islam, pengelolaan harta diatur dengan prinsip keseimbangan, tidak kikir, tidak pula berlebihan (Wahbah az-Zuhaili, Tafsir Al-Munir, [Jakarta: Gema Insani, 2013], hlm. 76).\n\nAllah SWT menegaskan dalam Surah Al-Isra\' ayat 26–27:',
        },
        {
          'type': 'arabic',
          'content': 'وَاٰتِ ذَا الْقُرْبٰى حَقَّهٗ وَالْمِسْكِيْنَ وَابْنَ السَّبِيْلِ وَلَا تُبَذِّرْ تَبْذِيْرًا ۝٢٦ اِنَّ الْمُبَذِّرِيْنَ كَانُوْٓا اِخْوَانَ الشَّيٰطِيْنِۗ وَكَانَ الشَّيْطٰنُ لِرَبِّهٖ كَفُوْرًا ۝٢٧',
          'latin': '',
          'translation': 'Artinya, "Berikanlah kepada kerabat dekat haknya, (juga kepada) orang miskin, dan orang yang dalam perjalanan. Janganlah kamu menghambur-hamburkan (hartamu) secara boros. Sesungguhnya para pemboros itu adalah saudara-saudara setan dan setan itu sangat ingkar kepada Tuhannya."',
        },
        {
          'type': 'text',
          'content': 'Ibnu Mas\'ud RA menjelaskan bahwa tabdzir adalah menggunakan harta untuk hal yang tidak benar. Mujahid berkata, "Jika seseorang menggunakan seluruh hartanya untuk kebaikan, maka ia bukan mubadzir. Namun, jika ia menggunakan satu mud saja untuk hal yang tidak benar, maka ia termasuk mubadzir." Diriwayatkan pula dari Ali RA, bahwa harta yang digunakan secara wajar untuk diri dan keluarga serta untuk sedekah adalah milik kita; sedangkan yang dipakai untuk pamer adalah bagian setan (Wahbah az-Zuhaili, Tafsir Al-Munir, hlm. 77).\n\nDalam hadits riwayat Ibnu Mas\'ud RA, Rasulullah SAW bersabda:',
        },
        {
          'type': 'arabic',
          'content': 'حَدَّثَنَا عَبْد اللَّهِ قَالَ قَرَأْتُ عَلَى أَبِي حَدَّثَنَا أَبُو عُبَيْدَةَ الْحَدَّادُ قَالَ حَدَّثَنَا سُكَيْنُ بْنُ عَبْدِ الْعَزِيزِ الْعَبْدِيُّ حَدَّثَنَا إِبْرَاهِيمُ الْهَجَرِيُّ عَنْ أَبِي الْأَحْوَصِ عَنْ عَبْدِ اللَّهِ بْنِ مَسْعُودٍ قَالَ قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ مَا عَالَ مَنْ اقْتَصَدَ',
          'latin': '',
          'translation': 'Maknanya, harta yang digunakan secara proporsional, terencana, dan tidak mengikuti hawa nafsu akan menjaga seseorang dari kemiskinan akibat pemborosan.',
        },
        {
          'type': 'text',
          'content': 'Prof. Quraish Shihab menjelaskan bahwa tabdzir dipahami sebagai pengeluaran yang bukan pada tempatnya. Jika seluruh harta dibelanjakan untuk kebaikan, itu bukan pemborosan. Abu Bakar RA menyerahkan seluruh hartanya untuk jihad, dan \'Utsman RA membelanjakan separuh hartanya; keduanya tidak dinilai sebagai mubadzir. Sebaliknya, membasuh wajah lebih dari tiga kali saat wudhu dinilai pemborosan, walau airnya dari sungai yang mengalir. Jadi, pemborosan lebih terkait ketidaktepatan penggunaan, bukan sekadar jumlah (Muhammad Quraish Shihab, Tafsir Al-Mishbah, Vol. 7, 2005, hlm. 451–452).\n\nDi sinilah puasa menjadi sarana koreksi diri. Dengan menahan diri secara sadar, kita belajar bahwa keinginan bisa dikendalikan. Pengendalian diri dibutuhkan oleh siapa pun, kaya atau miskin, tua atau muda, lelaki atau perempuan, dalam setiap zaman (Muhammad Quraish Shihab, Tafsir Al-Mishbah, Vol. 1, 2005, hlm. 401).\n\nNilai ini seharusnya tidak berhenti pada bulan Ramadhan. Membelanjakan harta sesuai prioritas, tidak menyia-nyiakan makanan, dan berbagi kepada sesama adalah wujud nyata dari puasa yang membentuk karakter. Dengan demikian, Ramadhan tidak hanya mengubah pola makan, tetapi juga menata pola hidup. Wallahu a\'lam.\n\nUstadzah Besse Herlina Taha, Pembina Pondok Pesantren Al-Ikhlas Ujung Bone.',
        },
      ]
    },
  ];

  
  final List<Map<String, dynamic>> _khutbahIdulFitriMenu = [
    {
      'title': 'Khutbah Idul Fitri: Menjadi Orang yang Takwa Setelah Puasa Sebulan Penuh',
      'date': '1 Syawal 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Khutbah Idul Fitri 1444 H kali ini akan mengangkat tema tentang takwa. Pasalnya, kewajiban puasa sangat erat kaitannya dengan takwa. Di ujung ayat [al-Baqarah ayat 183], dijelaskan bahwa puncak dari sebuah puasa ialah ketakwaan pada Allah swt. Untuk itu, seyogianya kita merenungi makna takwa setelah setelah berpuasa sebulan penuh.

Untuk itu Khutbah Idul Fitri ini akan mengangkat tema berjudul, ”Menjadi Orang yang Takwa Setelah Puasa Sebulan Penuh.”

Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُ أَكْبَرُ (×٩) لَا اِلَهَ اِلَّا اللهُ وَاللهُ أَكْبَرُ، اَلله ُأكْبَرُ وَلِلّهِ الْحَمْدُ. اَللهُ أَكْبَرُ مَا فَعَلَ الْمُسْلِمُوْنَ فِيْ نَهَارِ رَمَضَانَ بِصِيَامٍ، وَفِيْ لَيْلِهِ بِقِيَامٍ، اَللهُ أَكْبَرُ مَا azْدَحَمَ الْمُصَلُّوْنَ فِي الْمَسَاجِدِ لِصَلَاةِ التَّرَاوِيْحِ بِخُشُوْعٍ وَاهْتِمَامٍ. اَللهُ أَكْبَرُ ×٣. اللهُ أَكْبَرُ مَا سَبَقُوْا فِي الْمَسَاجِدِ لِلسُّجُوْدِ وَالْقُعُوْدِ وَالْقِيَامِ. اَللهُ أَكْبَرُ مَا بَذَلَ الْمُسْلِمُوْنَ إِلَى إِخْوَانِهِمْ بِإِعْطَاءٍ وَمَحَبَّةٍ وَاحْتِرَامٍ. اللهُ أَكْبَرُ ×٣. اللهُ أَكْبَرُ مَا تَكُفُّ الْأَكُفُّ إِلَى اللهِ فِيْ هَذَا الشَّهْرِ بِالدُّعَاءِ وَالتَّضَرُّعِ لِكَشْفِ الضُّرِّ وَالْآلَمِ، اَللهُ أَكْبَرُ ×٣. وَللهِ الْحَمْدُ. اَلْحَمْدُ للهِ، اَلْحَمْدُ للهِ الَّذِيْ هَدَانَا لِهَذَا وَمَا كُنَّا لِنَهْتَدِيَ لَوْ لَا أَنْ هَدَانَا اللهُ. أَشْهَدُ أَنْ لَا اِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، اِرْغَامًا لِمَنْ جَحَدَ بِهِ وَكَفَرَ. وَأَشْهَدُ أَنَّ سَيِّدَنَا وَمَوْلَانَا مُحمَّداً عَبْدُهُ وَرَسُوْلُهُ سَيِّدُ الْخَلَائِقِ وَالْبَشَرِ. اَللّهُمَّ صَلِّ وسَلِّمْ وَبارِكْ عَلَى سَيِّدِنا مُحَمَّدٍ وَعَلَى اٰلِهِ وَأَصْحَابِهِ وَالتَّابِعينَ بِإِحْسَانٍ إِلَى يَوْمِ الدِّيْنِ. اَمَّا بَعْدُ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ، اِتَّقُوْا اللهَ وَرَاقِبُوْا مُرَاقَبَةَ مَنْ يَعْلَمُ أَنَّهُ يَرَاهُ. وَاعْلَمُوْا أَنَّهُ لَا يَضُرُّ وَلَا يَنْفَعُ وَلَا يُعْطِيْ وَلَا يَمْنَعُ سِوَاهُ. قَالَ اللهُ تَعَالَى: أَعُوذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيمِ. وَمَنْ تَابَ وَعَمِلَ صَالِحًا فَإِنَّهُ يَتُوبُ إِلَى اللَّهِ مَتَابًا (الفرقان: ٧١). أَمَّا بَعْدُ''',
        },
        {
          'type': 'text',
          'content': '''Hadirin jamaah Idul Fitri yang berbahagia

Puasa adalah salah satu amalan penting dalam agama Islam. Di bulan Ramadan, umat Muslim di seluruh dunia mempraktikkan puasa dengan menahan diri dari makan, minum, dan hubungan suami-istri dari fajar hingga terbenam matahari. Namun, tujuan utama dari puasa dalam Islam bukan hanya untuk menahan diri dari kebutuhan fisik, tetapi juga untuk mencapai tujuan spiritual dan moral tertentu, yaitu takwa.

Puasa merupakan salah satu cara untuk mencapai takwa. Dengan menahan diri dari makan dan minum, seseorang dapat mengembangkan kemampuan untuk menahan diri dari hal-hal yang tidak diinginkan, seperti kemarahan dan godaan untuk melakukan perbuatan buruk. Ketika seseorang berpuasa, ia dapat mengalami pengalaman fisik yang membuatnya sadar akan ketidaknyamanan yang dirasakan oleh orang-orang yang kurang beruntung. Hal ini dapat membangkitkan empati dan membantu seseorang untuk lebih menghargai karunia Allah SWT.''',
        },
        {
          'type': 'arabic',
          'content': '''يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوْا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَۙ''',
          'latin': '',
          'translation': '''Artinya, "Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa." (QS. Al-Baqarah [2]: 183)''',
        },
        {
          'type': 'text',
          'content': '''Dari ayat di atas dijelaskan bahwa kewajiban puasa dimaksudkan untuk “agar kamu bertakwa”, yakni terhindar dari segala macam sanksi dan dampak buruk, baik duniawi maupun ukhrawi. Lantas apa yang dimaksud dengan takwa itu? Pun bagaimana konsep takwa yang sebenarnya? Pun apa itu hakikat takwa?

Hakikat Takwa yang Sebenarnya

Takwa adalah salah satu konsep utama dalam Islam yang berhubungan dengan iman dan akhlak.

Dalam Al-Qur'an, taqwa disebutkan sebanyak 251 kali. Salah satu ayat yang menjelaskan makna taqwa adalah dalam surah Q.S Al-Baqarah [2] ayat 197;''',
        },
        {
          'type': 'arabic',
          'content': '''الْحَجُّ أَشْهُرٌ مَعْلُومَاتٌ ۚ فَمَنْ فَرَضَ فِيهِنَّ الْحَجَّ فَلَا رَفَثَ وَلَا فُسُوقَ وَلَا جِدَالَ فِي الْحَجِّ ۗ وَمَا تَفْعَلُوا مِنْ خَيْرٍ يَعْلَمْهُ اللَّهُ ۗ وَتَزَوَّدُوا فَإِنَّ خَيْرَ الزَّادِ التَّقْوَىٰ ۚ وَاتَّقُونِ يَا أُولِي الْأَلْبَابِ''',
          'latin': '',
          'translation': '''Artinya, "(Musim) haji itu (berlangsung pada) bulan-bulan yang telah dimaklumi. Siapa yang mengerjakan (ibadah) haji dalam (bulan-bulan) itu, janganlah berbuat rafaṡ, berbuat maksiat, dan bertengkar dalam (melakukan ibadah) haji. Segala kebaikan yang kamu kerjakan (pasti) Allah mengetahuinya. Berbekallah karena sesungguhnya sebaik-baik bekal adalah takwa. Bertakwalah kepada-Ku wahai orang-orang yang mempunyai akal sehat." (QS. Al-Baqarah [2]: 197)''',
        },
        {
          'type': 'text',
          'content': '''Hadirin jamaah Idul Fitri yang berbahagia

Pada sisi lain, makna taqwa adalah kesadaran dan ketakutan seseorang terhadap Allah SWT. Taqwa menuntut seseorang untuk senantiasa memperbaiki diri dan meningkatkan iman serta akhlaknya. Taqwa juga menuntut seseorang untuk menghindari segala bentuk perbuatan dosa dan melakukan segala bentuk perbuatan yang diperintahkan oleh Allah SWT.

Hal ini sebagaimana dijelaskan oleh Syekh Ash-Shawi dalam Kitab Hasyiyatus Shawi, juz I;''',
        },
        {
          'type': 'arabic',
          'content': '''امتثال أمر الله واجتناب نواهيه''',
          'latin': '',
          'translation': '''Artinya: "Melaksanakan perintah Allah dan menjauhi larangannya."''',
        },
        {
          'type': 'text',
          'content': '''Pada sisi lain, menurut Ibnu Rajab dalam kitabnya Jami' al-Ulum wal Hikam mendefinisikan takwa sebagai menjaga diri dari kejahatan Allah SWT dan melakukan segala perbuatan yang diridhai oleh-Nya. Taqwa juga mengandung makna takut kepada Allah SWT dan menjaga diri dari segala bentuk godaan dan nafsu yang dapat memperburuk akhlak.

Lebih lanjut, dalam Q.S Ali Imran [3] ayat 102, Allah mengajak orang yang beriman, bertakwalah kepada Allah sebenar-benarnya takwa. Pasalnya, takwa menjadi bekal yang sangat penting bagi setiap manusia, terutama bagi yang beriman. Di akhirat kelak, takwa menjadi modal besar seorang muslim untuk mendapatkan pertolongan Allah.''',
        },
        {
          'type': 'arabic',
          'content': '''يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوا اتَّقُوا اللّٰهَ حَقَّ تُقٰىتِهٖ وَلَا تَمُوْتُنَّ اِلَّا وَاَنْتُمْ مُّسْلِمُوْنَ''',
          'latin': '',
          'translation': '''Artinya, "Wahai orang-orang yang beriman, bertakwalah kepada Allah dengan sebenar-benar takwa kepada-Nya dan janganlah kamu mati kecuali dalam keadaan muslim." (QS. Ali Imran [3]: 102)''',
        },
        {
          'type': 'text',
          'content': '''Menurut Imam Qurthubi dalam Tafsir al Jāmi’ li Ahkāmi al Qur’ani, bahwa arti takwa dalam ayat tersebut ialah bersikap patuh kepada Allah Swt. Di sisi lain, berdasarkan riwayat dari Imam Bukhari, bersumber dari Murrah, bahwa yang dimaksud dengan “sebenar-benar takwa”, taat kepada Allah, tidak melaksanakan maksiat. Pun orang yang takwa senantiasa mengingat Allah, tidak melupakannya. Orang yang takwa juga senantiasa bersyukur atas segala nikmat Allah.''',
        },
        {
          'type': 'arabic',
          'content': '''رَوَى الْبُخَارِيُّ عَنْ مُرَّةَ عَنْ عَبْدِ اللَّهِ قَالَ قَالَ رَسُولُ اللَّهِ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ: حَقَّ تُقَاتِهِ أَنْ يُطَاعَ فَلَا يُعْصَى وَأَنْ يُذْكَرَ فَلَا يُنْسَى وَأَنْ يُشْكَرَ فَلَا يُكْفَرَ''',
          'latin': '',
          'translation': '''Artinya: "Bersumber dari Imam Bukhari, dari Murrah dari Abdullah ia berkata, telah bersabda Rasulullah SAW, [yang dimaksud dengan sebenar-benar takwa ialah, bahwa taat pada Allah, dan tidak melakukan maksiat, dan bahwa senantiasa mengingat Allah, tidak melupakannya, dan senantiasa bersyukur, tidak kufur akan nikmat Allah."''',
        },
        {
          'type': 'text',
          'content': '''Selanjutnya, menurut Ibnu Abbas yang dimaksud dengan “takwa dengan sebenar-benarnya”, ialah tidak berlaku maksiat kepada Allah kendati sekejap mata sekali pun. Artinya, orang yang takwa tidak akan melakukan kemaksiatan pada Allah. Pun senantiasa melaksanakan segala perintah Allah SWT.''',
        },
        {
          'type': 'arabic',
          'content': '''وَقَالَ ابْنُ عَبَّاسٍ: هُوَ أَلَّا يُعْصَى طَرْفَةَ عَيْنٍ''',
          'latin': '',
          'translation': '''Artinya: "Berkata Ibnu Abbas, takwa ialah tidak melakukan kemaksiatan, kendatipun sekejap mata."''',
        },
        {
          'type': 'text',
          'content': '''Sementara itu Profesor Quraish Shihab dalam kitab Tafsir Al Misbah mengatakan bahwa para sahabat Nabi, semisal Abdullah bin Mas’ud memahami makna “حَقَّ تُقٰىتِهٖ” ialah menaati Allah dan tidak sekalipun durhaka, mengingat-Nya dan tidak sesaat pun lupa, serta mensyukuri nikmat-Nya dan tak satupun yang diingkari. Inilah puncak tertinggi dari sebuah ketakwaan seorang hamba.

Hadirin jamaah shalat Idul Fitri yang berbahagia.

Dengan demikian, melalui ayat ini, semua muslim dianjurkan untuk berjalan pada jalan takwa. Pun semua muslim dianjurkan untuk berjalan pada takwa, semua dianjurkan untuk menuju puncak tertinggi dari takwa. Pasalnya, seorang yang senantiasa istiqamah dalam jalan takwa, niscaya akan memperoleh puncak tertinggi sebuah takwa—tidak maksiat, tidak lupa, dan senantiasa bersyukur pada Allah.

Sementara kata Imam Nawawi dalam Kitab Riyadhus Shalihin, dalam kitab ini, terdapat bab yang membahas tentang takwa dan bagaimana cara mengembangkan takwa dalam diri. Ia menyebutkan bahwa takwa adalah kunci utama menuju kebahagiaan di dunia dan akhirat. Imam Nawawi juga mengutip hadis Nabi Muhammad SAW berikut:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنْ أَبِيْ هُرَيْرَةَ رَضِيَ اللهُ عَنْهُ قَالَ قَالَ رَسُوْلُ اللهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ: اِتَّقِ اللهَ حَيْثُمَا كُنْتَ وَأَتْبِعِ السَّيِّئَةَ الْحَسَنَةَ تَمْحُهَا وَخَالِقِ النَّاسَ بِخُلُقٍ حَسَنٍ''',
          'latin': '',
          'translation': '''Artinya: "Dari Abu Hurairah RA, ia berkata: Rasulullah SAW bersabda: 'Bertakwalah kepada Allah di mana saja kamu berada, dan ikutilah perbuatan buruk dengan perbuatan yang baik maka itu akan menghapuskannya, dan pergaulilah manusia dengan akhlak yang baik.'" (HR. Tirmidzi)''',
        },
        {
          'type': 'text',
          'content': '''Dari kutipan ayat dan hadis di atas, dapat disimpulkan bahwa takwa merupakan kewajiban bagi setiap muslim untuk selalu meningkatkan kesadarannya tentang keberadaan Allah dan berusaha untuk taat pada-Nya dalam segala hal, baik dalam perkara ibadah maupun muamalah. Dalam arti yang lebih luas, takwa juga mencakup akhlak yang baik dan perilaku yang sesuai dengan ajaran Islam.''',
        },
        {
          'type': 'arabic',
          'content': '''جَعَلَنَا اللهُ وَإِيَّاكُمْ مِنَ العَائِدِيْنَ وَالفَائِزِيْنَ وَالْمَقْبُوْلِيْنَ كُلُّ عَامٍ وَأَنْتُمْ بِخَيْرٍ. آمين. بِسْمِ اللهِ الرَّحْمَنِ الرَّحِيْمِ، وَسَارِعُوْا إِلَى مَغْفِرَةٍ مِنْ رَبِّكُمْ وَجَنَّةٍ عَرْضُهَا السَّمَوَاتُ وَالْأَرْضُ أُعِدَّتْ لِلْمُتَّقِيْنَ. وَقُلْ رَّبِّ اغْفِرْ وَارْحَمْ وَأَنْتَ خَيْرُ الرَّاحِمِيْنَ''',
          'latin': '',
          'translation': '',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَللَّهُ أَكْبَرُ (×٧)، اَلْحَمْدُ ِللهِ رَبِّ الْعَالَمِيْنَ، أَشْهَدُ أَنْ لاَإِلَهَ إِلاَّ اللهُ وَحْدَهُ لاَشَرِيْكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ، اَللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَأَصْحَابِهِ أَجْمَعِيْنَ. اَمَّا بَعْدُ''',
          'latin': '',
          'translation': '',
        },
        {
          'type': 'arabic',
          'content': '''فَيَاعِبَادَ اللهِ اِتَّقُوْا اللهَ حَقَّ تُقَاتِهِ وَلاَ تَمُوْتُنَّ إِلاَّ وَأَنْتُمْ مُسْلِمُوْنَ قَالَ اللهُ تَعَالىَ فِيْ كِتَابِهِ اْلعَظِيْمِ “إِنَّ اللهَ وَمَلاَئِكَتَهُ يُصَلُّوْنَ عَلىَ النَّبِيِّ، يَا أَيُّهَا الَّذِيْنَ أَمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا”. اَللَّهُمَّ صَلِّ وَسَلِّمْ عَلىَ سَيِّدِنَا مُحَمَّدٍ وَعَلىَ اَلِهِ وَأًصْحَابِهِ أَجْمَعِيْنَ. وَالتَّابِعِيْنَ وَتَابِعِ التَّابِعِيْنَ وَمَنْ تَبِعَهُمْ بِإِحْسَانٍ إِلىَ يَوْمِ الدِّيْن. وَعَلَيْنَا مَعَهُمْ بِرَحْمَتِكَ يَا اَرْحَمَ الرَّاحِمِيْنَ''',
          'latin': '',
          'translation': '',
        },
        {
          'type': 'arabic',
          'content': '''اَللَّهُمَّ اغْفِرْ لِلْمُسْلِمِيْنَ وَاْلمُسْلِماَتِ, وَاْلمُؤْمِنِيْنَ وَاْلمُؤْمِنَاتِ, اَلْأَحْيَاءِ مِنْهُمْ وَاْلأَمْوَاتِ إِنَّكَ سَمِيْعٌ قَرِيْبٌ مُجِيْبُ الدَّعَوَاتِ يَا قَاضِيَ اْلحَاجَاتِ. رَبَّنَا افْتَحْ بَيْنَنَا وَبَيْنَ قَوْمِنَا بِاْلحَقِّ وَأَنْتَ خَيْرُ اْلفَاتِحِيْنَ. رَبَّنَا أَتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي اْلآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ''',
          'latin': '',
          'translation': '',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ إِنَّ اللهَ يَأْمُرُ بِالْعَدْلِ وَاْلإِحْسَانِ وَإِيْتَاءِ ذِي اْلقُرْبىَ وَيَنْهىَ عَنِ اْلفَحْشَاءِ وَاْلمُنْكَرِ وَاْلبَغْيِ يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ. فَاذْكُرُوْا اللهَ يَذْكُرْكُمْ وَادْعُوْهُ يَسْتَجِبْ لَكُمْ وَلَذِكْرُ اللهِ أَكْبَرُ''',
          'latin': '',
          'translation': '',
        },
        {
          'type': 'text',
          'content': '''Ustadz Zainuddin Lubis, pegiat kajian tafsir dan hadits, tinggal di Jakarta.''',
        },
      ]
    },
    {
      'title': 'Khutbah Idul Fitri: Evaluasi Capaian Ibadah di Bulan Ramadhan',
      'date': '1 Syawal 1444 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Naskah khutbah Idul Fitri 1444 H berikut ini mengajak kepada para jamaah untuk kembali melakukan evaluasi dan koreksi terhadap ibadah-ibadah yang dilakukan selama bulan Ramadhan. Sebab manusi terbaik adalah mereka yang hendak mengoreksi semua perbuatan-perbuatan yang pernah dia lakukan, untuk membenahi atau lebih menyempurnakan di hari-hari berikutnya.

Teks khutbah berikut ini dengan judul, “Khutbah Idul Fitri 1444 H: Evaluasi Capaian Ibadah di Bulan Ramadhan”. Untuk mencetak naskah khutbah Idul Fitri ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat! (Redaksi).''',
        },
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُ أَكْبَرُ ، اَللهُ أَكْبَرُ ، اَللهُ أَكْبَرُ . اَللهُ أَكْبَرُ ، اَللهُ أَكْبَرُ ، اَللهُ أَكْبَرُ . اَللهُ أَكْبَرُ ، اَللهُ أَكْبَرُ ، اَللهُ أَكْبَرُ ، وَلِلهِ الْحَمْدُ. اَللهُ أَكْبَرُ كَبِيرًا وَالْحَمْدُ لِلهِ كَثِيرًا وَسُبْحَانَ اللهِ بُكْرَةً وَأَصِيلًا. لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ، صَدَقَ وَعْدَهُ، وَنَصَرَ عَبْدَهُ، وَهَزَمَ الْأَحْزَابَ وَحْدَهُ. لَا إِلَهَ إِلَّا اللهُ وَلَا نَعْبُدُ إِلَّا إِيَّاهُ مُخْلِصِيْنَ لَهُ الدِّيْنَ وَلَوْ كَرِهَ الْكَافِرُوْنَ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلهِ الَّذِيْ جَعَلَ شَهْرَ الصِّيَامَ غُزَّةَ وَجْهِ الْعَامِّ، وَأَجْزَلَ فِيْهِ الْفَضَائَلَ وَالْاِنْعَامِ، وَفَضَّلَ أَيَّامَهُ عَلَى سَائِرِ الْأَيَّامِ. وَالصَّلَاةُ وَالسَّلَامُ عَلَى سَيِّدِنَا مُحَمَّدٍ اَلْمَبْعُوْثِ عَلَى جَمِيْعِ الْأَنَامِ، وَعَلَى أَلِهِ وَأَصْحَابِهِ هُدَاةِ الْأَنَامِ وَمَصَابِيْحِ الظَّلَامِ. أَشْهَدُ أَنْ لَااِلَهَ اِلَّا الله وَحْدَهُ لَا شَرِيْكَ لَهُ اِلَهٌ تَفَرَّدَ بِالْكَمَالِ وَالتَّمَامِ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ أَفْضَلُ مَنْ صَلَّى وَصَامَ. اَللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلىَ أَلِهِ وَصَحْبِهِ الَّذِيْ شُبِّهُوْا بِالْأَنْجَامِ، فَمَنْ تَبِعَهُ فَقَدْ نَالَ سُبُلَ التَّامِّ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ، فَيآ أَيُّهَا الْمُؤْمِنُوْنَ رَحِمَكُمْ اللهُ، أُوْصِيْكُمْ وَاِيَايَ بِتَقْوَى اللهِ وَطَاعَتِهِ، بِامْتِثَالِ أَوَامِرِهِ وَاجْتِنَابِ نَوَاهِيْهِ. قَالَ اللهُ تَعَالَى فِيْ كِتَابِهِ الْكَرِيْمِ: يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ وَلا تَمُوتُنَّ إِلاَّ وَأَنْتُمْ مُسْلِمُونَ. وَقَالَ أَيْضًا: وَلِتُكْمِلُوا الْعِدَّةَ وَلِتُكَبِّرُوا اللهِ عَلَى مَا هَدَاكُمْ وَلَعَلَّكُمْ تَشْكُرُونَ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Ma’asyiral Muslimin jamaah shalat idul Fitri yang dirahmati Allah
Alhamdulillah merupakan kata kunci pertama yang harus kita tanamkan dalam jiwa kita sebagai bentuk syukur dan terimakasih kepada Allah swt, yang masih berkenan memberikan kita semua kenikmatan-kenikmatan yang tidak terhitung jumlahnya. Di antaranya adalah memberikan kita kesempatan untuk bisa berpuasa di bulan Ramadhan, dan menunaikan ibadah shalat sunnah hari raya bersama-sama. Shalawat dan salam mari kita mohonkan  agar terlimpah kepada junjungan kita Nabi Muhammad saw beserta para sahabat dan pengikutnya.

Melalui mimbar yang mulia ini, khatib mengajak kepada diri khatib sendiri, keluarga, dan semua jamaah yang turut hadir pada pelaksanaan shalat idul fitri ini, untuk kembali melakukan evaluasi terkait ibadah-ibadah dan tanggungjawab di bulan Ramadhan. Sudahkah semua hak-hak bulan Ramadhan kita penuhi dengan tepat dan benar. Harapannya bisa menjadi perantara untuk kembali menyadarkan kita semua perihal pentingnya menjadi manusia bertakwa, yang selalu mengerjakan kewajiban dan tanggungjawabnya.

Saat ini kita semua baru saja berpisah dengan bulan Ramadhan. Ia telah pergi, dan kita tidak tahu apakah masih diberi kesempatan oleh Allah untuk berjumpa kembali dengannya di tahun berikutnya atau tidak, sebab kematian tidak ada yang tahun kapan waktunya. Bisa saja, ia lebih dahulu menjemput kita semua sebelum datangnya bulan Ramadhan.

Ma’asyiral Muslimin jamaah shalat idul Fitri yang dirahmati Allah
Dalam melakukan evaluasi capaian di bulan Ramadhan, setidaknya ada dua golongan yang bisa kita renungi.

Pertama, yaitu orang-orang yang mengerti dan memenuhi hak-hak Ramadhan sebagaimana mestinya. Orang-orang ini menjalankan puasa di siang harinya, beribadah di malam harinya, makan dari harta yang halal, menjauhi larangan-larangan Allah. Mereka melakukan ibadah dengan sungguh-sunguh untuk mendapatkan ridha dari Allah swt, dan tentu akan mendapatkan balasan dari-Nya.

Kelompok pertama ini merupakan golongan yang sangat beruntung. Mereka akan menjadi orang istimewa di sisi Allah dengan mendapatkan balasan dan pahala yang sangat banyak dari-Nya. Ibaratnya, mereka akan memanen hasilnya di akhirat dari tanaman yang pernah ia tanam di dunia. Peluh keringat ibadah yang mereka lakukan di dunia, akan dibayar gajinya dengan bayaran yang berlipat ganda oleh Allah swt. Hal ini sebagaimana ditegaskan dalam firma-Nya, yaitu:''',
        },
        {
          'type': 'arabic',
          'content': '''وَإِنَّمَا تُوَفَّوْنَ أُجُورَكُمْ يَوْمَ الْقِيَامَةِ فَمَنْ زُحْزِحَ عَنِ النَّارِ وَأُدْخِلَ الْجَنَّةَ فَقَدْ فَازَ''',
          'latin': '''''',
          'translation': '''Artinya, “Dan hanya pada hari kiamat sajalah diberikan dengan sempurna balasanmu. Barangsiapa dijauhkan dari neraka dan dimasukkan ke dalam surga, sungguh, dia memperoleh kemenangan.” (QS Ali ‘Imran: 185).''',
        },
        {
          'type': 'text',
          'content': '''Merujuk pendapat Imam Fakhruddin Ar-Razi dalam kitab Tafsir Mafatihul Ghaib, puncak balasan atas ibadah yang dilakukan oleh setiap manusia adalah akhirat. Mereka akan mendapatkan balasan yang sangat istimewa dari Allah atas capaiannya selama di dunia, berupa surga yang dipenuhi dengan kenikmatan di dalamnya. Mereka akan mendapatkan kebahagiaan tanpa kesedihan, aman tanpa rasa takut, dan kesenangan tanpa rasa takut hilangnya nikmat tersebut.

Semua ini akan diberikan kepada kelompok pertama, yaitu orang-orang yang mengerti dan memenuhi hak-hak Ramadhan dengan tepat dan benar. Mereka menjalankan puasa di siang harinya, beribadah di malam harinya, makan dari harta yang halal, dan menjauhi larangan-larangan Allah.

Ma’asyiral Muslimin jamaah shalat idul Fitri yang dirahmati Allah
Kedua adalah kelompok orang-orang yang tidak menghormati bulan Ramadhan dan tidak memenuhi hak-haknya. Mereka tidak memenuhi hak-haknya dan tidak mengindahkan perintah Allah karena sombong. Mereka tidak menunaikan puasa dan lain sebagainya karena tidak percaya kepada perintah-Nya dan faktor keangkuhan mereka. Kelompok seperti ini sebagaimana difirmankan dalam Al-Qur’an, yaitu:''',
        },
        {
          'type': 'arabic',
          'content': '''إِنَّ الَّذِينَ كَذَّبُوا بِآيَاتِنَا وَاسْتَكْبَرُوا عَنْهَا لَا تُفَتَّحُ لَهُمْ أَبْوَابُ السَّمَاءِ وَلَا يَدْخُلُونَ الْجَنَّةَ حَتَّى يَلِجَ الْجَمَلُ فِي سَمِّ الْخِيَاطِ وَكَذَلِكَ نَجْزِي الْمُجْرِمِينَ''',
          'latin': '''''',
          'translation': '''Artinya, “Sesungguhnya orang-orang yang mendustakan ayat-ayat Kami dan menyombongkan diri terhadapnya, tidak akan dibukakan pintu-pintu langit bagi mereka, dan mereka tidak akan masuk surga, sebelum unta masuk ke dalam lubang jarum. Demikianlah Kami memberi balasan kepada orang-orang yang berbuat jahat.” (QS Al-A’raf: 40).''',
        },
        {
          'type': 'text',
          'content': '''Mengutip Syekh Mutawalli Asy-Sya’rawi dalam tafsirnya, Tafsir wa Khawatirul Umam, orang-orang yang tidak mengindahkan perintah Allah, tidak menjalankan perintah-Nya karena sombong dan tidak percaya pada ayat-ayat-Nya, maka mereka akan mendapatkan siksa yang sangat pedih. Mereka tidak akan merasakan surga dan segala kenikmatannya, bahkan dimasukkan ke dalam neraka yang penuh siksa.

Mudah-mudahan kita semua digolongkan oleh Allah swt sebagai golongan pertama, yaitu orang-orang yang benar-benar memenuhi semua hak-hak Ramadhan, sehingga bisa mendapatkan balasan yang istimewa dari-Nya, dan dihjauhkan dari golongan yang kedua, yaitu orang-orang yang tidak memenuhi kewajibannya dan menyombongkan diri pada ayat-ayat-Nya.

Sebab, bulan Ramadhan merupakan madrasah bagi kita untuk memperbaiki diri sendiri. Jika pada bulan ini kita tidak berhasil memperbaiki diri, lantas di bulan manakah kita bisa melakukannya? Jika di bulan Ramadhan tidak kita dapatkan rahmat dan anugerah dari Allah, lantas di bulan manakah semua itu akan diberikan dengan mudah kepada kita semua? Jika di bulan Ramadhan tidak kita raih ampunan dari-Nya, lantas di bulan apakah ampunan itu bisa kita dapatkan dengan gampang?

Ma’asyiral Muslimin jamaah shalat Idul Fitri rahimakumullah
Itulah dua golongan yang bisa kita jadikan cerminan dalam melakukan evaluasi capaian ibadah selama bulan Ramadhan. Lantas, kita ada di bagian yang mana? Jawaban dari pertanyaan tersebut ada dalam diri kita sendiri.

Demikian khutbah hari raya Idul Fitri pada pagi hari ini. Semoga bermanfaat dan membawa keberkahan kepada kita semua, serta menjadi penyebab diterimanya semua amal ibadah yang kita lakukan selama bulan Ramadhan.''',
        },
        {
          'type': 'arabic',
          'content': '''جَعَلَنَا اللهُ وَاِيَّاكُمْ مِنَ الْعَائِدِيْنَ وَالْفَائِزِيْنَ وَالْمَقْبُوْلِيْنَ كُلَّ عَامٍ وَأَنْتُمْ بِخَيْرٍ. بَارَكَ اللهُ لِيْ وَلَكُمْ فِيْ هَذَا الْيَوْمِ الْكَرِيْمِ، وَنَفَعَنِيْ وَاِيَاكُمْ بِمَا فِيْهِ مِنَ الصَّلَاةِ وَالزَّكَاةِ وَالصَّدَقَةِ وَتِلَاوَةِ الْقُرْاَنِ وَجَمِيْعِ الطَّاعَاتِ، وَتَقَبَّلَ مِنِّيْ وَمِنْكُمْ جَمِيْعَ أَعْمَالِنَا إِنَّهُ هُوَ الْحَكِيْمُ الْعَلِيْمُ، أَقُوْلُ قَوْلِيْ هَذَا وَأَسْتَغْفِرُ اللهَ لِيْ وَلَكُمْ، فَاسْتَغْفِرُوْهُ، اِنَّهُ هُوَ الْغَفُوْرُ الرَّحِيْمُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُ أَكْبَرُ، اَللهُ أَكْبَرُ، اَللهُ أَكْبَرُ. اَللهُ أَكْبَرُ، اَللهُ أَكْبَرُ، اَللهُ أَكْبَرُ. اَللهُ أَكْبَرُ وَلِلهِ الْحَمْدُ. اَللَّهُ أَكْبَرُ كَبِيرًا، وَالْحَمْدُ لِلَّهِ كَثِيرًا، وَسُبْحَانَ اللَّهِ بُكْرَةً وَأَصِيلًا. أَشْهَدُ أَنْ لَااِلَهَ اِلَّا الله وَحْدَهُ لَا شَرِيْكَ لَهُ، اِلَهٌ لَمْ يَزَلْ عَلَى كُلِّ شَيْءٍ وَكِيْلًا. وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ وَحَبِيْبُهُ وَخَلِيْلُهُ، أَكْرَمِ الْأَوَّلِيْنَ وَالْأَخِرِيْنَ، اَلْمَبْعُوْثِ رَحْمَةً لِلْعَالَمِيْنَ. اللهم صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلىَ أَلِهِ وَأَصْحَابِهِ وَمَنْ كَانَ لَهُمْ مِنَ التَّابِعِيْنَ، صَلَاةً دَائِمَةً بِدَوَامِ السَّمَوَاتِ وَالْأَرْضِيْنَ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ: فَيَا أَيُّهَا الْحَاضِرُوْنَ اتَّقُوا اللَّهَ حَقَّ تُقَاتِهِ وَذَرُوْا الْفَوَاحِشَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ. وَحَافِظُوْا عَلَى الطَّاعَةِ وَحُضُوْرِ الْجُمْعَةِ وَالْجَمَاعَةِ وَالصَّوْمِ وَجَمِيْعِ الْمَأْمُوْرَاتِ وَالْوَاجِبَاتِ. وَاعْلَمُوْا أَنَّ اللهَ أَمَرَكُمْ بِأَمْرٍ بَدَأَ بِنَفْسِهِ. وَثَنَى بِمَلَائِكَةِ الْمُسَبِّحَةِ بِقُدْسِهِ. اللهم اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ اَلْأَحْيَاءِ مِنْهُمْ وِالْأَمْوَاتِ. اللهم ادْفَعْ عَنَّا الْبَلَاءَ وَالْغَلَاءَ وَالْوَبَاءَ وَالْفَحْشَاءَ وَالْمُنْكَرَ وَالْبَغْيَ وَالسُّيُوْفَ الْمُخْتَلِفَةَ وَالشَّدَائِدَ وَالْمِحَنَ، مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ، مِنْ بَلَدِنَا هَذَا خَاصَةً وَمِنْ بُلْدَانِ الْمُسْلِمِيْنَ عَامَةً، اِنَّكَ عَلَى كُلِّ شَيْءٍ قَدِيْرٌ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ، اِنَّ اللهَ يَأْمُرُكُمْ بِالْعَدْلِ وَالْاِحْسَانِ وَاِيْتَاءِ ذِيْ الْقُرْبَى وَيَنْهَى عَنِ الْفَحْشَاءِ وَالْمُنْكَرِ وَالْبَغْيِ، يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ. فَاذْكُرُوْا اللهَ الْعَظِيْمَ يَذْكُرُكُمْ وَلَذِكْرُ اللهِ أَكْبَرُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''​​​​​​​

Ustadz Sunnatullah, Pengajar di Pondok Pesantren Al-Hikmah Darussalam Durjan Kokop Bangkalan Jawa Timur''',
        },
      ]
    },
    {
      'title': 'Khutbah Idul Fitri: Mudik Ke Surga',
      'date': '1 Syawal 1444 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Naskah khutbah Idul Fitri kali ini mengajak kepada khalayak untuk bersikap baik, tidak maksiat, dan banyak mengingat Allah swt sebagai modal penting untuk dapat mudik kembali ke surga, tempat asal manusia diciptakan pertama kali.

Untuk mencetak naskah khutbah Idul Fitri ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan dekstop). Semoga bermanfaat! (Redaksi).''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ. اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ. اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ. لَا اِلٰهَ اِلَّا اللهُ وَاللهُ أَكْبَرُ وَ لِلّٰهِ الْحَمْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''الْحَمْدُ لِلّٰهِ الَّذِيْ جَعَلَ لِلصَّائِمِيْنَ يَوْمَ عِيْدِ الْفِطْرِ مَغْفُوْراً عَنِ الذُّنُوْبِ. وَأَشْهَدُ أَنْ لَا اِلٰهَ اِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ الَّذِيْ رَحْمَتُهُ الْمَطْلُوْبُ. وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''وَرَسُوْلُهُ سَيِّدُ الْعَجَمِ وَالْعُرْبِ. أَللّٰهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ الشَّافِعِ فِي الْيَوْمِ الْمَوْعُوْدِ, وَعَلَى اٰلِهِ وَأَصْحَابِهِ الْوَدُوْدِ. اَللهُ أَكْبَرُ. اَمَّا بَعْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَا أَيُّهَا النَّاسُ اِتَّقُوا اللهَ فِيْ مَا أَمَرَ وَانْتَهُوْا عَمَّا نَهَى اللهُ عَنْهُ وَحَذَّرَ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Jamaah yang dimuliakan Allah swt,
Marilah kita panjatkan puji dan syukur kita kepada Allah swt yang telah memberikan kita nikmat iman, Islam, dan sehat wal afiat sehingga kita dapat melaksanakan shalat Idul Fitri pada pagi hari ini.

Shalawat dan salam, mari kita haturkan kepada Nabi Muhammad saw, juga kepada keluarganya, dan sahabatnya. Semoga, kita semua selaku umatnya mendapatkan berkah dan syafaatnya.

Tak lupa, khatib mengajak jamaah sekalian untuk dapat meningkatkan takwa kita semua kepada Allah swt. Sebab, hanya ketakwaanlah yang menjadi jaminan kita di sisi Allah swt. Ketakwaan kita juga yang menjadi kunci untuk memuluskan kita agar mendapat Rahmat-Nya sehingga kita bisa masuk ke dalam surga-Nya yang penuh kenikmatan.

Hadirin hadirat yang dimuliakan Allah swt,
Idul Fitri yang kita rayakan hari ini sejatinya merupakan momentum yang sangat tepat bagi kita untuk dapat kembali ke jalur yang benar untuk mudik ke tempat tinggal kita sesungguhnya, yaitu surga. Sebagaimana diketahui bersama, pada mulanya, manusia kali pertama diciptakan tinggal di surga, yaitu Nabi Adam as. Kemudian, Nabi Adam diturunkan ke bumi sampai lahir kita saat ini. Turunnya manusia ke muka bumi itu dijadikan oleh Allah swt sebagai khalifah, sebagaimana disebutkan dalam Al-Qur’an surat Al-Baqarah ayat 30 berikut.''',
        },
        {
          'type': 'arabic',
          'content': '''وَاِذْ قَالَ رَبُّكَ لِلْمَلٰۤىِٕكَةِ ِانِّيْ جَاعِلٌ فِى الْاَرْضِ خَلِيْفَةًۗ قَالُوْٓا اَتَجْعَلُ فِيْهَا مَنْ يُّفْسِدُ فِيْهَا وَيَسْفِكُ الدِّمَاۤءَۚ وَنَحْنُ نُسَبِّحُ بِحَمْدِكَ وَنُقَدِّسُ لَكَۗ قَالَ اِنِّيْٓ اَعْلَمُ مَا لَا تَعْلَمُوْنَ''',
          'latin': '''''',
          'translation': '''Artinya, “(Ingatlah) ketika Tuhanmu berfirman kepada para malaikat, “Aku hendak menjadikan khalifah di bumi.” Mereka berkata, “Apakah Engkau hendak menjadikan orang yang merusak dan menumpahkan darah di sana, sedangkan kami bertasbih memuji-Mu dan menyucikan nama-Mu?” Dia berfirman, “Sesungguhnya Aku mengetahui apa yang tidak kamu ketahui.”''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Idul Fitri yang berbahagia,
Apa itu yang dimaksud khalifah? Imam Ibnu Katsir dalam kitab tafsirnya menjelaskan, bahwa khalifah yang dimaksud adalah manusia merupakan pengganti Allah swt di muka bumi untuk berlaku adil terhadap makhluk-makhluk ciptaan Allah swt yang lainnya. Mengutip Muhammad bin Ishaq, Imam Ibnu Katsir mengungkapkan makna lain dari khalifah, yaitu orang yang tinggal dan memakmurkan bumi.

Namun, ketika Allah swt menciptakan sosok manusia yang dijadikan sebagai khalifah, malaikat tidak ada yang percaya. Menurut mereka, nantinya makhluk yang diciptakan ini justru merusak dan menumpahkan darah. Dalam kitab Tafsir Jalalain, disebutkan bahwa merusak yang dimaksud adalah dengan melakukan berbagai maksiat. Lebih terang, Imam al-Shawi menegaskan bahwa merusak yang dimaksud adalah dengan keputusan kekuatan syahwat, sedangkan menumpahkan darah merupakan ekspresi dari keputusan kekuatan amarahnya.

Mendengar protes malaikat itu, Allah swt menegaskan bahwa Dia lebih mengetahui atas keputusan-Nya itu. Dijelaskan lebih lanjut oleh Imam al-Shawi, bahwa ada satu potensi manusia yang tidak dilihat malaikat, yaitu keputusan akalnya yang melahirkan keutamaan dan kesempurnaan. Imam Jalaluddin al-Suyuthi menambahkan bahwa hal yang tidak diketahui malaikat itu adalah kemaslahatan yang dilahirkan dari Nabi Adam.

Jamaah shalat Idul Fitri yang dimuliakan Allah swt,
Oleh karena itu, kita sebagai anak cucunya, harus dapat menjadi khalifah dari Nabi Adam, penggantinya yang meneruskan dan menjaga bumi sebagai langkah untuk mudik kembali ke surga, tempat kita berpulang. Sebab, hanya orang-orang yang dapat menjaga nafsunya yang dapat kembali mudik ke tempat asalnya, dalam hal ini surga. Yaitu orang yang tidak merusak bumi, baik secara lahir dengan membuang sampah sembarangan, menebang pohon seenaknya, dan lainnya, ataupun dengan perilaku maksiat. Juga orang yang tidak menumpahkan darah, baik secara lahir dengan seenaknya menumpahkan darah orang lain, ataupun secara yang lebih sederhana, yaitu mudah mengeluarkan amarahnya.

Allah swt dalam Al-Qur’an surat Al-Fajr ayat 27-30 telah menegaskan siapa yang dipersilahkan untuk memasuki surga-Nya.''',
        },
        {
          'type': 'arabic',
          'content': '''يٰٓاَيَّتُهَا النَّفْسُ الْمُطْمَىِٕنَّةُۙ ارْجِعِيْٓ اِلٰى رَبِّكِ رَاضِيَةً مَّرْضِيَّةًۚ فَادْخُلِيْ فِيْ عِبٰدِيْۙ وَادْخُلِيْ جَنَّتِيْࣖ''',
          'latin': '''''',
          'translation': '''Artinya, “Wahai jiwa yang tenang, kembalilah kepada Tuhanmu dengan rida dan diridai. Lalu, masuklah ke dalam golongan hamba-hamba-Ku. Dan masuklah ke dalam surga-Ku!”''',
        },
        {
          'type': 'text',
          'content': '''Pertanyaannya, apa yang dimaksud dengan jiwa yang tenang? Siapa pemilik jiwa yang tenang? Lalu, siapa hamba-hamba-Ku yang dimaksud pada ayat tersebut? Imam Jalaluddin al-Mahalli dalam Tafsir Jalalain menegaskan bahwa pemilik jiwa yang tenang ialah orang yang beriman. Diperjelas dalam kitab Hasyiyah al-Shawi, bahwa jiwa yang tenang itu bukan saja orang yang beriman, melainkan ada juga yang menyebutnya orang yang rida atas ketetapan Allah swt ataupun orang yang selalu menenangkan jiwanya dengan berdzikir atau menyebut asma-Nya.

Rasulullah saw bersabda''',
        },
        {
          'type': 'arabic',
          'content': '''ذِكْرُ اللّٰهِ عَلَمُ الْإِيْمَانِ وَبَرَاءَةٌ مِنَ النِّفَاقِ وَحِصْنٌ مِنَ الشِّيْطَانِ وَحِرْزٌ مِنَ النِّيْرَانِ''',
          'latin': '''''',
          'translation': '''Artinya, “Dzikir kepada Allah merupakan tanda iman, pembebas dari kemunafikan, benteng dari setan, dan penjaga dari neraka.”''',
        },
        {
          'type': 'text',
          'content': '''Adapun yang dimaksud dari hamba-hamba-Ku yang disebut akan membersamai orang berjiwa tenang adalah orang-orang saleh, sebagaimana yang disebutkan dalam kitab Tafsir Jalalain dan Tafsir Marah Labid.

Oleh karena itu, jamaah shalat Idul Fitri sekalian, mari kita memperbanyak dzikir, mengurangi maksiat, meminimalkan perilaku merusak bumi, dan membatasi amarah kita. Itulah sesungguhnya pelajaran yang harus diterapkan kita selepas menuntaskan berpuasa penuh di dalam bulan Ramadhan. Dengan begitu, inyaallah, semoga kita semua menjadi bagian dari pemilik jiwa yang tenang, yang dipanggil Allah swt dan dipersilakan untuk memasuki surga-Nya bersama hamba-hamba-Nya yang saleh.''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ إِنِّيْ أَسْأَلُكَ نَفْسًا مُطْمَئِنَّةً ، تُؤْمِنُ بلِقائِكَ ، وتَرْضَى بِقَضَائِكَ ، وتَقْنَعُ بعَطائِكَ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ. لَا اِلٰهَ اِلَّا اللهُ وَاللهُ أَكْبَرُ. اَللهُ أَكْبَرُ وَ لِلّٰهِ الْحَمْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ. اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ. اَللهُ أَكْبَرُ. الْحَمْدُ لِلّٰهِ الَّذِيْ أَعَادَ الْاَعْيَادَ وَكَرَّرَ. وَأَشْهَدُ أَنْ لَا اِلٰهَ اِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ الْمَلِكُ الْأَكْبَرُ. وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ خَيْرُ الْخَلَائِقِ وَالْبَشَرِ. أَللّٰهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ الشَّافِعِ فِي الْمَحْشَرِ, وَعَلَى اٰلِهِ وَأَصْحَابِهِ الْأَطْهَرِ. اَللهُ أَكْبَرُ. اَمَّا بَعْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَاأَيُّهَا النَّاسُ أُوْصِيْكُمْ وَنَفْسِيْ بِتَقْوَى اللهِ فَقَدْ فَازَ الْمُتَّقُوْنَ. فَقَالَ اللهُ تَعَالَى اِنَّ اللهَ وَ مَلَائِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّ يٰأَيُّهَا الَّذِيْنَ أٰمَنُوْا صَلُّوْا عَلَيْهِ وَ سَلِّمُوْا تَسْلِيْمًا. اَللّٰهُمَّ صَلِّ وَسَلِّمْ عَلٰى سَيِّدِنَا مُحَمَّدٍ حَبِيْبِكَ صَاحِبِ الْوَجْهِ الْاَنْوَرِ وَ عَلٰى أٰلِهِ وَارْضَ اَللّٰهُمَّ عَنِ الْخُلَفَاءِ الرَّاشِدِيْنَ. وَعَنْ اَصْحَابِ نَبِيِّكَ اَجْمَعِيْنَ. وَالتَّابِعِبْنَ وَتَابِعِ التَّابِعِيْنَ وَ تَابِعِهِمْ اِلٰى يَوْمِ الدِّيْنِ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّٰهُمَّ أَعِزَّ الْاِسْلَامَ وَ الْمُسْلِمِيْنَ وَأَصْلِحْ جَمِيْعَ وُلَاةَ الْمُسْلِمِيْنَ وَأَعْلِ كَلِمَتَكَ اِلَى يَوْمِ الدِّيْنِ. اَللّٰهُمَّ اغْفِرْ لِلْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ. اَللّٰهُمَّ ادْفَعْ عَنَّا الْغَلَاءَ وَالْوَبَاءَ وَالطَّاعُوْنَ وَالْاَمْرَاضَ وَالْفِتَنَ مَا لَا يَدْفَعُهُ غَيْرُكَ عَنْ بَلَدِنَا هٰذَا اِنْدُوْنِيْسِيَّا خَاصَّةً وَعَنْ سَائِرِ بِلَادِ الْمُسْلِمِيْنَ عَامَّةً يَا رَبَّ الْعَالَمِيْنَ. رَبَّنَا اٰتِنَا فِي الدُّنْيَا حَسَنَةً وَ فِي الْاٰخِرَةِ حَسَنَةً وَ قِنَا عَذَابَ النَّارِ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ اَللهُ أَكْبَرُ. لَا اِلٰهَ اِلَّا اللهُ وَاللهُ أَكْبَرُ. اَللهُ أَكْبَرُ وَ لِلّٰهِ الْحَمْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Syakir NF, Imam Masjid Baitul Maqdis, Padabeunghar, Pasawahan, Kuningan, Jawa Barat''',
        },
      ]
    },
    {
      'title': 'Khutbah Idul Fitri: Memaknai Hari Kemenangan yang Sesungguhnya',
      'date': '1 Syawal 1444 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Khutbah ini mengingatkan kita bahwa Idul Fitri yang selalu disebut sebagai hari kemenangan bukan saja karena kita telah melewati satu bulan berpuasa, tetapi karena seharusnya kita telah mencapai  kematangan spiritual dan sosial.

Khutbah Idul Fitri kali ini berjudul: “Khutbah Idul Fitri: Memaknai Hari Kemenangan yang Sesungguhnya". Untuk mengunduh dan mencetak naskah khutbah Idul Fitri ini silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat.''',
        },
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''اللَّه أَكْبَرُ ٣×. اللَّه أَكْبَرُ ٣×. اللهُ أَكْبَرُ ٣×. اَللهُ أَكْبَرُ كَبِيْرًا وَالْحَمْدُ للهِ كَثِيْرًا، وَسُبْحَانَ اللهِ بُكْرَةً وَأَصِيْلاً. لاَ إِلهَ إِلاَّ اللهُ. وَاللهُ أَكْبَرُ. اللهُ أَكْبَرُ وَللهِ الْحَمْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ للهِ الَّذِى جَعَلَ لِلْمُسْلِمِيْنَ عِيْدَ اْلفِطْرِ بَعْدَ صِياَمِ رَمَضَانَ. أَشْهَدُ أَنْ لاَ اِلَهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ لَهُ الْمُلْكُ اْلعَظِيْمُ اْلاَكْبَرْ. وَأَشْهَدُ أَنَّ سَيِّدَناَ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ الشَّافِعُ فِي الْمَحْشَرْ. نَبِيٌّ قَدْ غَفَرَ اللهُ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ وَمَا تَأَخَّرَ. اللهُمَّ صَلِّ عَلىَ سَيِّدِنَا مُحَمَّدٍ وَعَلَى اَلِهِ وَاَصْحَابِهِ الَّذِيْنَ أَذْهَبَ عَنْهُمُ الرِّجْسَ وَطَهَّرْ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ. فَيَا عِبَادَاللهِ اِتَّقُوااللهَ حَقَّ تُقَاتِهِ وَلاَ تَمُوْتُنَّ إِلاَّ وَاَنْتُمْ مُسْلِمُوْنَ. قالَ اللهُ تَعَالىَ فِيْ كِتَابِهِ الكَرِيْمِ أَعُوْذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ. يَا أَيُّهاَ الَّذِيْنَ ءَامَنُوا اتَّقُوا اللهَ حَقَّ تُقَاتِهِ وَلاَ تَمُوْتُنَّ إِلاَّ وَأَنتُمْ مُّسْلِمُوْنَ. يَا أَيُّهَا الَّذِيْنَ ءَامَنُوا اتَّقُوا اللهَ وَقُوْلُوْا قَوْلاً سَدِيْدًا. يُصْلِحْ لَكُمْ أَعْمَالَكُمْ، وَيَغْفِرْ لَكُمْ ذُنُوْبَكُمْ، وَمَنْ يُطِعِ اللهَ وَرَسُوْلَهُ فَقَدْ فَازَ فَوْزًا عَظِيمًا''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''اللهُ أَكْبَرُ ٣× لاَ إِلهَ إِلاَّ اللهُ، وَاللهُ أَكْبَرُ، اللهُ أَكْبَرُ وَللهِ الْحَمْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Ma’asyiral muslimin wal muslimat, jama’ah shalat Idul Fitri yang dimuliakan Allah

Alhamdulillah, pada hari ini kita telah merampungkan ibadah rukun Islam yang keempat, yaitu satu bulan berpuasa berikut rangkaian ibadah-ibadah sunah di dalamnya. Lalu, setelah kita meraih momen kemenangan ini, apa yang harus kita perbuat? Apakah berbangga diri dengan pencapaian spiritual yang telah dicapai? Atau merayakannya dengan penuh suka cita? Atau apa?

Idul Fitri bukan seperti turnamen sepak bola atau kompetisi lomba yang kemenangannya harus dirayakan dengan euforia dan penuh kebanggaan. Kemenangan Idul Fitri adalah ketika kita berhasil meraih kematangan spiritual dan sosial setelah satu bulan penuh digembleng dan dididik di madrasah Ramadhan.

Secara spiritual, selama Ramadhan umat Muslim telah melakukan serangkaian ibadah. Mulai dari puasanya sendiri maupun ibadah-ibadah sunnah di dalamnya seperti shalat tarawih, tadarus Al-Qur’an, beri’tikaf di masjid, dan sebagainya. Sudah seharusnya jika melalui bulan suci ini dengan maksimal dan melaksanakan beragam amalan di dalamnya, kita akan merasakan sentuhan dan pencapaian spiritual setelah bulan suci ini berlalu. Terkait puasanya sendiri, Allah swt menegaskan:''',
        },
        {
          'type': 'arabic',
          'content': '''يٰٓـاَيُّهَا الَّذِيۡنَ اٰمَنُوۡا كُتِبَ عَلَيۡکُمُ الصِّيَامُ کَمَا كُتِبَ عَلَى الَّذِيۡنَ مِنۡ قَبۡلِکُمۡ لَعَلَّكُمۡ تَتَّقُوۡنَ''',
          'latin': '''''',
          'translation': '''Artinya, “Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang sebelum kamu agar kamu bertakwa.” (QS Al-Baqarah: 183).''',
        },
        {
          'type': 'text',
          'content': '''Coba kita cermati ayat ini. Allah swt menyampaikan bahwa tujuan melaksanakan puasa adalah untuk melahirkan hamba-hamba yang takwa, yaitu orang yang mematuhi segala bentuk perintah agama dan menjauhi semua larangannya. Itu baru dengan puasanya saja, bagaimana jika kita mengamalkan beragam ibadah sunnah di dalamnya? Tentu kita akan menyentuh titik kematangan spiritual yang matang. Inilah yang dimaksud dengan sebuah pencapaian spiritual.''',
        },
        {
          'type': 'arabic',
          'content': '''اللهُ أَكْبَرُ ٣×، لاَ إِلهَ إِلاَّ اللهُ، وَاللهُ أَكْبَرُ، اللهُ أَكْبَرُ وَللهِ الْحَمْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Ma’asyiral muslimin wal muslimat, jama’ah shalat Idul Fitri yang dimuliakan Allah

Lalu, apakah jika kita sudah melakukan banyak ibadah selama Ramadhan sudah selesai begitu saja? Tidak, kita harus menanamkan prinsip khauf dan rajā’. Khauf adalah kekhawatiran apakah ibadah kita diterima oleh Allah swt atau tidak, sehingga kita tidak terlalu puas dan berbangga diri dengan pencapaian ibadah yang telah dilakukan. Sementara rajā’ adalah sikap optimisme bahwa Allah dengan sifat kasih sayang-Nya pasti mau menerima amal ibadah yang kita lakukan.

Saat Ramadhan berlalu, kita pun harus menerapkan dua sikap ini secara proporsional atau berimbang. Orang yang ibadahnya tidak didasari sifat khauf akan terlalu percaya diri dengan ibadah yang telah dilakukannya sehingga dikhawatirkan merasa cukup dengan amal yang telah dilakukan. Sementara sifat rajā’ diperlukan agar kita tidak putus asa kepada Allah swt. Sifat raja’ ini dilakukan dengan rasa optimis bahwa Allah menerima ibadah yang telah kita perbuat. Sebab, Allah sesuai perasangka hamba-Nya.

Imam Al-Ghazali dalam Iḥya’ ‘Ulūmiddīn menyampaikan:''',
        },
        {
          'type': 'arabic',
          'content': '''أَنْ يَكُوْنَ قَلْبُهُ بَعْدَ الإِفْطَارِ مُعَلَّقاً مُضْطَرِبًا بَيْنَ الْخَوْفِ وَالرَّجَاءِ إِذْ لَيْسَ يَدْرِي أَيُقْبَلُ صَوْمُهُ فَهُوَ مِنَ الْمُقَرَّبِينَ أَوْ يُرَدُّ عَلَيْهِ فَهُوَ مِنَ الْمَمْقُوتِينَ وَلْيَكُنْ كَذَلِكَ فِي آخِرِ كُلِّ عِبَادَةٍ يَفْرَغُ''',
          'latin': '''''',
          'translation': '''Artinya, “Setiap selesai berbuka puasa, seyogyanya kita merasa khawatir sekaligus menaruh harap kepada Allah. Khawatir jangan-jangan ibadah kita tidak diterima, juga berharap bahwa Allah menerimanya. Sebab, kita tidak tahu apakah puasa kita diterima sehingga termasuk hamba yang dekat di sisi Allah, atau sebaliknya ditolak sehingga kita termasuk hamba yang mendapat murka-Nya. Sikap seperti ini harus diterapkan setiap selesai melakukan ibadah apapun.” (Al-Ghazali, Ihya ‘Ulumiddin, [2016], juz I, halaman 319).''',
        },
        {
          'type': 'text',
          'content': '''Imam Al-Ghazali berpesan agar setiap selesai berbuka puasa kita menerapkan sikap khauf dan rajā’ terhadap puasa yang sudah kita laksanakan. Untuk satu ibadah berupa puasa saja perlu ditanamkan prinsip ini apalagi setelah selesai selesai satu bulan dengan segala amalan sunah di dalamnya.

Bayangkan, orang yang sudah beribadah maksimal saja tidak boleh berbangga diri dan terlalu percaya diri dengan amalnya, apalagi mereka yang ibadahnya biasa-biasa saja.''',
        },
        {
          'type': 'arabic',
          'content': '''اللهُ أَكْبَرُ ٣× لاَ إِلهَ إِلاَّ اللهُ، وَاللهُ أَكْبَرُ، اللهُ أَكْبَرُ وَللهِ الْحَمْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Ma’asyiral muslimin wal muslimat, jama’ah shalat Idul Fitri yang dimuliakan Allah

Puasa tidak saja ibadah yang memiliki spiritual, tetapi juga ritual keagamaan yang mendidik kepekaan sosial pengamalnya. Saat kita berpuasa, sebagaimana ditegaskan Syekh ‘Izzuddin bin ‘Abdissalam, sejatinya kita sedang digembleng agar memiliki rasa empati tinggi. Sebab, orang yang berpuasa akan merasakan betapa payahnya menahan lapar dan haus selama kurang lebih tiga belas jam dalam kurun waktu satu bulan.

Dengan pengalaman demikian kita akan sadar bahwa seperti inilah nasib saudara-saudara kita yang hidupnya berkekurangan yang untuk mencari sesuap nasi saja harus memeras keringat di bawah sengatan terik matahari. Barangkali lapar dan haus kita akan berakhir di waktu magrib, tetapi saudara kita yang hidup dengan ekonomi sangat rendah boleh jadi merasakan lapar sepanjang hayat masih dikandung badan, bahkan untuk makan esok harinya saja masih bingung harus mencari kemana lagi.

Saat Idul Fitri sudah tiba, sudah seharusnya kita mencapai titik empati sedemikian rupa karena sudah melalui hari-hari berpuasa selama satu bulan. Namun sayang, kadang kita sendiri justru terlalu larut dalam kegembiraan yang kita sebut sebagai ‘hari kemenangan’. Berasyik-ria menerima THR, memakai baju baru, menikmati hidangan spesial Idul Fitri, berkumpul dengan sanak saudara yang masih utuh, dan sejumlah momen keceriaan lainnya.

Namun, kita lupa bahwa di hari kemenangan ini boleh jadi masih ada saudara yang jangankan menerima THR, pekerjaan dengan gajih tetap saja tidak punya. Jangankan menikmati hidangan ketupat dan sedap opor ayam, untuk makan sehari-hari saja masih harus mengetuk pintu dari satu tetangga ke tetangga yang lain. Juga mereka yang sudah tidak memiliki keluarga karena tertimpa bencana, umpamanya. Jangankan berkumpul dengan keluarga lengkap, sosok ibu dan ayahnya saja telah tiada.

Mari kita renungi kembali pada momen suci ini. Sudahkah kita merasakan hari kemenangan dengan meraih nilai-nilai kemenangan yang seharusnya? Kemenangan yang bukan karena kita telah finish melewati jalan terjal Ramadhan, tetapi kemenangan sesungguhnya yang tidak saja berupa kematangan spiritual, melainkan juga pencapaian kepekaan sosial yang seharusnya diraih.''',
        },
        {
          'type': 'arabic',
          'content': '''اللهُ أَكْبَرُ ٣× لاَ إِلهَ إِلاَّ اللهُ، وَاللهُ أَكْبَرُ، اللهُ أَكْبَرُ وَللهِ الْحَمْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Ma’asyiral muslimin wal muslimat, jama’ah shalat Idul Fitri yang dimuliakan Allah

Puasa sendiri sejatinya representasi dari sejumlah ibadah yang ada. Sebab, sebagaimana puasa, ibadah-ibadah lain juga memiliki semangat spiritual dan sosial yang harus kita raih kedua-duanya. Sibuk mencari pencapaian spiritual saja tapi mengabaikan aspek sosialnya hanya akan membuat kita buta terhadap lingkungan kita hidup. Sebaliknya, terlalu sibuk dengan aspek sosial tapi mengabaikan sisi ritualnya hanya akan membuat kita jauh dari Allah swt. Dalam satu hadits diriwayatkan:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنْ أَبِي هُرَيْرَةَ قَالَ : قَالُوا : يَا رَسُولَ اللَّهِ ، فُلَانَةُ تَصُومُ النهار ، وتقوم اللَّيْلَ ، وَتُؤْذِي جِيرَانَهَا . قَالَ : هِيَ فِي النَّارِ . قَالُوا : فُلَانَةُ تُصَلِّي الْمَكْتُوبَاتِ ، وَتَصَدَّقُ بِالْأَثْوَارِ مِنَ الْأَقِطِ ، وَلَا تُؤْذِي جِيرَانَهَا ؟ قَالَ : هِيَ فِي الْجَنَّةِ''',
          'latin': '''''',
          'translation': '''Artinya, “Diriwayatkan dari Abu Hurairah, dia berkata, ‘Sekalompok sahabat bertanya, ‘Wahai Rasulullah, ada seorang perempuan ahli puasa dan ahli ibadah malam, tapi dia masih suka menyakiti tetangganya. Bagaimana pendapatmu?’ Rasul menjawab, ‘Dia akan masuk neraka.’ Mereka bertanya lagi, ‘Ada pula seorang perempuan yang hanya menunaikan shalat lima waktu, bersedekah dengan sepotong keju, dan tidak menyakiti tetangganya. Bagaimana pendapatmu?’ Rasul menjawab, ‘Dia akan masuk surga.’” (HR Al-Hakim).''',
        },
        {
          'type': 'text',
          'content': '''Dari hadits ini dapat dipahami bahwa shalat yang merupakan tiang agama saja tidak menjamin kita masuk surga jika kita masih berbuat buruk kepada sesama manusia.

Demikianlah khutbah Idul Fitri yang khatib sampaikan. Semoga di momen kemenangan ini membuat kita merasakan kemenangan yang hakiki. Kemenangan yang tidak saja menandai kita telah merampungkan satu bulan berpuasa, tetapi juga telah mencapai kematangan spiritual dan sosial yang sesungguhnya.''',
        },
        {
          'type': 'arabic',
          'content': '''تقَبَّلَ اللهُ مِنَّا وَمِنْكُمْ اَللَّهُمَّ بَارِكْ لَنَا فِيْ عِيْدِنَا، وَأَعِدْهُ عَلَينَا أَعْوَامًا عَدِيْدَةً أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ: وَٱعۡتَصِمُواْ بِحَبۡلِ ٱللَّهِ جَمِيعًا وَلَا تَفَرَّقُواْۚ وَٱذۡكُرُواْ نِعۡمَتَ ٱللَّهِ عَلَيۡكُمۡ إِذۡ كُنتُمۡ أَعۡدَآءً فَأَلَّفَ بَيۡنَ قُلُوبِكُمۡ فَأَصۡبَحۡتُم بِنِعۡمَتِهِۦٓ إِخۡوَٰنًا وَكُنتُمۡ عَلَىٰ شَفَا حُفۡرَةٍ مِّنَ ٱلنَّارِ فَأَنقَذَكُم مِّنۡهَاۗ كَذَٰلِكَ يُبَيِّنُ ٱللَّهُ لَكُمۡ ءَايَٰتِهِۦ لَعَلَّكُمۡ تَهۡتَدُونَ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اللهُ اَكْبَرْ ٣× اللهُ اَكْبَرْ ٤ ×. اللهُ اَكْبَرْ كَبِيْرًا وَاْلحَمْدُ للهِ كَثِيْرًا وَسُبْحَانَ الله بُكْرَةً وَ أَصْيْلاً لاَ اِلَهَ اِلاَّ اللهُ وَاللهُ اَكْبَرْ اللهُ اَكْبَرْ وَللهِ اْلحَمْدُ. الْحَمْدُ للهِ حَمْدًا كَثِيْرًا كَمَا أَمَرَ. وَأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ اِقْرَارًا بِرُبُوْبِيَّتِهِ وَاِرْغَامًا لِمَنْ جَحَدَ بِهِ وَكَفَرَ. وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ سَيِّدُ الْبَشَرِ. اللّهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى أَلِهِ وَأَصْحَابِهِ الْمَصَابِيْحِ الْغَرَرِ. مَا اتَّصَلَتْ عَيْنٌ بِنَظَرٍ وَاُذُنٌ بِخَبَرٍ. مِنْ يَوْمِنَا هَذَا إِلَى يَوْمِ الْمَحْشَرِ. أَمَّا بَعْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَاأَيُّهَا النَّاسُ اتَّقُوْا اللهَ فِيْمَا أَمَرَ. وَانْتَهُوْا عَمَّا نَهَى عَنْهُ وَحَذَّرَ. وَاعْلَمُوْا أَنَّ اللهَ تَبَارَكَ وَتَعَالَى اَمَرَكُمْ بِأَمْرٍ بَدَأَ فِيْهِ بِنَفْسِهِ وَثَنَّى بِمَلَا ئِكَتِهِ الْمُسَبِّحَةِ بِقُدْسِهِ. فَقَالَ تَعَالَى وَلَمْ يَزَلْ قَائِلًا عَلِيْمًا. إِنَّ اللهَ وَمَلَائِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّ. يَا أَيُّهَا الَّذِيْنَ أَمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا. اللّهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ جَدِّ الْحَسَنِ وَالْحُسَيْنِ وَعَلَى أَلِهِ وِأَصْحَابِهِ خَيْرِ أَهْلِ الدَّارَيْنِ خُصُوْصًا عَلَى أَوَّلِ الرَّفِيْقِ سَيِّدِنَا أَبِى بَكْرٍ الصِّدِّيْق. وَعَلَى الصَّادِقِ الْمَصْدُوْق سَيِّدِنَا أَبِي حَفْصٍ عُمَرَ الْفَارُوْقِ. وَعَلَى زَوْجِ الْبِنْتَيْنِ سَيِّدِنَا عُثْمَانِ ذِيْ النُّوْرَيْنِ. وَعَلَى ابْنِ عَمِّهِ الْغَالِبِ سَيِّدِنَا عَلِيِّ بْن أَبِيْ طَالِب. وَعَلَى السِّتَّةِ الْبَاقِيْنَ رَضِيَ اللهُ عَنْهُمْ أَجْمَعِيْنَ. وَعَلَى الشَّرِيْفَيْنِ سَيِّدَيْ شَبَابِ أَهْلِ الدَّارَيْنِ أَبِيْ مُحَمَّد الْحَسَنِ وَأَبِيْ عَبْدِ اللهِ الْحُسَيْنِ. وَعَلَى عَمَّيْهِ الْفَاضِلَيْنِ عَلَى النَّاسِ سَيِّدِنَا حَمْزَة وَسَيِّدِنَا الْعَبَّاسِ. وَعَلَى بَقِيَّةِ الصَّحَابَةِ أَجْمَعِيْنَ. وَعَلَى التَّابِعِيْنَ وَتَابِعِ التَّابِعِيْنَ لَهُمْ بِإِحْسَانٍ إِلَى يَوْمِ الدِّيْنِ. وَعَلَيْنَا مَعَهُمْ بِرَحْمَتِكَ يَاأَرْحَمَ الرَّاحِمَيْنَ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ وَالْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ اَلاَحْيآءِ مِنْهُمْ وَاْلاَمْوَاتِ. اللهُمَّ أَعِزَّ اْلاِسْلاَمَ وَالْمُسْلِمِيْنَ وَأَذِلَّ الشِّرْكَ وَالْمُشْرِكِيْنَ وَانْصُرْ عِبَادَكَ الْمُوَحِّدِيْن وَانْصُرْ مََنْ نَصَرَ الدِّيْنَ. وَاخْذُلْ مَنْ خَذَلَ الْمُسْلِمِيْنَ وَ دَمِّرْ أَعْدَاءَ الدِّيْنِ وَاعْلِ كَلِمَاتِكَ اِلَى يَوْمِ الدِّيْنِ. اللّهُمَّ ادْفَعْ عَنَّا اْلبَلاَءَ وَاْلوَبَاءَ وَالزَّلاَزِلَ وَاْلمِحَنَ وَسُوْءَ اْلفِتْنَةِ وَاْلمِحَنَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا اِنْدُونِيْسِيَّا خآصَّةً وَسَائِرِ اْلبُلْدَانِ الْمُسْلِمِيْنَ عآمَّةً يَا رَبَّ اْلعَالَمِيْنَ. اللَّهُمَّ أَصْلِحْ لَنا دِيْنَنَا الَّذِيْ هُوَ عِصْمَةُ أَمْرِنَا وَأَصْلِحْ لَنَا دُنْيَانَا الَّتِيْ فِيْهَا مَعَاشُنَا وَأَصْلِحْ لَنَا آخِرَتَنَا الَّتِيْ فِيْهَا مَعَادُنَا وَاجْعَلِ الْحَيَاةَ زِيَادَةً لَنَا فِيْ كُلِّ خَيْرٍ وَاجْعَلِ الْمَوْتَ رَاحَةً لَنَا مِنْ كُلِّ شَرٍّ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''اللَّهُمَّ أَلِّفْ بَيْنَ قُلُوبِنَا، وَأَصْلِحْ ذَاتَ بَيْنِنَا، وَاهْدِنَا سُبُلَ السَّلَامِ، وَنَجِّنَا مِنَ الظُّلُمَاتِ إِلَى النُّورِ، وَجَنِّبْنَا الْفَوَاحِشَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ، وَبَارِكْ لَنَا فِي أَسْمَاعِنَا وَأَبْصَارِنَا وَقُلُوبِنَا وَأَزْوَاجِنَا وَذُرِّيَّاتِنَا، وَتُبْ عَلَيْنَا، إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ. اللّهمَّ حَبِّبْ إلَيْنَا الإيمَانَ وَزَيِّنْهُ فِي قُلُوْبِنَا وَكَرِّهْ إلَيْنَا الْكُفْرَ وَالْفُسُوْقَ وَالْعِصْيَانَ. وَاجْعَلْنَا مِنَ الرَّاشِدِيْنَ اللّهُمَّ ارْزُقْنَا الصَّبْرَ عَلى الحَقِّ وَالثَّبَاتَ عَلَى الأَمْرِ والعَاقِبَةَ الحَسَنَةَ والعَافِيَةَ مِنْ كُلِّ بَلِيَّةٍ والسَّلاَمَةَ مِنْ كلِّ إِثْمٍ والغَنِيْمَةَ مِنْ كل بِرٍّ والفَوْزَ بِالجَنَّةِ والنَّجَاةَ مِنَ النَّارِ يَا أَرْحَمَ الرَّاحِمِيْنَ. رَبَّنا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الاخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّار''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَاللهِ. اِنَّ اللهَ يَأْمُرُ بِاْلعَدْلِ وَاْلاِحْسَانِ وَإِيْتآءِ ذِى اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشآءِ وَالْمُنْكَرِ وَاْلبَغْي يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ وَاذْكُرُوااللهَ اْلعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلىَ نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللهِ اَكْبَرْ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Muhamad Abror, penulis buku 'Ramadhan Terakhir', alumnus Pondok Pesantren KHAS Kempek Cirebon dan Ma'had Aly Saidusshiddiqiyah Jakarta.''',
        },
      ]
    },
    {
      'title': 'Khutbah Idul Fitri Bahasa Jawa: Berkah Riyoyo Langgeng Dumugi Setahun Ngajeng',
      'date': '1 Syawal 1444 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُ أَكْبَرُ، اَللهُ أَكْبَرُ، اَللهُ أَكْبَرُ … اَللهُ أَكْبَرُ، اَللهُ أَكْبَرُ، اَللهُ أَكْبَرُ … اَللهُ أَكْبَرُ، اَللهُ أَكْبَرُ، اَللهُ أَكْبَرُ. كَبِيْرًا وَالْحَمْدُ لِلّهِ كَثِيرًا وَسُبْحَانَ اللهِ بُكْرَةً وَأَصِيلًا. لآ إِلهَ إِلَّا اللهُ وَحْدَهُ، صَدَقَ وَعْدَهُ، وَنَصَرَ عَبْدَهُ، وَأَعَزَّ جُنْدَهُ، وَهَزَمَ الْأَحْزَابَ وَحْدَهُ. لآ إِلهَ إِلَّا اللهُ وَلَا نَعْبُدُ إِلَّا إِيَّاهُ، مُخْلِصِينَ لَهُ الدِّينِ وَلَوْ كَرِهَ الْكَافِرُونَ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلَّهِ. أَشْهَدُ أَنْ لآ إِلهَ إلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ. اَللّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ وَعَلَى أَصْحَابِ سَيِّدِنَا مُحَمَّدٍ. أَمَّا بَعْدُ، فَيآ أَيُّهَا النَّاسُ، أُوصِيكُمْ وَإِيَّايَ بِتَقْوَى اللهِ. إِنَّ لِلْمُتَّقِينَ فِي جَنَّاتٍ وَعُيُونٍ، أُدْخُلُوهَا بِسَلَامٍ آمِنِينَ. أَمَّا بَعْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Hadirin hadirot jamaah shalat Idul Fitri ingkang minulyo,

Wonten pepanggihan injing puniko, monggo kito ngaturaken puji lan syukur dumateng Allah subhanahu wa ta'ala, Pengeran ingkang sampun paring kesempatan dumateng kito sedoyo ngibadah poso Ramadhan sak wulan nutuk, jamaah tarawih lan witir, soho tadarusan ugi sak wulan. Kasyukuran kita sedoyo sampun sak prayoginipun kito lahiraken kanti waosan tahmid sesarengan, alhamdulillahi rabbil alamin.

Wonten awal khutbah puniko mboten kasupen, monggo kito sareng-sareng ningkataken, ngukuhaken, lan nguwataken ketakwaan dumateng gusti Allah, langkung-langkung sak sampunipun ngelampai ngibadah wonten saklebetipun wulan Ramadhan. Ketakwaan kito wonten wulan Ramadhan ingkang sekedik katah sampun meningkat, posonipun katah; sholatipun tambah katah; sedekahipun mundak; nafkah lan perhatianipun dumateng keluarga ugi tambah longgar; seserawunganipun dumateng sederek, tetanggi lan rencang ugi tambah sae; monggo wonten pepanggihan riyoyo injing punika, kito niati, kito tingkataken malih dumugi Ramadhan tahun ngajeng.

Ampun ngantos prestasi ngibadah ritual lan ngibadah sosial ingkang sae puniko, mandek mak jegrek, sesarengan telasipun wulan Ramadhan lan ngincik wulan Syawal wonten injing puniko. Kito sareng-sareng iling dawuhipun Imam Al-Ghazali wonten Kitab Ihya Ulumiddin, juz IV koco 382:''',
        },
        {
          'type': 'arabic',
          'content': '''لَا خَيْرَ فِيْ خَيْرٍ لَا يَدُوْمُ، بَلْ شَرٌّ لَا يَدُوْمُ خَيْرٌ مِنْ خَيْرٍ لَا يَدُوْمُ''',
          'latin': '''''',
          'translation': '''Artosipun, “Mboten wonten kesaenan ingdalem kesaenan ingkang mboten langgeng. Malah perkawis awon ingkang mboten langgeng, langkung sae tinimbang kesaenan ingkang mboten langgeng.”''',
        },
        {
          'type': 'text',
          'content': '''Ngibadah niku sae, poso sae, shalat sae, shodaqoh sae, srawung niku sae, nyekapi kebutuhan, paring kalonggaran, lan perhatian kasih sayang dumateng keluargo niku sae. Ananging menawi ngantos mandek mak jegrek, mboten dilampahi maleh, mboten diajegi, sedoyo wau dados blas mboten wonten saenipun.

Sakwangsulipun, nekat mboten poso niku awon; nekat mboten shalat, nekat nglarani rencang, nekat mboten ngopeni keluargo, niku babar blas mboten sae. Tapi menawi kok mandek mak jegrek, kapok mboten mangsuli malih perkawis-perkawis awon puniko, sedoyo dados sae.

Ingkang nekat mboten poso Ramadhan enggal-enggal nyaur utang poso mulai tanggal kalih (2) Syawal. Ingkang tasih glang-gling shalatipun mulai kerso sinahu mbiasaaken sholat, langkung-langkung mulai nyicil nyaur utang sholat ingkang kadung dipun tilar. Ingkang wonten perkawis kalih rencang, tetanggi utawi sederek, kerso ngerintis solusi ingkang paling memungkinkan. Ingkang wekdal-wekdal kepengker tasih kirang anggenipun paring nafkah lan perhatian dumateng keluargo, mulai kerso usaha pados nafkah ingkang halal lan langkung cekap, saha kerso paring perhatian ingkang lebih dumateng garwo lan poro putro.

Sedoyo perkawis awon kolo wau, menawi mboten dipun lampahi malih, menawi dipun kapoki, mandek mak jegrek, sedoyo dados sae. Malah langkung sae tinimbang ngibadah lan kesaenan ingkang mandek mboten berlanjut.

Sedoyo puniko, keranten keawonan ingkang mboten langgeng, menawi mandek mak jegrek, puniko mbeto kebungahan. Sakwangsulipun, kesaenan ingkang mboten langgeng, menawi mandek mak jegrek, punika bade ndugeaken kesusahan.

Penyair agung asal Kufah Irak, Abut Thoyyib Al-Mutanabbi (ingkang sedo tahun 354 H), ndawuhaken wonten salah setunggal syairipun:''',
        },
        {
          'type': 'arabic',
          'content': '''أَشَدُّ الغَمِّ عِنْدِيْ فِي سُرُورٍ * تَيَقَّنَ عَنْهُ صَاحِبُهُ انْتِقَالًا''',
          'latin': '''''',
          'translation': '''Artosipun, “Kesusahan ingkang paling abot, inggih kesusahan ingdalem kebungahan ingkang enggal sirno.”''',
        },
        {
          'type': 'text',
          'content': '''Kebungahan kito anggenipun mandek nglampahi kesaenan, sakyektosipun bade enggal sirno. Kebungahan kito anggenipun mandek nglampahi ngibadah, bade dumugeaken kesusahan. Kebungahan kito anggenipun mandek nglampahi amal sholeh, bade dados kesusahan ingkang langgeng. Na'udzubillahi, naudzubillahi min dzalik.

Hadirin hadirot jamaah shalat Idul Fitri ingkang minulyo,

Sinaoso amal sholeh punika sae, tapi kedah dipun ukur lan wonten istirahatipun. Islam ngajaraken poso, tarawih, lan darusan sak wulan nutuk; ananging Islam ugi ngajaraken istirahat saking poso, sholat, lan darusan. Malah Islam ngaromaken poso wonten dinten riyoyo Idul Fitri puniko.

Sepindah wekdal, Sayyidina Abu Bakar wonten dinten riyoyo nuweni putrinipun, injih puniko Sayyidah Aisyah, garwo Kanjeng Agung Nabi Muhammad shallalahu 'alaihi wasallam. Abu Bakar tratapan sanget, kranten wonten ngajeng Aisyah, wonten saklebetipun griyo Nabi Muhammad shallalahu 'alaihi wasallam, wonten lare estri kalih nyanyeaken lagon-lagon.

Mboten sronto ningali kahanan puniko, Abu Bakar duko sak duko-dukonipun:''',
        },
        {
          'type': 'arabic',
          'content': '''أَبِمُزْمُورِ الشَّيْطَانِ فِى بَيْتِ رَسُولِ اللَّهِ صلى الله عليه وسلم''',
          'latin': '''''',
          'translation': '''Artosipun, “Onoto lagon-lagon setan dinyanyeake ono griyone Rasulullah shallalahu 'alaihi wasallam?”''',
        },
        {
          'type': 'text',
          'content': '''Ningali moro sepuh duko-duko mekaten, Rasulullah shallalahu 'alaihi wasallam dawuh:''',
        },
        {
          'type': 'arabic',
          'content': '''يَا أَبَا بَكْرٍ، إِنَّ لِكُلِّ قَوْمٍ عِيْدًا وَهَذَا عِيْدُنَا''',
          'latin': '''''',
          'translation': '''Artosipun, “Abu Bakar, temen saestu angger-angger masyarakat gadah riyoyo piyambak-piyambak; lan dinten niki, dinten riyoyo kito umat Islam.” (Hadits riwayat Imam Al-Bukhari lan Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Maksudipun punopo dawuh Kanjeng Nabi Muhammad shallalahu 'alaihi wasallam puniko?

Mboten lintu, maksudipun inggih sampun sakwajaripun, menawi wonten saklebetipun dinten riyoyo, umat Islam ngelahiraken kebungahan. Saget kanti nyanyeaken lagon-lagon kanthi tetap njogo perilaku lan akhlak ingkang sae, ngobrol-ngobrol ringan, dahar-dahar, utawi hiburan lintu-lintu nipun. Semisal photo-photo lan mendet video sareng-sareng, utawi pelesir wonten panggenan-panggenan ingkang ngremenaken manah.

Catetanipun namung setunggal, pokok mboten maksiat lan nyarak kesopanan, wujud kebungahan kados puniko angsal-angsal mawon.

Hadirin hadirot jamaah shalat Idul Fitri ingkang minulyo,

Monggo dinten riyoyo puniko kito manfaataken sak sae-saenipun. Kangge silaturrahim, nepung pasederean, saling berkunjung, lan pados hiburan ingkang ngremenaken manah.

Mangke, menawi sampun cekap seminggu kalih minggu, kito wangsul malih wonten pendamelan piyambak-piyambak. Ingkang sekolah utawi mondok, wangsul sekolah lan mondok malih. Ingkang nyambut damel, wangsul nyambut damel malih, wonten sabin, pasar, sekolah, kantor utawi pabrik. Ingkang sakmeniko wangsul mudik, mangke wangsul wonten kuthonipun piyambak-piyambak.

Sedoyo wangsul nyambut damel malih kanthi mbeto kebungahan, kebahagiaan, lan tentunipun mbeto peningkatan keimanan lan ketakwaan dumateng Allah subhanahu wa ta'ala.

Mugi-mugi ngibadah kito saklebetipun wulan Ramadhan lan dinten riyoyo Idul Fitri puniko, ugi silaturahim lan ngapuran-ngapuranan kito sedoyo, nitisaken berkah kangge kito, berkah kangge keluargo kito, berkah kangge bondo kito, berkah kangge ngamal kito, lan berkah kangge gesang kito sedoyo. Syukur-syukur kito waget manggihi Ramadhan lan riyoyo tahun ngajeng, kanti kesarasan, kesuksesan, lan karaharjan. Amin, amin, amin, ya rabbal 'alamin.''',
        },
        {
          'type': 'arabic',
          'content': '''بسم الله الرحمن الرحيم. وَالْعَصْرِ (1) إِنَّ الْإِنْسَانَ لَفِي خُسْرٍ (2) إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ وَتَوَاصَوْا بِالْحَقِّ وَتَوَاصَوْا بِالصَّبْرِ (3). بَارَكَ اللهُ لِيْ وَلَكُمْ بِالْقُرْآنِ الْعَظِيْمِ، وَنَفَعَنِيْ وَإِيَّاكُمْ بِالْآيَاتِ وَالذِّكْرِ الْحَكِيمِ، وَاسْتَغْفِرُوْا رَبَّكُمْ، إِِنَّهُ هُوَ التَّوَّابُ الرَّحِيْمُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُ أَكْبَرُ، اَللهُ أَكْبَرُ، اَللهُ أَكْبَرُ، … اَللهُ أَكْبَرُ، اللهُ أَكْبَرُ، اللهُ أَكْبَرُ، … اَللهُ أَكْبَرُ وَلِلّهِ الْحَمْدُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ. أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ. اَللّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ، وَعَلَى آلِهِ وَأَصْحَابِهِ أَجْمَعِينَ، وَالتَّابِعِينَ لَهُمْ بِإِحْسَانٍ إِلَى يَوْمِ الدِّينِ. أَمَّا بَعْدُ. فَأُوصِيكُمْ وَنَفْسِي بِتَقْوَى اللهِ عَزَّ وَجَلَّ. وَاتَّقُوا اللهَ تَعَالَى فِي هَذَا الْيَوْمِ الْعَظِيمِ، وَاشْكُرُوهُ عَلَى تَمَامِ الصِّيَامِ وَالْقِيَامِ، وَأَتْبِعُوا رَمَضَانَ بِصِيَامِ سِتٍّ مِنْ شَوَّالٍ، لِيَكُونَ لَكُمْ كَصِيَامِ الدَّهْرِ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''وَصَلِّ اللّهُمَّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ كَمَا أَمَرْتَنَا، فَقُلْتَ وَقَوْلُكَ الْحَقُّ: إِنَّ اللهَ وَمَلَائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ، يَا أَيُّهَا الَّذِينَ آمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوا تَسْلِيمًا. اَللّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ، وَارْضَ اللّهُمَّ عَنِ الْخُلَفَاءِ الرَّاشِدِينَ، أَبِي بَكْرٍ وَعُمَرَ وَعُثْمَانَ وَعَلِيٍّ، وَعَنْ سَائِرِ الصَّحَابَةِ أَجْمَعِيْنَ. اَللّهُمَّ اغْفِرْ لِلْمُسْلِمِينَ وَالْمُسْلِمَاتِ، وَالْمُؤْمِنِينَ وَالْمُؤْمِنَاتِ، اَلْأَحْيَاءِ مِنْهُمْ وَالْأَمْوَاتِ، إِنَّكَ سَمِيْعٌ قَرِيْبٌ مُجِيْبُ الدَّعَوَاتِ. اَللّهُمَّ اجْعَلْ عِيْدَنَا هَذَا سَعَادَةً وَتَلاَحُمًا، وَمَسَرَّةً وَتَرَاحُمًا، وَزِدْنَا فِيهِ طُمَأْنِينَةً وَأُلْفَةً، وَهَنَاءً وَمَحَبَّةً، وَأَعِدْهُ عَلَيْنَا بِالْخَيْرِ وَالرَّحَمَاتِ، وَالْيُمْنِ وَالْبَرَكَاتِ. اَللّهُمَّ اجْعَلِ الْمَوَدَّةَ شِيْمَتَنَا، وَبَذْلَ الْخَيْرِ لِلنَّاسِ دَأْبَنَا. اَللّهُمَّ أَدِمِ السَّعَادَةَ عَلَى وَطَنِنَا، وَانْشُرِ الْبَهْجَةَ فِي بُيُوتِنَا، وَاحْفَظْنَا فِي أَهْلِنَا وَأَرْحَامِنَا، وَأَكْرِمْنَا بِكَرَمِكَ فِي الدُّنْيَا وَالْآخِرَةِ. رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً، وَفِي الْآخِرَةِ حَسَنَةً، وَقِنَا عَذَابَ النَّارِ، وَأَدْخِلْنَا الْجَنَّةَ مَعَ الْأَبْرَارِ، يَا عَزِيزُ يَا غَفَّارُ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ، إِنَّ اللهَ يَأْمُرُ بِالْعَدْلِ وَالْإحْسَانِ، وَإِيْتَاءِ ذِي الْقُرْبَى ويَنْهَى عَنِ الفَحْشَاءِ وَالْمُنْكَرِ وَالبَغْيِ، يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ. فَاذكُرُوا اللهَ الْعَظِيْمَ يَذْكُرْكُمْ، وَلَذِكْرُ اللهِ أَكْبَرُ. عِيْدٌ سَعِيْدٌ. وَكُلُّ عَامٍ وَأَنْتُمْ بِخَيْرٍ''',
          'latin': '''''',
          'translation': '''''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Ahmad Muntaha AM, Wakil Ketua Tanfidziyah MWCNU Kecamatan Salaman Kabupaten Magelang Jawa Tengah''',
        },
      ]
    },
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
    },
    {
      'title': 'Khutbah Jumat: Mempererat Silaturahim dalam Menyambut Ramadhan',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Naskah Khutbah Jumat ini berjudul: "Khutbah Jumat: Mempererat Silaturahim dalam Menyambut Ramadhan". Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat! (Redaksi).''',
        },
        {
          'type': 'arabic',
          'content': '''اْلحَمْدُ للهِ اْلحَمْدُ للهِ الّذي هَدَانَا سُبُلَ السّلاَمِ، وَأَفْهَمَنَا بِشَرِيْعَةِ النَّبِيّ الكَريمِ، أَشْهَدُ أَنْ لَا اِلَهَ إِلَّا الله وَحْدَهُ لا شَرِيك لَه، ذُو اْلجَلالِ وَالإكْرام، وَأَشْهَدُ أَنّ سَيِّدَنَا وَنَبِيَّنَا مُحَمَّدًا عَبْدُهُ وَ رَسولُه، اللّهُمَّ صَلِّ و سَلِّمْ وَبارِكْ عَلَى سَيِّدِنا مُحَمّدٍ وَعَلَى الِه وَأصْحابِهِ وَالتَّابِعينَ بِإحْسانِ إلَى يَوْمِ الدِّين، أَمَّا بَعْدُ''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَآأَيُّهَا الإِخْوَان، أُوْصِيْكُمْ وَنَفْسِيْ بِتَقْوَى اللهِ وَطَاعَتِهِ لَعَلَّكُمْ تُفْلِحُوْنْ، قَالَ اللهُ تَعَالىَ فِي اْلقُرْانِ اْلكَرِيمْ: أَعُوْذُ بِاللهِ مِنَ الَّشيْطَانِ الرَّجِيْم، بِسْمِ اللهِ الرَّحْمنِ الرَّحِيْمْ: يَا أَيُّهَا الَّذِينَ آَمَنُوا اتَّقُوا الله وَقُولُوا قَوْلًا سَدِيدًا، يُصْلِحْ لَكُمْ أَعْمَالَكُمْ وَيَغْفِرْ لَكُمْ ذُنُوبَكُمْ وَمَنْ يُطِعِ الله وَرَسُولَهُ فَقَدْ فَازَ فَوْزًا عَظِيمًا. وقال تعالى: يَا اَيُّهَا الَّذِيْنَ آمَنُوْا اتَّقُوْا اللهَ حَقَّ تُقَاتِهِ وَلاَ تَمُوْتُنَّ إِلاَّ وَأَنْتُمْ مُسْلِمُوْنَ. صَدَقَ اللهُ العَظِيمْ''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat rahimakumullah.
Alhamdulilah saat ini kita berada di akhir bulan Sya\'ban, dan sebentar lagi kita menjumpai bulan yang  penuh berkah, ampunan, dan rahmat Allah, yaitu bulan suci Ramadhan. Bulan suci Ramadhan merupakan bulan dimana umat Islam diwajibkan untuk menjalankan ibadah puasa selama sehari penuh, dengan meninggalkan suatu hal yang membatalkannya, seperti makan, minum, dan lainnya.''',
        },
        {
          'type': 'text',
          'content': '''Tidak hanya itu, umat Islam juga diperintahkan untuk menjauhi hal-hal yang tercela, seperti menggunjing, menghasut, dan saling bermusuhan. Sebagaimana hadis Nabi yang diriwayatkan oleh Imam Malik dalam Kitab Al-Muwatha\'nya. Nabi saw bersabda:''',
        },
        {
          'type': 'arabic',
          'content': '''اَلصِّيَامُ جُنَّةٌ، فَإِذَا كَانَ أَحَدُكُمْ صَائِمًا: فَلَا يَرْفُثْ، وَلَا يَجْهَلْ، فَإِنِ امْرُؤٌ قَاتَلَهُ، أَوْ شَاتَمَهُ، فَلْيَقُلْ: إِنِّي صَائِمٌ، إِنِّي صَائِمٌ''',
          'translation': '''Artinya, "Puasa itu adalah perisai, jika salah satu dari kalian sedang berpuasa, maka jangan sampai berkata rafats (kotor) dan jangan pula bertingkah laku jahil (sombong, suka mengejek, atau bertengkar). Jika ada orang lain yang mengajaknya berkelahi atau menghinanya maka hendaklah dia mengatakan "Aku sedang puasa, Aku sedang puasa." (HR Imam Malik).''',
        },
        {
          'type': 'text',
          'content': '''Imam Ibnu Asyur dalam kitab Kasyful Mughattha menjelaskan, puasa merupakan perisai dari berbagai marabahaya. Puasa menjadi tameng dari setiap bahaya yang akan menerpa. Puasa menjadi tameng dari melakukan perbuatan tercela, sebagai perisai dari nafsu yang hina agar kita menjadi bersih hatinya.''',
        },
        {
          'type': 'text',
          'content': '''Karena itu, orang yang berpuasa dilarang berkata kotor, dilarang berbuat jahil, dilarang bersikap sombong, dan dilarang saling bermusuhan. Orang yang berpuasa dilarang bermusuhan, dengan tujuan agar puasanya berkah dan sempurna, naik derajatnya menjadi manusia yang memiliki perilaku malaikat, dan bertakwa kepada Allah.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat rahimakumullah.
Menjadi jelas, ibadah puasa mengajarkan kepada kita untuk menjauhi permusuhan. Untuk menghentikan permusuhan, mari kita sambut bulan suci Ramadhan dengan mempererat silaturrahim, menguatkan jalinan persaudaraan. Sebagaimana hadis Nabi yang diriwayatkan oleh Imam Al-Bukhari dalam kitabnya Shahihul Bukhari:''',
        },
        {
          'type': 'arabic',
          'content': '''مَنْ أَحَبَّ أَنْ يُبْسَطَ لَهُ فِي رِزْقِهِ وَيُنْسَأَ لَهُ فِي أَثَرِهِ ‌فَلْيَصِلْ ‌رَحِمَهُ''',
        },
        {
          'type': 'text',
          'content': '''Artinnya, "Barangsiapa yang ingin dilapangkan rezekinya dan dipanjangkan umurnya maka hendaknya ia menyambung silaturrahminya." (HR Al-Bukhari).''',
        },
        {
          'type': 'text',
          'content': '''Imam Alauddin Ali dalam kitabnya Tafsir Al-Khazin menjelaskan, silaturrahim adalah berbuat baik kepada keluarga dan kerabat, agar keluarga saling akrab dan saling menyayangi antara satu dengan yang lainnya. Silaturrahim ini penting, orang yang sering silaturrahim, akan ditambahkan umurnya dan diluaskan rezekinya.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat rahimakumullah.
Dalam mengamalkan ajaran Nabi dalam bersilaturrahim, menjelang datangnya bulan Ramadhan, sebagian masyarakat ada yang memiliki tradisi silaturrahim, yang biasa disebut dengan sadranan atau ruwahan, yaitu dengan mengundang keluarga, tetangga, mengumpulkan jama\'ah, baik di rumah, mushalla, maupun masjid untuk merekatkan persaudaraan, memanjatkan doa bersama kepada leluhur, membaca tahlil, yasin, mendengarkan pengajian, dan berziarah ke makam orang tua dan leluhur.''',
        },
        {
          'type': 'text',
          'content': '''Tradisi ini sangat baik karena menguatkan jalinan tali silaturrahim, mempererat persaudaraan, berbakti kepada orang tua, saling guyup rukun, saling membantu satu dengan yang lain, saling menyapa, dan tumbuhlah kerukunan, persatuan dan persaudaraan.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat rahimakumullah.
Mengapa kita perlu melakukan silaturrahim? Karena kebersamaan adalah rahmat dan perpecahan adalah azab, sebagaimana petikan hadis Nabi yang diriwayatkan oleh Imam Ahmad dalam kitabnya Musnad Ahmad yang berbunyi:''',
        },
        {
          'type': 'arabic',
          'content': '''‌وَالْجَمَاعَةُ ‌رَحْمَةٌ، ‌وَالْفُرْقَةُ ‌عَذَابٌ''',
          'translation': '''Artinya, "Kebersamaan adalah rahmat, sedangkan perpecahan adalah azab."''',
        },
        {
          'type': 'text',
          'content': '''Syekh Abdurrauf Al-Munawi dalam kitabnya Faidhul Qadir menjelaskan, kebersamaan akan menghantarkan pada rahmat dan kasih sayang Allah swt. Kebersamaan menunjukkan citra Islam yang elegan, kerukunan, akhlak terpuji, ketakwaan, kebaikan dan menjunjung derajat kebaikan pendahulu.''',
        },
        {
          'type': 'text',
          'content': '''Sebaliknya perpecahan dan permusuhan akan menghantarkan kepada azab Allah, karena mudah bagi setan untuk menebarkan kebencian, permusuhan dan menghantarkannya pada siksa neraka. Orang yang memutuskan tali silaturrahim, memutuskan jalinan persaudaraan, menebarkan permusuhan, tidak akan dapat merasakan surga Allah swt, sebagaimana hadis Nabi yang diriwayatkan oleh Imam Muslim dalam kitabnya Shahih Muslim. Nabi saw bersabda:''',
        },
        {
          'type': 'arabic',
          'content': '''لَا يَدْخُلُ الْجَنَّةَ ‌قَاطِعُ رَحِمٍ''',
          'translation': '''Artinya, "Tidak akan masuk surga orang yang memutuskan tali persaudaraan." (HR. Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Bulan Ramadhan sudah ada di depan kita, mari kita sambut bulan suci ini dengan merekatkan tali persaudaraan, menjalin kebersamaan, dan menghentikan permusuhan. Agar kehidupan kita semakin berkah dan selalu mendapatkan rahmat dan kasih sayang Allah swt. Bulan Ramadhan menjadi bulan yang penuh berkah, ampunan, dan rahmat Allah bagi kita semua. Semoga kita semua mendapatkan ampunan dan ridha dari Allah swt. Amin Ya Rabbal \'alamiin.''',
        },
        {
          'type': 'arabic',
          'content': '''جَعَلَنَا اللهُ وَإيَّاكُمْ مِنَ الفَائِزِين الآمِنِين، وَأدْخَلَنَا وإِيَّاكم فِي زُمْرَةِ عِبَادِهِ المُؤْمِنِيْنَ. أعُوذُ بِاللهِ مِنَ الشَّيْطانِ الرَّجِيمْ، بِسْمِ اللهِ الرَّحْمانِ الرَّحِيمْ: يَا أَيُّهَا الَّذِينَ آمَنُوا اتَّقُوا اللَّهَ وَقُولُوا قَوْلًا سَدِيدًا''',
        },
        {
          'type': 'arabic',
          'content': '''باَرَكَ اللهُ لِيْ وَلكمْ فِي القُرْآنِ العَظِيْمِ، وَنَفَعَنِيْ وَإِيّاكُمْ بِالآياتِ وذِكْرِ الحَكِيْمِ،  إنّهُ تَعاَلَى جَوّادٌ كَرِيْمٌ مَلِكٌ بَرٌّ رَؤُوْفٌ رَحِيْمٌ''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ للهِ عَلىَ إِحْسَانِهِ وَالشُّكْرُ لَهُ عَلىَ تَوْفِيْقِهِ وَاِمْتِنَانِهِ. وَأَشْهَدُ أَنْ لاَ اِلَهَ إِلاَّ اللهُ وَاللهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ وَأَشْهَدُ أنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ الدَّاعِى إلىَ رِضْوَانِهِ. اللهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وِعَلَى اَلِهِ وَأَصْحَابِهِ وَسَلِّمْ تَسْلِيْمًا كِثيْرًا''',
        },
        {
          'type': 'arabic',
          'content': '''أَمَّا بَعْدُ فَياَ اَيُّهَا النَّاسُ، اِتَّقُوااللهَ فِيْمَا أَمَرَ وَانْتَهُوْا عَمَّا نَهَى، وَاعْلَمُوْا أَنَّ اللهَ أَمَرَكُمْ بِأَمْرٍ بَدَأَ فِيْهِ بِنَفْسِهِ وَثَـنَى بِمَلآ ئِكَتِهِ بِقُدْسِهِ وَقَالَ تَعاَلَى: إِنَّ اللهَ وَمَلآئِكَتَهُ يُصَلُّوْنَ عَلىَ النَّبِى يآ اَيُّهَا الَّذِيْنَ آمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا. اللهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلِّمْ وَعَلَى آلِ سَيِّدِناَ مُحَمَّدٍ وَعَلَى اَنْبِيآئِكَ وَرُسُلِكَ وَمَلآئِكَةِ اْلمُقَرَّبِيْنَ وَارْضَ اللّهُمَّ عَنِ اْلخُلَفَاءِ الرَّاشِدِيْنَ أَبِى بَكْرٍ وَعُمَر وَعُثْمَان وَعَلِى وَعَنْ بَقِيَّةِ الصَّحَابَةِ وَالتَّابِعِيْنَ وَتَابِعِي التَّابِعِيْنَ لَهُمْ بِاِحْسَانٍ اِلَىيَوْمِ الدِّيْنِ وَارْضَ عَنَّا مَعَهُمْ بِرَحْمَتِكَ يَا أَرْحَمَ الرَّاحِمِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَاْلمُؤْمِنَاتِ وَاْلمُسْلِمِيْنَ وَاْلمُسْلِمَاتِ اَلاَحْيآءُ مِنْهُمْ وَاْلاَمْوَاتِ اللهُمَّ أَعِزَّ اْلإِسْلاَمَ وَاْلمُسْلِمِيْنَ وَأَذِلَّ الشِّرْكَ وَاْلمُشْرِكِيْنَ وَانْصُرْ عِبَادَكَ اْلمُوَحِّدِيَّةَ وَانْصُرْ مَنْ نَصَرَ الدِّيْنَ وَاخْذُلْ مَنْ خَذَلَ اْلمُسْلِمِيْنَ وَ دَمِّرْ أَعْدَاءَ الدِّيْنِ وَاعْلِ كَلِمَاتِكَ إِلَى يَوْمَ الدِّيْنِ. اللهُمَّ ادْفَعْ عَنَّا اْلبَلاَءَ وَاْلوَبَاءَ وَالزَّلاَزِلَ وَاْلمِحَنَ وَسُوْءَ اْلفِتْنَةِ وَاْلمِحَنَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا اِنْدُونِيْسِيَّا خآصَّةً وَسَائِرِ اْلبُلْدَانِ اْلمُسْلِمِيْنَ عآمَّةً يَا رَبَّ اْلعَالَمِيْنَ. رَبَّنَا آتِناَ فِى الدُّنْيَا حَسَنَةً وَفِى اْلآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ. رَبَّنَا ظَلَمْنَا اَنْفُسَنَا وَاإنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُوْنَنَّ مِنَ اْلخَاسِرِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَاللهِ! إِنَّ اللهَ يَأْمُرُنَا بِاْلعَدْلِ وَاْلإِحْسَانِ وَإِيْتآءِ ذِي اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشآءِ وَاْلمُنْكَرِ وَاْلبَغْي يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ. وَاذْكُرُوا اللهَ اْلعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلىَ نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللهِ أَكْبَرْ''',
        },
        {
          'type': 'text',
          'content': '''Dr Rustam Ibrahim, Dosen UIN Raden Mas Said Surakarta.''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat Bahasa Jawa: Ndadosaken Masjid Pusat Ibadah ing wulan Romadhon',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Bulan Ramadhan segera tiba. Aktivitas dan semangat ibadah umat Islam pun akan bertambah. Berbagai kegiatan religi digelar dengan ragamnya masing-masing di berbagai tempat. Masjid menjadi tempat favorit dan strategis untuk menggelar kegiatan Ramadhan. Hal ini pun harus terus dipertahankan dan ditingkatkan.''',
        },
        {
          'type': 'text',
          'content': '''Materi khutbah Jumat Bahasa Jawa ini berjudul: "Khutbah Jumat Bahasa Jawa: Ndadosaken Masjid Pusat Ibadah ing wulan Romadhon". Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat.''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلّٰهِ الَّذِيْ جَعَلَ شَهْرَ رَمَضَانَ غُرَّةَ وَجْهِ الْعَامِ. وَشَرَّفَ أَوْقَاتَهُ عَلَى سَائِرِ الأَوْقَاتِ، وَفَضَّلَ أَيَّامَهُ عَلَى سَائِرِ الْأَيَّامِ، أَشْهَدُ أَنْ لاَ إِلٰهَ إِلاَّ اللّٰهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ، شهادَةَ مَنْ قَالَ رَبِّيَ اللّٰهُ ثُمَّ اسْتَقَامَ، وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ، أَفْضَلُ مَنْ صَلَّى وَصَامَ. اللّٰهُمَّ صَلِّ وسَلِّمْ علَى عَبْدِكَ وَرَسُوْلِكَ مُحَمّدٍ وعَلٓى آلِهِ وأَصْحَابِهِ هُدَاةِ الأَنَامِ وَمَصَابِيْحِ الظُّلاَمِ. أَمَّا بَعْدُ، فَيَا أَيُّهَا النَّاسُ اتَّقُوا اللّٰهَ تَعَالَى بِفِعْلِ الطَّاعَاتِ وَتَرْكِ الْأَثَامِ. فَقَالَ اللّٰهُ تَعَالٰى فِيْ كِتَابِهِ الْكَرِيْمِ: أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ، بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ يَاۤ أَيُّهَا الَّذِيْنَ آمَنُواْ كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَ''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat ingkang minulyo.
Ngawiti khutbah Jumat meniko monggo sami nguataken raos syukur dateng Allah swt ing sampun maringi katah kenikmatan dateng kito sedoyo ing dunyo meniko. Sedoyo meniko kedah kito syukuri biqauli: "Alhamdulillahirabbil \'alamin", kito tancepaken wonten ing ati sak kenceng-kencengipun, lan dipun wujudaken wonten ing amal kito tiap wayahipun.''',
        },
        {
          'type': 'text',
          'content': '''Salah setunggalipun wujud syukur inggih puniko tansah nglampahi sedoyo perintahipun Gusti Allah lan nebihi dateng sedoyo ingkang dipun larang deneng Allah swt. Menikolah ingkang dipun sebut kalian takwa. Pramilo ing wedal meniko monggo kito ngiataken takwa dateng Allah swt, luwih-luwih ngajengaken wulan Ramadhan ingkang penuh kalian keberkahan. Ningkataken takwa meniko saget kito lakoni kelawan ningkataken ibadah piyambak-piyambak utowo ibadah berjamaah.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat ingkang minulyo.
ibadah-Ibadah ing wulan Ramadhan meniko saget kito tambahi berkah lan keutamaanipun wonten ing masjid. Katah sanget ibadah ingkang saged kito lakoaken wonten ing masjid kados ingkang sampun dados tradisi ing lingkungan kito. Meniko kedah kito uri-uri kranten katah manfangatipun kados dados syiar, nguataken silaturahmi dateng tiyang lintu, makmuraken masjid, lan ningkataken semangat ibadah.''',
        },
        {
          'type': 'text',
          'content': '''Allah swt sampun dawuh wonten ing Qur\'an surat At-Taubah ayat 18:''',
        },
        {
          'type': 'arabic',
          'content': '''اِنَّمَا يَعْمُرُ مَسٰجِدَ اللّٰهِ مَنْ اٰمَنَ بِاللّٰهِ وَالْيَوْمِ الْاٰخِرِ وَاَقَامَ الصَّلٰوةَ وَاٰتَى الزَّكٰوةَ وَلَمْ يَخْشَ اِلَّا اللّٰهَ ۗفَعَسٰٓى اُولٰۤىِٕكَ اَنْ يَّكُوْنُوْا مِنَ الْمُهْتَدِيْنَ''',
          'translation': '''Artosipun,"Temen setuhune ingkang makmuraken masjid Allah namung tiyang ingkang iman kalian Allah lan dinten kiamat, ngelaksanaaken sholat, mbayar zakat lan mboten wedi kejobo marang Allah. Tiyang menikolah ingkang dipun arepaken dados golongan ingkang angsal pituduh"''',
        },
        {
          'type': 'text',
          'content': '''Ing ayat meniko dipun sebataken rupi ibadah ingkang saged dipun lakoaken inggih puniko shalat. Meniko saged kito dadosaken motivasi lan semangat ndadosaken masjid pusat ibadah wonten ing wulan Romadhon arupi ibadah sholat berjamaah. Mestinipun mboten anamung ibadah sholat, anangin ibadah lintunipun ugi saged kito amalaken wonten ing masjid.''',
        },
        {
          'type': 'text',
          'content': '''Wonten ing masyarakat, kito saged tingali sampun katah tradisi ibadah ingkang dipun lakoaken wonten ing masjid ngarepi lan saklebete Romadhon. Ngawiti saking tradisi punggahan utawi dungo sareng-sareng ing awal Romadhon, resik-resik masjid utowo mushola, lan lintunipun. Meniko kedah kito uri-uri dipun lajengaken kalian ibadah sholat jamaah lan tentunipun sholat Tarawih ingkang dados kesunahan wonten ing wulan Romadhon.''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat ingkang minulyo.
Kito ugi saged ngadaaken ibadah teng masjid kanthi macem-macem ibadah arupi tadarus Al-Qur\'an, pengajian, buko puoso sareng, i\'tikaf, lan lintu-lintunipun. Mboten anamung ibadah ingkang hubunganipun kalian Allah (hablun minallah), ibadah lintu ingkang nggadahi hubungan kalian menungso (hablun minannas) ugi saged kito laksanaaken wonten ing masjid. Kados ingkang sampun disebut wonten ing surat At-Taubah ayat 18 ingkang sampun kulo sebat inggih puniko ibadah zakat.''',
        },
        {
          'type': 'text',
          'content': '''Ibadah zakat, sedekah, infak, lan ibadah-ibadah sosial lintunipun saged kito laksanaaken wonten ing masjid kangge ndadosaken masjid pusat ibadah lan ugi ngalap berkah Romadhon. Sedoyo ibadah meniko kedah dipun biasaken wonten ing masjid. Rasulullah ngendiko:''',
        },
        {
          'type': 'arabic',
          'content': '''إِذَا رَأَيْتُمُ الرَّجُلَ يَعْتَادُ الْمَسَاجِدَ فَاشْهَدُوْا لَهُ بِاْلإِيْمَانِ''',
          'translation': '''Artosipun, "Nalikone siro nemu wongkang bioso ibadah wonten ing masjid, moko nyeksenono siro dene wong mau iku wongkang beriman." (HR Riwayat Ahmad, At-Tirmidi, Ibnu Majah lan Al-Hakim saking Abi Sa\'id Al-Khudri).''',
        },
        {
          'type': 'text',
          'content': '''Jamaah shalat Jumat ingkang minulyo.
Pramilo, monggo kito sami ndadosaken masjid pusat ibadah kito khususipun wonten ing wulan Romadhon. Mboten anamung ibadah-ibadah mahdhoh ingkang sampun dipun tetapaken totocoronipun, nanging ibadah ghairu mahdoh ingkang mboten dipun sukani totocoronipun ugi saged dipun kito lakoaken wonten ing masjid.''',
        },
        {
          'type': 'text',
          'content': '''Mugi-mugi kito sedoyo tetep dipun paringi taufik lan hidayah ugi kekiatan saged ibadah kelawan mempeng wonten ing wulan Romadhon lan saget pikantuk predikat tiyang-tiyang ingkang bertakwa ingkang dados tujuan ibadah puoso. Amin ya Rabbal \'alamin.''',
        },
        {
          'type': 'arabic',
          'content': '''أَعُوذُ بِاللهِ مِن الشَّيْطانِ الرَّجِيْمِ. بِسْمِ اللهِ الرَّحمن الرّحيم. يَا أَيُّهَا الَّذِينَ آمَنُواْ كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِن قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ. أَيَّامًا مَّعْدُودَاتٍ، فَمَن كَانَ مِنكُم مَّرِيضًا أَوْ عَلَى سَفَرٍ فَعِدَّةٌ مِّنْ أَيَّامٍ أُخَرَ، وَعَلَى الَّذِينَ يُطِيقُونَهُ فِدْيَةٌ طَعَامُ مِسْكِينٍ، فَمَن تَطَوَّعَ خَيْرًا فَهُوَ خَيْرٌ لَّهُ، وَأَن تَصُومُواْ خَيْرٌ لَّكُمْ إِن كُنتُمْ تَعْلَمُونَ''',
        },
        {
          'type': 'arabic',
          'content': '''باَرَكَ اللهُ لِيْ وَلكمْ فِي القُرْآنِ العَظِيْمِ، وَنَفَعَنِيْ وَإِيّاكُمْ بِالآياتِ والذِّكْرِ الحَكِيْمِ، إنّهُ تَعَالَى جَوّادٌ كَرِيْمٌ مَلِكٌ بَرٌّ رَؤُوْفٌ رَحِيْمٌ''',
        },
        {
          'type': 'arabic',
          'content': '''َاَلْحَمْدُ للهِ عَلىَ اِحْسَانِهِ وَالشُّكْرُ لَهُ عَلىَ تَوْفِيْقِهِ وَامْتِنَانِهِ. وَاَشْهَدُ اَنْ لاَ اِلَهَ اِلاَّ اللهُ وَاللهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ وَاَشْهَدُ اَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ الدَّاعِي اِلىَ رِضْوَانِهِ. اللهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وِعَلَى اَلِهِ وَاَصْحَابِهِ وَسَلِّمْ تَسْلِيْمًا كِثيْرًا. اَمَّا بَعْدُ فَياَ اَيُّهَا النَّاسُ، اِتَّقُوااللهَ فِيْمَا اَمَرَ وَانْتَهُوْا عَمَّا نَهَى. وَاعْلَمُوْا اَنَّ اللّٰهَ اَمَرَكُمْ بِاَمْرٍ بَدَأَ فِيْهِ بِنَفْسِهِ وَثَـنَى بِمَلآ ئِكَتِهِ بِقُدْسِهِ. وَقَالَ تَعاَلَى: اِنَّ اللهَ وَمَلآ ئِكَتَهُ يُصَلُّوْنَ عَلىَ النَّبِى، يآ اَيُّهَا الَّذِيْنَ آمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا''',
        },
        {
          'type': 'arabic',
          'content': '''اللهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلِّمْ وَعَلَى آلِ سَيِّدِناَ مُحَمَّدٍ وَعَلَى اَنْبِيآئِكَ وَرُسُلِكَ وَمَلآئِكَةِ اْلمُقَرَّبِيْنَ، وَارْضَ اللّٰهُمَّ عَنِ اْلخُلَفَاءِ الرَّاشِدِيْنَ اَبِى بَكْرٍ وَعُمَر وَعُثْمَان وَعَلِى وَعَنْ بَقِيَّةِ الصَّحَابَةِ وَالتَّابِعِيْنَ وَتَابِعِي التَّابِعِيْنَ لَهُمْ بِاِحْسَانٍ اِلَى يَوْمِ الدِّيْنِ، وَارْضَ عَنَّا مَعَهُمْ بِرَحْمَتِكَ يَا اَرْحَمَ الرَّاحِمِيْنَ
اَللهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَاْلمُؤْمِنَاتِ وَاْلمُسْلِمِيْنَ وَاْلمُسْلِمَاتِ اَلْاَحْيآءِ مِنْهُمْ وَاْلاَمْوَاتِ. اللهُمَّ اَعِزَّ اْلاِسْلاَمَ وَاْلمُسْلِمِيْنَ وَأَذِلَّ الشِّرْكَ وَاْلمُشْرِكِيْنَ وَانْصُرْ عِبَادَكَ اْلمُوَحِّدِيَّةَ وَانْصُرْ مَنْ نَصَرَ الدِّيْنَ وَاخْذُلْ مَنْ خَذَلَ اْلمُسْلِمِيْنَ وَدَمِّرْ اَعْدَاءَ الدِّيْنِ وَأَعْلِ كَلِمَاتِكَ اِلَى يَوْمَ الدِّيْنِ. اللهُمَّ ادْفَعْ عَنَّا اْلبَلاَءَ وَاْلوَبَاءَ وَالزَّلاَزِلَ وَاْلمِحَنَ وَسُوْءَ اْلفِتْنَةِ وَاْلمِحَنَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا اِنْدُونِيْسِيَّا خآصَّةً وَسَائِرِ اْلبُلْدَانِ اْلمُسْلِمِيْنَ عآمَّةً يَا رَبَّ اْلعَالَمِيْنَ. رَبَّنَا آتِناَ فِى الدُّنْيَا حَسَنَةً وَفِى اْلآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ. رَبَّنَا ظَلَمْنَا اَنْفُسَنَاوَاِنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُوْنَنَّ مِنَ اْلخَاسِرِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ، اِنَّ اللهَ يَأْمُرُنَا بِاْلعَدْلِ وَاْلاِحْسَانِ وَإِيْتآءِ ذِى اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشآءِ وَاْلمُنْكَرِ وَاْلبَغْي يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ وَاذْكُرُوااللهَ اْلعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلىَ نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللهِ اَكْبَرْ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz H Muhammad Faizin, Ketua Bidang Humas Data dan Informasi Badan Kesejahteraan Masjid (BKM) Provinsi Lampung.''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Makna dan Keutamaan Bulan Ramadhan',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Bulan Ramadhan merupakan bulan paling mulia dari sekian bulan dalam kalender Islam. Banyak dalil dan faktor eksternal lainnya yang menunjukkan kemuliaan bulan ini. Meskipun bulan Ramadhan tidak termasuk dalam tiga bulan mulia (asyhurul hurum), namun secara hirarki ketiga bulan tersebut masih berada di bawah level bulan Ramadhan.''',
        },
        {
          'type': 'text',
          'content': '''Khutbah Jumat ini berjudul: "Khutbah Jumat: Makna dan Keutamaan Bulan Ramadhan". Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat! (Redaksi)''',
        },
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''الحَمْدُ لِلّهِ رَبِّ العَالَمِيْنَ. القَائِلِ فِي كِتَابِهِ الكَرِيْمِ: يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوْا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَۙ. وَالصَّلَاةُ وَالسَّلَامُ عَلَى أَشْرَفِ اْلأَنْبِيَاءِ وَالْمُرْسَلِيْنَ، نَبِيِّنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ وَعَلَى اٰلِهِ وَأَصْحَابِهِ وَالتَّابِعِيْنَ. أَشْهَدُ أَنْ لَّا إِلهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ، لَا نَبِيَّ بَعْدَهُ. أَمَّا بَعْدُ فَيَا أَيُّهَا الْحَاضِرُوْنَ المُصَلُّونَ. اِتَّقُوا اللهَ حَقَّ تُقَاتِهِ وَلَا تَمُوْتُنَّ إِلَّا وَأَنْتُمْ مُسْلِمُوْنَ''',
        },
        {
          'type': 'text',
          'content': '''Hadirin shalat Jumat yang dimuliakan Allah,''',
        },
        {
          'type': 'text',
          'content': '''Sebagaimana diketahui bersama, bulan ini merupakan bulan yang agung dan penuh berkah. Sebab pada bulan ini ampunan dan rahmat-Nya sangat mudah didapatkan, bukankah kelak kita bisa masuk sorga-Nya hanya melalui rahmat-Nya?''',
        },
        {
          'type': 'text',
          'content': '''Begitu juga adanya bulan Ramadhan membuat seluruh umat Islam diwajibkan berpuasa dengan tujuan menjadi pribadi yang bertakwa. Hal ini sebagaimana dijelaskan dalam ayat:''',
        },
        {
          'type': 'arabic',
          'content': '''يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ''',
          'translation': '''Artinya: "Wahai orang-orang beriman telah diwajibkan puasa atas kalian sebagaimana telah diwajibkan (juga) atas orang-orang sebelum kalian agar kalian menjadi orang bertakwa." (QS. al-Baqarah: 183)''',
        },
        {
          'type': 'text',
          'content': '''Tujuan disyariatkannya berpuasa untuk menjadi orang bertakwa merupakan cara Allah mengajak kita untuk meningkatkan kualitas ketakwaan kita. Ibadah sehari-hari seperti shalat lima waktu, sedekah, berbuat baik kepada sesama, dan lain sebagainya dirasa belum cukup untuk meningkatkan ketakwaan kita. Oleh karenanya Allah menambahkan jalan lain untuk mencapai hal tersebut, yaitu dengan berpuasa.''',
        },
        {
          'type': 'text',
          'content': '''Kendati demikian, patut diakui bahwa puasa tidak hanya bisa dilaksanakan pada bulan Ramadhan saja. Namun puasa yang dilakukan pada bulan ini mempunyai keutamaan yang lebih dibandingkan puasa pada bulan-bulan lainnya. Keutamaan ini disebabkan puasa tersebut dilakukan pada bulan Ramadhan.''',
        },
        {
          'type': 'text',
          'content': '''Dengan kata lain, ibadah puasa memiliki keutamaan yang berbeda-beda dengan bergantung pada bulan apa dikerjakannya. Lantas, mengapa ketika puasa dikerjakan pada bulan Ramadhan memiliki nilai lebih tinggi di sisi Allah dibandingkan puasa pada bulan yang lain?''',
        },
        {
          'type': 'text',
          'content': '''Hadirin shalat Jumat yang dimuliakan Allah,.''',
        },
        {
          'type': 'arabic',
          'content': '''Pertanyaan tadi akan bisa dijawab bila kita mulai dari mengetahui apa arti kata Ramadhan. Dalam kamus al-Mu\'jam al-Wasith, Ramadhan berasal dari رَمَضَ yang memiliki makna \'membakar.\' Makna ini sepadan substansinya dengan kata lain seperti melenyapkan, menghanguskan, bahkan meluluhlantakkan. Termasuk sifat membakar yang lain adalah meniadakan, menghabisi, dan menundukkan.''',
        },
        {
          'type': 'text',
          'content': '''Dalam konteks Ramadhan, sesuatu yang dibakar adalah penyakit hati yang ada dalam diri kita masing-masing. Imam al-Ghazali secara terperinci menjelaskan apa saja macam-macam penyakit hati di dalam kitabnya yang fenomenal, Ihya Ulumuddin. Di antaranya adalah ego, iri dengki, sombong, ujub, dan nafsu hewani.''',
        },
        {
          'type': 'text',
          'content': '''Penyakit-penyakit seperti inilah yang mesti ditundukkan bahkan dibakar selama bulan Ramadhan. Ibadah pada bulan ini seperti puasa, tarawih, mengaji al-Quran, dan berbagai macam dzikir memiliki tujuan untuk melenyapkan berbagai penyakit hati tersebut. Seolah-olah Allah hendak menegaskan bahwa penyakit hati itu bisa dilatih, dilunakkan, serta dihilangkan dengan cara memperbanyak ibadah pada bulan Ramadhan.''',
        },
        {
          'type': 'text',
          'content': '''Sebab penyakit hati merupakan faktor paling dasar yang memicu berbagai konflik sosial dan politik yang terjadi selama ini. Bahkan Imam al-Ghazali juga menegaskan bahwa penyakit hati bisa mengidap kepada siapa saja, termasuk para ulama, pejabat, dan tokoh macam lainnya. Penyakit hati ini memang tidak memandang bulu dan hanya bisa dihilangkan dengan memperbanyak proses dan latihan.''',
        },
        {
          'type': 'text',
          'content': '''Oleh karena itu, dengan beragam ibadah dan ganjaran yang dikhususkan hanya bisa diperoleh pada bulan ini, diharapkan dapat meluluhlantakkan penyakit-penyakit hati yang ada di dalam diri kita. Sesuai makna asalnya, Ramadhan menjadi momentum pembakaran berbagai penyakit hati, dan tentunya termasuk berbagai dosa juga.''',
        },
        {
          'type': 'text',
          'content': '''Hadirin shalat Jumat yang dimuliakan Allah,''',
        },
        {
          'type': 'text',
          'content': '''Perlu dipertegas di sini bahwa maksud dosa di sini hanyalah dosa antara hamba dengan Tuhannya. Artinya, dosa yang bisa dibakar atas ibadah-ibadah yang dikerjakan selama Ramadhan hanya terbatas pada dosa kepada Tuhan. Sedangkan dosa kepada sesama manusia maka harus meminta maaf kepada yang bersangkutan.''',
        },
        {
          'type': 'text',
          'content': '''Namun, Nabi Muhammad Saw di dalam sabdanya menyebutkan sebuah ibadah secara spesifik yang dapat menghanguskan dosa-dosa tersebut, yaitu berpuasa. Di dalam riwayat Bukhari – Muslim disebutkan:''',
        },
        {
          'type': 'arabic',
          'content': '''مَنْ صَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ''',
          'translation': '''Artinya: "Siapa saja yang berpuasa pada bulan Ramadhan atas dasar beriman dan mengharapkan pahala maka dosa-dosanya di masa lalu akan diampuni."''',
        },
        {
          'type': 'text',
          'content': '''Berdasarkan hadits ini cukup jelas kiranya bahwa puasa yang dilaksanakan pada bulan Ramadhan dapat menghapus dosa-dosa masa lalu seorang hamba. Dengan syarat, puasa yang dikerjakannya berdasarkan keimanan dan harapan mendapatkan pahala. Jadi puasa Ramadhan yang dikerjakan bukan karena ikut-ikutan lingkungan, atau bahkan tren media sosial.''',
        },
        {
          'type': 'text',
          'content': '''Imam Muslim saat menjelaskan hadits-hadits tentang sebuah ibadah yang secara otomatis dapat menghapus dosa-dosa seseorang menegaskan bahwa dosa-dosa di sini terbatas hanya pada dosa kecil saja, bukan dosa besar. Sebab bila melakukan dosa besar maka cara melenyapkannya bukan hanya dengan beribadah saja, melainkan harus memohon ampun dan bertaubat dengan sungguh-sungguh.''',
        },
        {
          'type': 'text',
          'content': '''Hal ini masuk akal kiranya, sebab setiap kita pasti memiliki dosa kecil, entah sengaja maupun tidak. Maka untuk menghapusnya cukup dengan memperbanyak ibadah yang biasa kita lakukan. Terlebih lagi bila ibadah tersebut dilakukan pada bulan Ramadhan, maka peluang ampunan yang akan diperoleh menjadi lebih besar.''',
        },
        {
          'type': 'text',
          'content': '''Hadirin shalat Jumat yang dimuliakan Allah,''',
        },
        {
          'type': 'text',
          'content': '''Selain itu, uraian terkait keutamaan bulan Ramadhan di atas diperkuat juga dengan hadis riwayat Bukhari Muslim yang berbunyi:''',
        },
        {
          'type': 'arabic',
          'content': '''إِذَا جَاءَ رَمَضَانُ فُتِّحَتْ أَبْوَابُ الْجَنَّةِ وَغُلِّقَتْ أَبْوَابُ النَّارِ وَصُفِّدَتِ الشَّيَاطِينُ''',
          'translation': '''Artinya: "Apabila bulan Ramadhan tiba maka pintu-pintu sorga dibuka, pintu-pintu neraka ditutup, dan setan-setan dikerangkeng."''',
        },
        {
          'type': 'text',
          'content': '''Hadits ini hendak menegaskan dari saking mulianya bulan Ramadhan membuat tempat mulia seperti surga dibuka lebar-lebar, sedangkan tempat dan makhluk yang hina ditutup dan dirantai agar tidak bisa mengganggu kekhidmatan ibadah pada bulan ini.''',
        },
        {
          'type': 'text',
          'content': '''Ibadah yang dikerjakan pada bulan ini akan memudahkan kita diantarkan pada tempat yang indah sebagaimana dijanjikan bagi orang beriman, begitu juga jalan menuju tempat yang buruk ditutup, termasuk mahluk yang terlibat di dalamnya, yakni para setan dikurung agar tidak menggoda umat Islam dalam beribadah selama Ramadhan.''',
        },
        {
          'type': 'text',
          'content': '''Semoga kita mendapatkan kemuliaan dan keberkahan bulan ini, sehingga nanti setelah Ramadhan usai kita menjadi pribadi-pribadi yang lebih bertakwa dan semakin semangat beribadahnya.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ الله لِي وَلَكُمْ فِي اْلقُرْآنِ اْلعَظِيْمِ وَنَفَعَنِي وَإِيَّاكُمْ بِمَا فِيْهِ مِنَ اْلآيَاتِ وَذِكْرِ الْحَكِيْمِ. أَقُوْلُ قَوْلِي هَذَا فَأسْتَغْفِرُ اللهَ العَظِيْمَ إِنَّهُ هُوَ الغَفُوْرُ الرَّحِيْمِ.''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''الْحَمْدُ لِلّٰهِ. وَالصَّلَاةُ وَالسَّلَامُ عَلَى نَبِيِّنَا مُحَمَّدٍ بنِ عَبدِ الله وَعَلَى اٰلِهِ وَأَصْحَابِهِ وَمَنْ تَبِعَهُمْ بِإِحْسَانٍ إِلَى يَوْمِ القِيَامَة. أَشْهَدُ أَنْ لَّا إِلهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ، لَا نَبِيَّ بَعْدَهُ. أَمَّا بَعْدُ فَيَا أَيُّهَا الْحَاضِرُوْنَ المُسلِمُونَ. اِتَّقُوا اللهَ حَقَّ تُقَاتِهِ وَاعلَمُوا إِنَّ ٱللَّهَ مَعَ ٱلَّذِينَ ٱتَّقَواْ وَّٱلَّذِينَ هُم مُّحْسِنُونَ. قَالَ تَعاَلَى إِنَّ اللهَ وَمَلآئِكَتَهُ يُصَلُّوْنَ عَلىَ النَّبِى يآ اَيُّهَا الَّذِيْنَ آمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا
اَللهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَاْلمُؤْمِنَاتِ وَاْلمُسْلِمِيْنَ وَاْلمُسْلِمَاتِ اَلاَحْيآءُ مِنْهُمْ وَاْلاَمْوَاتِ اللهُمَّ أَعِزَّ اْلإِسْلاَمَ وَاْلمُسْلِمِيْنَ وَأَذِلَّ الشِّرْكَ وَاْلمُشْرِكِيْنَ. اللهُمَّ ادْفَعْ عَنَّا اْلبَلاَءَ وَاْلوَبَاءَ وَالزَّلاَزِلَ وَاْلمِحَنَ وَسُوْءَ اْلفِتْنَةِ وَاْلمِحَنَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا اِنْدُونِيْسِيَّا خآصَّةً وَسَائِرِ بُلْدَانِ اْلمُسْلِمِيْنَ عآمَّةً يَا رَبَّ اْلعَالَمِيْنَ. رَبَّنَا آتِناَ فِى الدُّنْيَا حَسَنَةً وَفِى اْلآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ. رَبَّنَا ظَلَمْنَا اَنْفُسَنَا وَإنْ لَمْ تَغْفِرْ لَنَا وَتَرْحَمْنَا لَنَكُوْنَنَّ مِنَ اْلخَاسِرِيْنَ
عِبَادَاللهِ! إِنَّ اللهَ يَأْمُرُكُم بِاْلعَدْلِ وَاْلإِحْسَانِ وَإِيْتآءِ ذِي اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشآءِ وَاْلمُنْكَرِ وَاْلبَغْي يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ وَاذْكُرُوا اللهَ اْلعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلىَ نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللهِ أَكْبَر''',
        },
        {
          'type': 'text',
          'content': '''Ustadz M. Syarofuddin Firdaus, Dosen Pesantren Luhur Ilmu Hadits Darus-Sunnah Ciputat''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Puasa Sebagai Sistem Perlindungan Diri',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Khutbah Jumat ini mengingatkan kepada pembaca tentang fungsi strategis puasa sebagai sistem perlindungan diri manusia, utamanya dari serangan setan yang terus mengalir bersamaan aliran darah manusia.''',
        },
        {
          'type': 'text',
          'content': '''Khutbah Jumat ini berjudul: "Khutbah Jumat: Puasa Sebagai Sistem Perlindungan Diri". Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat! (Redaksi).''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ للهِ رَبِّ الْعَالَمِيْنَ. اَللَّهُمَّ لَكَ الْحَمْدُ كَمَا يَنْبَغِيْ لِجَلَالِ وَجْهِكَ وَعَظِيْمِ سُلْطَانِكَ. وَأَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ. اَللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَيْهِ وَعَلَى آلِهِ وَأَصْحَابِهِ أَجْمَعِيْنَ. أما بعد''',
        },
        {
          'type': 'arabic',
          'content': '''فَإِنِّيْ أُوْصِيْ نَفْسِيْ وَإِيَّاكُمْ بِتَقْوَى اللهِ فَقَدْ فَازَ الْمُتَّقُوْن. قَالَ اللهُ تعالى: يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِينَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُونَ (سورة البقرة: 183)
وَقَالَ النَّبِيُّ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ: الصَّوْمُ جُنَّةٌ (متفق عليه)''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral muslimin rakhimakumullah.
Dengan didasari rasa syukur yang kita buka dengan memperbanyak kalimat alhamdulillahi Rabbil \'alamin, serta dengan shalawat kepada Baginda Rasulullah, kami mengingatkan diri kami pribadi sekaligus mengajak segenap jamaah kaum Muslimin seluruhnya untuk meningkatkan komitmen kita dalam bertakwa kepada Allah.''',
        },
        {
          'type': 'text',
          'content': '''Dalam ayat yang telah kami bacakan tadi, kita telah diberikan petunjuk oleh Allah bahwa supaya kita selalu bertakwa, selalu terjaga dari hal-hal yang membahayakan diri kita di dunia maupun di akhirat, maka kita diwajibkan untuk berpuasa.''',
        },
        {
          'type': 'arabic',
          'content': '''Kemudian Rasulullah saw menjelaskan dalam sebuah hadis yang telah kami sampaikan tadi, bahwa puasa adalah sebagai benteng, perisai, perlindungan diri. Itulah simbol ketakwaan, keterjagaan, keterlindungan yang terkandung dalam ayat: لَعَلَّكُمْ تَتَّقُونَ.''',
        },
        {
          'type': 'text',
          'content': '''Hari ini, kita tengah berada di  bulan Ramadan. Bulan bagi kita untuk menyempurnakan rukun Islam, yaitu puasa. Tanpa puasa Ramadan, keislaman kita tidak sempurna.''',
        },
        {
          'type': 'text',
          'content': '''Dalam sebuah hadis, Rasulullah mengibaratkan Islam seperti bangunan. Rukun Islam adalah tiang-tiang utama yang menegakkan bangunan. Sedangkan tiang bangunan ibarat kaki pada struktur tubuh kita. Jika salah satu tiang utama ini tidak ada, maka bangunan ini menjadi rawan roboh, minimal menjadi bangunan yang doyong. Bahkan, bangunan keislaman bisa roboh jika sampai tiang puasa ini diingkari, dikufuri, tidak dipercaya sebagai syariat Islam.''',
        },
        {
          'type': 'arabic',
          'content': '''Ma\'asyiral muslimin rakhimakumullah.
Di antara makna ayat: لَعَلَّكُمْ تَتَّقُونَ dan hadis اَلصَّوْمُ جُنَّةٌ adalah puasa melindungi dan menjaga kita dari godaan setan yang selalu menjauhkan kita dari Allah. Puasa menjadi benteng yang melindungi kita dari masuknya setan ke dalam jiwa kita.''',
        },
        {
          'type': 'text',
          'content': '''Puasa, sebagai salah satu rukun Islam, memiliki hikmah dan tujuan yang mendalam yang harus kita pahami. Sebagaimana yang disebutkan dalam hadis yang mulia, bahwa puasa memiliki maqashid (tujuan-tujuan) yang mulia. Salah satu tujuan puasa adalah untuk membentengi diri kita dari godaan setan.''',
        },
        {
          'type': 'arabic',
          'content': '''عَنْ صَفِيَّةَ أُمِّ الْمُؤْمِنِيْنَ رَضِيَ اللهُ عَنْهَا، أَنَّ النَّبِيَّ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ قَالَ: إِنَّ الشَّيْطَانَ يَجْرِيْ مِنِ ابْنِ آدَمَ مَجْرَى الدَّمِ. (أخرجه البخاري ومسلم)''',
          'translation': '''Artinya, "Diriwayatkan oleh Ibunda Shafiyyah ra, sungguh Rasulullah saw bersabda, "Sesungguhnya setan mengalir dalam tubuh anak Adam seperti mengalirnya darah." Atau bisa juga kita terjemahkan "Sesungguhnya setan itu masuk ke dalam jiwa manusia melalui aliran darah." (HR Al-Bukhari dan Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Hikmah yang terkandung dalam sabda Rasulullah saw adalah untuk mengingatkan kita bahwa setan masuk ke dalam tubuh manusia melalui jalan peredaran darah. Alat peredaran darah ini tergantung pada bahan bakarnya, yaitu makanan dan minuman yang kita konsumsi. Karena itu, pintu masuk utama setan ke dalam tubuh manusia adalah melalui mulut.''',
        },
        {
          'type': 'text',
          'content': '''Setan menggunakan dua jalur utama untuk masuk ke dalam tubuh manusia, yaitu melalui konsumsi makanan dan komunikasi. Pertama, melalui makanan dan minuman yang haram, kotor, tidak halal, dan tidak thayyib. Kedua, melalui kata-kata yang keluar dari mulut kita setelah mengonsumsi makanan tersebut.''',
        },
        {
          'type': 'arabic',
          'content': '''Ma\'asyiral muslimin rakhimakumullah.
Berkali-kali Al-Quran menegaskan bahwa setan adalah musuh yang nyata: عَدُوٌّ مُبِيْنٌ bagi kita. Kita pun wajib mengimaninya. Rasulullah pun menjelaskan bagaimana setan bekerja memusuhi kita, sangat lembut, sangat halus.''',
        },
        {
          'type': 'text',
          'content': '''Karena itu pulalah, Imam Al-Ghazali menyatakan, salah satu pilar menghidupkan ilmu-ilmu agama yang Allah berikan kepada kita adalah mengenali musuh-musuh diri dan memahami strateginya serta menguasai cara untuk mengalahkannya. Itulah yang disebut oleh beliau sebagai lubbul quran (intinya inti dari ajaran Al-Quran), jauharul quran (permata Al-Quran). Ini semua dapat kita temukan dalam karya beliau, Jawahirul Quran.''',
        },
        {
          'type': 'text',
          'content': '''Puasa mengajarkan kita untuk mengendalikan hawa nafsu dan mengontrol konsumsi makanan dan minuman kita. Dengan membatasi makan dan minum selama puasa, kita dapat mempersempit jalan masuk setan ke dalam tubuh kita. Ini adalah salah satu dari banyak hikmah puasa yang harus kita hayati.''',
        },
        {
          'type': 'text',
          'content': '''Itulah yang oleh Imam Izzuddin bin Abdissalam tegaskan dalam kitabnya, Maqashidus Shaum:''',
        },
        {
          'type': 'arabic',
          'content': '''اَلصَّوْمُ قَهْرٌ لِلشَّيْطَانِ. فَإِنَّ وَسِيْلَتَهُ إِلَى الْإضْلَالِ وَاْلإِغْوَاءِ: الشَّهَوَاتُ، وَإِنَّـمَا تَقْوَى الشَّهَوَاتُ بِاْلأَكْلِ وَالشًّرْبِ. وَالصَّوْمُ يُضَيِّقُ مَجَارِي الدَّمِ، فَتَضِيْقُ مَجَارِي الشَّيْطَانِ، فَيُقْهَرَ بِذَلِكَ''',
          'translation': '''Artinya, "Puasa adalah penaklukan (qahrun) terhadap setan. Karena, jalan bagi setan untuk menyesatkan dan menggoda adalah hawa nafsu, dan hawa nafsu dikuatkan dengan makan dan minum. Puasa mempersempit aliran darah, sehingga jalan-jalan masuknya setan dalam tubuh kita pun menyempit. Dengan demikian, setan pun bisa dikalahkan."''',
        },
        {
          'type': 'text',
          'content': '''Dari sinilah, kita bisa memahami bahwa puasa itu membentengi kita dari serangan setan yang menyelinap ke dalam jiwa kita melalui makanan. Dengan puasa, kita juga membentengi keislaman kita, karena rukun-rukun atau tiang-tiang penyangga bangunan keislaman kita menjadi sempurna dan kokoh.''',
        },
        {
          'type': 'text',
          'content': '''Dengan puasa pula, nafsu dan syahwat kita terkendali sehingga kita tidak mengabdi kepada nafsu yang tidak pernah memberikan kepuasan dan ketenangan, melainkan kita bisa lebih maksimal dan totalitas dalam mengabdi kepada Allah semata.''',
        },
        {
          'type': 'text',
          'content': '''Sebagai umat Islam, kita harus memahami bahwa puasa bukan hanya sekadar menahan lapar dan haus, tetapi juga merupakan latihan spiritual untuk membentengi diri kita dari godaan setan dan mendekatkan diri kita kepada Allah.''',
        },
        {
          'type': 'text',
          'content': '''Karena itulah, Rasulullah sangat ketat dalam hal manajemen makan dan minum kita. Beliau ingin sekali memastikan bahwa makanan dan minuman yang masuk ke dalam tubuh kita bebas dari setan.''',
        },
        {
          'type': 'text',
          'content': '''Karena itu, beliau sering menegur orang yang makan dan minum menggunakan tangan kiri karena cara tersebut adalah cara makan setan. Itulah petunjuk beliau. Beliau juga menegur keras anak-anak hingga orang dewasa yang kedapatan makan secara terburu-buru sehingga tidak menyebut nama Allah dalam makanannya itu. Beliau pun tertawa lepas Ketika melihat setan memuntahkan kembali makanan yang dibacakan nama Allah di suapan terakhirnya.''',
        },
        {
          'type': 'text',
          'content': '''Begitulah sistem penjagaan dan perlindungan yang Allah berikan kepada orang-orang yang berpuasa. Terlihat sederhana, melalui manajemen makanan, bukan sekedar soal pola makan, kandungan gizi, melainkan juga kehalalan, kethayyiban, dan juga spiritualitas makanan dan minuman.''',
        },
        {
          'type': 'text',
          'content': '''Ma\'asyiral muslimin rakhimakumullah.
Selain puasa konsumsi, syariat puasa juga mengajarkan kita untuk mengendalikan lidah kita dalam berkomunikasi. Dengan menahan diri dari berkata-kata yang tidak bermanfaat atau menyakiti orang lain, kita dapat menjaga diri kita dari godaan setan yang masuk melalui komunikasi.''',
        },
        {
          'type': 'text',
          'content': '''Setan akan masuk melalui komunikasi buruk seperti penghinaan, caci maki, kata-kata kotor, hasud, adu domba, ghibah, menyebarkan isu yang tidak jelas kebenarannya. Semua itu adalah bersumber dari lisan, melalui komunikasi.''',
        },
        {
          'type': 'text',
          'content': '''Dengan puasa, keselamatan kita pun terjaga. Kita ingat bahwa puasa itu mengajarkan kita untuk menata komunikasi kita supaya selalu positif.''',
        },
        {
          'type': 'text',
          'content': '''Karena, puasa tidak hanya mengajarkan diri untuk menahan diri dari makan dan minum saja, melainkan juga menahan diri dari omongan-omongan yang tidak berguna. Sedangkan, omongan yang tidak berguna berpotensi besar mengganggu diri dan orang lain. Sebagaimana Rasulullah tegaskan bahwa:''',
        },
        {
          'type': 'arabic',
          'content': '''الْمُسْلِمُ مَنْ سَلِمَ الْمُسْلِمُوْنَ مِنْ لِسَانِهِ (رواه مسلم)''',
          'translation': '''Artinya, "Disebut Muslim sejati adalah ketika orang-orang muslim lain selamat dari lisannya." (HR Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Para ulama juga selalu mengingatkan kita:''',
        },
        {
          'type': 'arabic',
          'content': '''سَلَامَةُ الْإِنْسَانِ فِيْ حِفْظِ اللِّسَانِ''',
          'translation': '''Artinya, "Keselamatan manusia itu tergantung pada kemampuannya menjaga lisan."''',
        },
        {
          'type': 'text',
          'content': '''Kita bisa melihat puasa komunikasi seperti ini dalam Al-Quran dicontohkan oleh Sayyidah Maryam binti Imran, ibunda Nabi Isa as:''',
        },
        {
          'type': 'arabic',
          'content': '''فَكُلِي وَاشْرَبِي وَقَرِّي عَيْنًا ۖ فَإِمَّا تَرَيِنَّ مِنَ الْبَشَرِ أَحَدًا فَقُولِي إِنِّي نَذَرْتُ لِلرَّحْمَٰنِ صَوْمًا فَلَنْ أُكَلِّمَ الْيَوْمَ إِنْسِيًّا''',
          'translation': '''Artinya, "Maka makan, minum, dan bersenang hatilah kamu. Jika kamu melihat seorang manusia, maka katakanlah: "Sesungguhnya aku telah bernazar berpuasa untuk Tuhan Yang Maha Pemurah, maka aku tidak akan berbicara dengan seorang manusiapun pada hari ini". (QS Maryam: 26).''',
        },
        {
          'type': 'text',
          'content': '''Inilah puasa yang Istimewa, yaitu disebut dengan istilah shaum. Menahan diri dari komunikasi yang tidak berguna. Ia bukan sekedar disebut shiyam yang secara praktiknya adalah menahan diri dari makan dan minum.''',
        },
        {
          'type': 'text',
          'content': '''Bahkan dalam ayat ini disebutkan bahwa Sayyidah Maryam diperintahkan untuk makan dan minum. Namun, berliau justru diperintah Allah untuk berpuasa dari omongan-omongan yang tidak berdampak positif.''',
        },
        {
          'type': 'arabic',
          'content': '''Demikian itu pulalah sistem yang Allah buatkan untuk kita dalam rangka melindungi keselamatan kita sendiri. Itulah salah satu makna perlindungan, penjagaan dalam ayat: لَعَلَّكُمْ تَتَّقُونَ dan dalam benteng pertahanan atau tameng dalam hadis: اَلصَّوْمُ جُنَّةٌ.''',
        },
        {
          'type': 'text',
          'content': '''Marilah kita manfaatkan bulan Ramadan sebagai kesempatan untuk meningkatkan kualitas ibadah dan memperkuat pertahanan diri dari godaan setan. Semoga Allah memberikan kita kekuatan dan kesabaran untuk menjalankan puasa dengan ikhlas dan penuh keikhlasan. Amin.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ الله لِي وَلَكُمْ فِي اْلقُرْآنِ اْلعَظِيْمِ وَنَفَعَنِي وَإِيَّاكُمْ بِمَا فِيْهِ مِنْ الآيَاتِ وَالذِّكْرِ الْحَكِيْمِ. أَقُوْلُ قَوْلِي هَذَا فَأسْتَغْفِرُ اللهَ العَظِيْمَ لِيْ وَلَكُمْ وَلِسَائِرِ الْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ، إِنَّهُ هُوَ الغَفُوْرُ الرَّحِيْم''',
        },
        {
          'type': 'text',
          'content': '''Khutbah Kedua''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ لِلَّهِ حَمْدًا كَثِيْرًا كَمَا أَمَرَ، أَشْهَدُ أَنْ لَا اِلَهَ اِلَّا الله وَحْدَهُ لَا شَرِيْكَ لَهُ إِرْغَامًا لِمَنْ جَحَدَ بِهِ وَكَفَرَ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ سَيِّدُ الْخَلَائِقِ وَالْبَشَرِ. اَللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى أَلِهِ وَصَحْبِهِ وَمَنْ تَبِعَهُمْ بِإِحْسَانٍ إِلَى يَوْمِ الْمَحْشَرِ، أَمَّا بَعْدُ''',
        },
        {
          'type': 'arabic',
          'content': '''فَيَا أَيُّهَا النَّاسُ أُوْصِيْكُمْ وَنَفْسِيْ بِتَقْوَى اللهِ فَقَدْ فَازَ الْمُتَّقُوْنَ. فَقَالَ اللهُ تَعَالَى: إِنَّ اللهَ وَمَلَائِكَتَهُ يُصَلُّوْنَ عَلَى النَّبِيِّ، يٰأَيُّها الَّذِيْنَ آمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا. اَللَّهُمَّ صَلِّ عَلَى سَيِّدَنَا مُحَمَّدٍ وَعَلَى أَلِ سَيِّدَنَا مُحَمَّدٍ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللّهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَاْلمُؤْمِنَاتِ وَاْلمُسْلِمِيْنَ وَاْلمُسْلِمَاتِ، اَلْأَحْياءِ مِنْهُمْ وَاْلاَمْوَاتِ. اللهُمَّ كَمَا شَرَّفْتَنَا بِاْلإِيْمَانِ بِكَ، وَكَرَّمْتَنَا فِيْ أَرْكَانِ الإِسْلَامِ بِالصِّيَامِ لَكَ، أَعِنَّا عَلَى طَاعَتِكَ فِيْهِ، وَاجْعَلِ اللَّهُمَّ صَفَاءَ أَرْوَاحِنَا فِي اسْتِقْبَالِهِ وَسِيْلَةً لِلْإِجَابَةِ فِي كُلِّ مَا نَسْأَلُ مِمَّا عَلَّمْتَنَا أَنْ نَدْعُوَكَ بِهِ فِي قَوْلِكَ فِيْ كِتَابِكَ الْكَرِيْمِ. اَلَّلهُمَّ أَعِنَّا عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ. اَللَّهُمَّ حَبِّبْ إِلَيْنَا اْلإِيْمَانَ وَزَيِّنْهُ فِيْ قُلُوْبِنَا وَكَرِّهْ إِلَيْنَا الْكُفْرَ وَالْفُسُوْقَ وَالْعِصْيَانَ وَاجْعَلْنَا مِنَ الرَّاشِدِيْنَ. اَللَّهُمَّ إِنَّا نَسْأَلُكَ رِضَاكَ وَالْجَنَّةَ وَنَعُوْذُ بِكَ مِنْ سَخَطِكَ وَالنَّارِ. اَللَّهُمَّ إِنَّكَ عَفُوٌّ كَرِيْمٌ، تُحِبُّ الْعَفْوَ فَاعْفُ عَنَّا. اللهُمَّ ادْفَعْ عَنَّا اْلبَلاَءَ وَاْلوَبَاءَ وَالزَّلاَزِلَ وَاْلمِحَنَ وَسُوْءَ اْلفِتَنِ وَاْلمِحَنَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا إِنْدُونِيْسِيَّا خآصَّةً وَسَائِرِ بُلْدَانِ اْلمُسْلِمِيْنَ عامَّةً يَا رَبَّ اْلعَالَمِيْنَ. اللَّهُمَّ أَرِنَا الْحَقَّ حَقًّا وَارْزُقْنَا اتِّبَاعَهُ وَأَرِنَا الْبَاطِلَ بَاطِلًا وَارْزُقْنَا اجْتِنَابَهُ. رَبَّنَا آتِناَ فِى الدُّنْيَا حَسَنَةً وَفِى اْلآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ. وَاَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''عٍبَادَ اللهِ، إِنَّ اللهَ يَأْمُرُ بِاْلعَدْلِ وَاْلإِحْسَانِ وَإِيْتاءِ ذِي اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشاءِ وَاْلمُنْكَرِ وَاْلبَغْيِ يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ، وَاذْكُرُوا اللهَ اْلعَظِيْمَ يَذْكُرْكُمْ، وَلَذِكْرُ اللهِ أَكْبَرْ''',
        },
        {
          'type': 'text',
          'content': '''Dr Ahmad \'Ubaydi Hasbillah, Pengasuh Ma\'had Al-Jami\'ah Universitas Hasyim Asy\'ari Tebuireng''',
        }
      ]
    },
    {
      'title': 'Khutbah Jumat: Puasa Ramadhan dan Ketakwaan Sosial',
      'date': '14 Ramadhan 1445 H',
      'sections': [
        {
          'type': 'text',
          'content': '''Puasa Ramadhan merupakan sarana yang tepat untuk membentuk ketakwaan sosial. Orang yang bertakwa tidak hanya menjaga diri dari maksiat, tetapi juga peduli terhadap sesama. Bulan Ramadhan adalah momentum yang tepat untuk membentuk dimensi sosial itu.''',
        },
        {
          'type': 'text',
          'content': '''Materi khutbah Jumat ini berjudul: "Khutbah Jumat Ramadhan: Puasa Ramadhan dan Ketakwaan Sosial" Untuk mencetak naskah khutbah Jumat ini, silakan klik ikon print berwarna merah di atas atau bawah artikel ini (pada tampilan desktop). Semoga bermanfaat.''',
        },
        {
          'type': 'text',
          'content': '''Khutbah I''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ للهِ. اَلْحَمْدُ للهِ الَّذِيْ يَحْشُرُنَا فِي الْمَحْشَرِ. أَشْهَدُ اَنْ لَا اِلٰهَ اِلَّا اللهُ الْمَلِكُ الْجَبَّارُ وَأَشْهَدُ اَنَّ حَبِيْبَنَا وَ نَبِيَّنّا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ سَيِّدُ الْاِنْسِ وَالْبَشَرِ. اَللّٰهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلٰى سَيِّدِنَا مُحَمَّدٍ وَعَلٰى اٰلِهِ وَاَصْحَابِهِ اَجْمَعِيْنَ . اَمَّا بَعْدُ فَيَاأَيُّهَا الْحَاضِرُوْنَ, اِتَّقُوا اللهَ حَقَّ تُقَاتِهِ وَلَا تَمُوْتُنَّ اِلَّا وَأَنْتُمْ مُسْلِمُوْنَ. قَالَ اللهُ تَعَالَى فِي الْقُرْاٰنِ الْعَظِيْمِ. أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ وَالْعَصْرِۙ اِنَّ الْاِنْسَانَ لَفِيْ خُسْرٍۙ اِلَّا الَّذِيْنَ اٰمَنُوْا وَعَمِلُوا الصّٰلِحٰتِ وَتَوَاصَوْا بِالْحَقِّ ەۙ وَتَوَاصَوْا بِالصَّبْرِ''',
        },
        {
          'type': 'text',
          'content': '''Hadirin sidang Jumat yang berbahagia''',
        },
        {
          'type': 'text',
          'content': '''Pada khutbah singkat ini, khatib mengajak diri sendiri dan seluruh jamaah untuk meningkatkan ketakwaan kepada Allah swt, terutama di bulan Ramadan yang penuh berkah ini. Puasa Ramadan yang diwajibkan kepada kita bertujuan untuk mencapai ketakwaan. Oleh karena itu, marilah kita semua di bulan Ramadan ini meningkatkan ketakwaan kepada Allah swt dengan melaksanakan semua kewajiban dan meninggalkan segala larangan.''',
        },
        {
          'type': 'text',
          'content': '''Hadirin jamaah Jumat yang berbahagia''',
        },
        {
          'type': 'text',
          'content': '''Ibadah puasa di bulan Ramadhan tidak hanya berdimensi spiritual semata. Lebih dari itu, puasa Ramadhan juga menjadi sarana efektif untuk membentuk ketakwaan sosial.  Konsep ketakwaan yang hakiki tidak berhenti pada hubungan vertikal antara manusia dengan Tuhannya, namun juga berwujud dalam hubungan horizontal antar sesama manusia.''',
        },
        {
          'type': 'text',
          'content': '''Landasan ini ditegaskan dalam firman Allah SWT dalam QS. Al-Baqarah ayat 183:''',
        },
        {
          'type': 'arabic',
          'content': '''يٰٓاَيُّهَا الَّذِيْنَ اٰمَنُوْا كُتِبَ عَلَيْكُمُ الصِّيَامُ كَمَا كُتِبَ عَلَى الَّذِيْنَ مِنْ قَبْلِكُمْ لَعَلَّكُمْ تَتَّقُوْنَۙ''',
          'translation': '''Artinya: "Wahai orang-orang yang beriman, diwajibkan atas kamu berpuasa sebagaimana diwajibkan atas orang-orang sebelum kamu agar kamu bertakwa."''',
        },
        {
          'type': 'text',
          'content': '''Syekh Nawawi Banten kitab Tafsir Marah Labid mengatakan bahwa ujung dari puasa adalah membentuk diri menjadi orang yang takwa. Keutamaan itu akan tercapai dengan berpuasa dan meninggalkan hawa nafsu. Puasa melatih diri untuk menahan diri dari berbagai godaan, termasuk makan dan minum, serta hawa nafsu lainnya. Hal ini tidak mudah, tetapi jika berhasil, maka akan lebih mudah untuk bertakwa kepada Allah dalam hal lain.''',
        },
        {
          'type': 'text',
          'content': '''Dalam Islam, takwa merupakan salah satu konsep fundamental yang menjadi kunci meraih derajat tinggi di sisi Allah swt. Takwa bukan hanya sebatas ritual keagamaan, namun merupakan sebuah komitmen menyeluruh untuk menjalankan seluruh perintah Allah dan menjauhi segala larangan-Nya.''',
        },
        {
          'type': 'text',
          'content': '''Allah telah menjanjikan derajat tinggi bagi orang-orang yang bertakwa dalam ayat Al-Quran Surat Al-Hujurat ayat 13:''',
        },
        {
          'type': 'arabic',
          'content': '''اِنَّ اَكْرَمَكُمْ عِنْدَ اللّٰهِ اَتْقٰىكُمْ ۗاِنَّ اللّٰهَ عَلِيْمٌ خَبِيْرٌ''',
          'translation': '''Artinya: "Sesungguhnya yang paling mulia di antara kamu di sisi Allah adalah orang yang paling bertakwa. Sesungguhnya Allah Maha Mengetahui lagi Maha Teliti."''',
        },
        {
          'type': 'text',
          'content': '''Hadirin jamaah Jumat yang berbahagia''',
        },
        {
          'type': 'text',
          'content': '''Ayat ini menunjukkan bahwa ketakwaan merupakan tolak ukur kemuliaan seseorang di sisi Allah. Tidak peduli pangkat, jabatan, harta, ataupun keturunan, yang paling mulia di mata Allah adalah orang yang paling bertakwa.''',
        },
        {
          'type': 'text',
          'content': '''Dalam sebuah hadits Rasulullah saw bersabda bahwa Allah tidak menilai manusia berdasarkan rupa dan harta mereka, melainkan berdasarkan hati dan amal mereka. Manusia yang paling mulia di sisi Allah adalah yang paling bertakwa.''',
        },
        {
          'type': 'arabic',
          'content': '''إِنَّ اللَّهَ لاَ يَنْظُرُ إِلَى صُوَرِكُمْ، وَلاَ إِلَى أَمْوَالِكُمْ، وَلَكِنْ يَنْظُرُ إِلَى قُلُوبِكُمْ، وَأَعْمَالِكُمْ، وَإِنَّمَا أَنْتُمْ بَنُو آدَمَ أَكْرَمُكُمْ عِنْدَ اللَّهِ أَتْقَاكُمْ''',
          'translation': '''Artinya: "Sesungguhnya Allah tidak melihat kepada rupa kalian dan harta kalian, tetapi Dia melihat kepada hati kalian dan amal kalian. Dan sesungguhnya yang paling mulia di sisi Allah di antara kalian adalah orang yang paling bertakwa." (HR Muslim)''',
        },
        {
          'type': 'text',
          'content': '''Hadirin jamaah Jumat yang berbahagia''',
        },
        {
          'type': 'text',
          'content': '''Puasa bukan hanya tentang menahan lapar dan dahaga, tetapi juga melatih diri untuk menahan hawa nafsu. Hawa nafsu ini dapat mendorong kita untuk melakukan perbuatan yang tidak terpuji, seperti berkata-kata kasar, menipu, dan membicarakan kejelekan orang lain.''',
        },
        {
          'type': 'text',
          'content': '''Dengan berpuasa, kita belajar untuk mengendalikan hawa nafsu tersebut dan menggantinya dengan perilaku yang lebih baik. Kita belajar untuk lebih bersabar, menahan diri dari berkata kasar, dan menjaga lisan kita dari perkataan yang tidak baik. Rasulullah saw bersabda:''',
        },
        {
          'type': 'arabic',
          'content': '''عَنْ أَبِي هُرَيْرَةَ رَضِيَ اللَّهُ عَنْهُ رِوَايَةً قَالَ إِذَا أَصْبَحَ أَحَدُكُمْ يَوْمًا صَائِمًا فَلَا يَرْفُثْ وَلَا يَجْهَلْ فَإِنْ امْرُؤٌ شَاتَمَهُ أَوْ قَاتَلَهُ فَلْيَقُلْ إِنِّي صَائِمٌ إِنِّي صَائِمٌ''',
          'translation': '''Artinya: "Dari Abu Hurairah ra, beliau berkata, "Jika salah seorang dari kalian berpuasa pada suatu hari, maka janganlah berkata-kata kotor dan janganlah berbuat jahil. Jika ada orang yang memakinya atau mengajaknya berkelahi, maka hendaklah dia berkata, \'Sesungguhnya aku sedang berpuasa, sesungguhnya aku sedang berpuasa." (HR. Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Puasa juga membantu kita untuk lebih berempati terhadap orang lain yang kurang beruntung. Ketika kita merasakan lapar dan dahaga, kita akan lebih memahami bagaimana rasanya hidup dalam kekurangan. Hal ini dapat mendorong kita untuk lebih dermawan dan membantu orang lain yang membutuhkan.''',
        },
        {
          'type': 'text',
          'content': '''Hadirin jamaah Jumat yang berbahagia''',
        },
        {
          'type': 'text',
          'content': '''Pada hadits lain, dijelaskan bahwa para sahabat menyaksikan Rasulullah orang yang paling dermawan di antara manusia lainnya. Kedermawanan beliau semakin terlihat jelas pada bulan Ramadhan.''',
        },
        {
          'type': 'arabic',
          'content': '''كَانَ رَسُولُ اللهِ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ أَجْوَدَ النَّاسِ وَكَانَ أَجْوَدَ مَا يَكُونُ فِي رَمَضَانَ''',
          'translation': '''Artinya: "Rasulullah saw adalah orang paling dermawan di antara manusia lainnya, dan ia semakin dermawan saat berada di bulan Ramadhan" (HR Bukhari dan Muslim).''',
        },
        {
          'type': 'text',
          'content': '''Hadirin sidang Jumat yang berbahagia''',
        },
        {
          'type': 'text',
          'content': '''Untuk itu, dengan menjalankan puasa dengan benar, kita tidak hanya meningkatkan keimanan pribadi, tetapi juga berkontribusi positif pada lingkungan sekitar. Puasa menjadi sarana untuk membangun ketakwaan sosial dan menciptakan masyarakat yang lebih sejahtera dan harmonis. Bagaimana hal ini bisa terjadi?''',
        },
        {
          'type': 'text',
          'content': '''Pertama, puasa melatih kita untuk lebih peka terhadap kebutuhan orang lain. Rasa lapar dan dahaga yang kita rasakan selama berpuasa dapat membangkitkan empati terhadap mereka yang kekurangan. Hal ini mendorong kita untuk lebih dermawan dan membantu mereka yang membutuhkan, baik secara materi maupun non-materi.''',
        },
        {
          'type': 'text',
          'content': '''Selanjutnya, puasa mendorong kita untuk menghindari perbuatan yang dapat merugikan orang lain. Berbohong, ghibah, dan perilaku negatif lainnya dapat membatalkan pahala puasa. Dengan menghindari perbuatan tersebut, kita menciptakan lingkungan yang lebih positif dan kondusif bagi semua orang.''',
        },
        {
          'type': 'arabic',
          'content': '''بَارَكَ اللهُ لِي وَلَكُمْ فِي الْقُرْآنِ الْعَظِيمِ، وَنَفَعَنِي وَإِيَّاكُمْ بِمَا فِيهِ مِنَ الآيَاتِ وَالذِّكْرِ الْحَكِيمِ. أَقُولُ قَوْلِي هَذَا وَأَسْتَغْفِرُ اللهَ لِي وَلَكُمْ، وَلِسَائِرِ الْمُسْلِمِينَ وَالْمُسْلِمَاتِ، وَالْمُؤْمِنِينَ وَالْمُؤْمِنَاتِ، فَاسْتَغْفِرُوهُ. إِنَّهُ هُوَ الْغَفُورُ الرَّحِيمُ''',
        },
        {
          'type': 'text',
          'content': '''Khutbah II''',
        },
        {
          'type': 'arabic',
          'content': '''اَلْحَمْدُ ِللهِ الَّذِيْ أَمَرَنَا بِاْلاِعْتِصَامِ بِحَبْلِ اللهِ، أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ وَأَشْهَدُ أَنَّ سَيِّدَنَا مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ لاَ نَبِيَّ بَعْدَهُ. اَللَّهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَعَلَى آلِهِ وَصَحْبِهِ وَمَنْ تَبِعَ هُدَاهُ. أَمَّا بَعْدُ . فَيَا عِبَادَ اللهِ اِتَّقُوا اللهَ فِيْمَا اَمَرَ وَانْتَهُوْا عَمَّا نَهَى. قال تعالى: مَن جَاء بِالْحَسَنَةِ فَلَهُ عَشْرُ أَمْثَالِهَا وَمَن جَاء بِالسَّيِّئَةِ فَلاَ يُجْزَى إِلاَّ مِثْلَهَا وَهُمْ لاَ يُظْلَمُونَ

وَاعْلَمُوْا اَنَّ اللهَ اَمَرَكُمْ بِاَمْرٍ بَدَأَ فِيْهِ بِنَفْسِهِ وَثَـنَّى بِمَلآ ئِكَتِهِ بِقُدْسِهِ وَقَالَ تَعاَلَى اِنَّ اللهَ وَمَلآ ئِكَتَهُ يُصَلُّوْنَ عَلىَ النَّبِى يآ اَيُّهَا الَّذِيْنَ آمَنُوْا صَلُّوْا عَلَيْهِ وَسَلِّمُوْا تَسْلِيْمًا. اللهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمْ وَعَلَى آلِ سَيِّدِنَا مُحَمَّدٍ وَعَلَى اَنْبِيآئِكَ وَرُسُلِكَ وَمَلآئِكَةِ اْلمُقَرَّبِيْنَ وَارْضَ اللّهُمَّ عَنِ اْلخُلَفَاءِ الرَّاشِدِيْنَ اَبِى بَكْرٍ وَعُمَر وَعُثْمَان وَعَلِي وَعَنْ بَقِيَّةِ الصَّحَابَةِ وَالتَّابِعِيْنَ وَتَابِعِي التَّابِعِيْنَ لَهُمْ بِاِحْسَانٍ اِلَى يَوْمِ الدِّيْنِ وَارْضَ عَنَّا مَعَهُمْ بِرَحْمَتِكَ يَا اَرْحَمَ الرَّاحِمِيْنَ''',
        },
        {
          'type': 'arabic',
          'content': '''اَللهُمَّ اغْفِرْ لِلْمُؤْمِنِيْنَ وَاْلمُؤْمِنَاتِ وَاْلمُسْلِمِيْنَ وَاْلمُسْلِمَاتِ اَلاَحْيآءِ مِنْهُمْ وَاْلاَمْوَاتِ اللهُمَّ ادْفَعْ عَنَّا اْلبَلاَءَ وَاْلوَبَاءَ وَالزَّلاَزِلَ وَاْلمِحَنَ مَا ظَهَرَ مِنْهَا وَمَا بَطَنَ عَنْ بَلَدِنَا اِنْدُونِيْسِيَّا خآصَّةً وَسَائِرِ بُلْدَانِ اْلمُسْلِمِيْنَ عآمَّةً يَا رَبَّ اْلعَالَمِيْنَ. اللَّهُمَّ بَارِكْ لَنَا فِي رَجَب وَشَعْبَانَ وَبَلِّغْنَا رَمَضَانَ. اللَّهُمَّ لَا تَدَعْ لَنَا فِي مَقَامِنَا هَذَا ذَنْبًا إِلَّا غَفَرْتَهُ، وَلَا هَمًّا إِلَّا فَرَّجْتَهُ، وَلَا حَاجَةً مِنْ حَوَائِجِ الدُّنْيَا وَالْآخِرَةِ إِلَّا قَضَيْتَهَا وَيَسَّرْتَهَا فَيَسِّرْ أَمُورَنَا وَنَوِّرْ قُلُوبَنَا بِنُورِ هدَايَتِكَ كَمَا نَوَّرْتَ الْأَرْضَ بِنُورِ شَمْسِكَ. رَبَّنَا آتِناَ فِى الدُّنْيَا حَسَنَةً وَفِى اْلآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ''',
        },
        {
          'type': 'arabic',
          'content': '''عِبَادَ اللهِ اِنَّ اللهَ يَأْمُرُ بِاْلعَدْلِ وَاْلاِحْسَانِ وَإِيْتآءِ ذِى اْلقُرْبىَ وَيَنْهَى عَنِ اْلفَحْشآءِ وَاْلمُنْكَرِ وَاْلبَغْي يَعِظُكُمْ لَعَلَّكُمْ تَذَكَّرُوْنَ وَاذْكُرُوااللهَ اْلعَظِيْمَ يَذْكُرْكُمْ وَاشْكُرُوْهُ عَلىَ نِعَمِهِ يَزِدْكُمْ وَلَذِكْرُ اللهِ اَكْبَرْ''',
        },
        {
          'type': 'text',
          'content': '''Ustadz Masrur Irsyadi, Pengajar Ma\'had Ali UIN Jakarta''',
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
              const SizedBox(width: 8),
              _buildChip('Kultum Ramadhan', Icons.chrome_reader_mode_outlined, _selectedCategory == 'Kultum Ramadhan', () => setState(() => _selectedCategory = 'Kultum Ramadhan')),
              const SizedBox(width: 8),
              _buildChip('Khutbah Idul Fitri', Icons.assignment_outlined, _selectedCategory == 'Khutbah Idul Fitri', () => setState(() => _selectedCategory = 'Khutbah Idul Fitri')),
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
                      : _selectedCategory == 'Kultum Ramadhan'
                          ? _kultumMenu
                          : _selectedCategory == 'Khutbah Idul Fitri'
                              ? _khutbahIdulFitriMenu
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
                      if (_selectedCategory == 'Artikel Ramadhan' || 
                          _selectedCategory == 'Khutbah Ramadhan' || 
                          _selectedCategory == 'Kultum Ramadhan' || 
                          _selectedCategory == 'Khutbah Idul Fitri') {
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
                          if (_selectedCategory == 'Artikel Ramadhan' || _selectedCategory == 'Khutbah Ramadhan' || _selectedCategory == 'Kultum Ramadhan' || _selectedCategory == 'Khutbah Idul Fitri')
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
