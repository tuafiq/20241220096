class DoaModel {
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;

  const DoaModel({
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });
}

class TahlilModel {
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String? note;

  const TahlilModel({
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.note,
  });
}

class DoaData {
  static const List<DoaModel> listDoaHarian = [
    DoaModel(
      title: 'Doa Sebelum Tidur 1',
      arabic: 'بِاسْمِكَ رَبِّيْ وَضَعْتُ جَنْبِيْ، وَبِكَ أَرْفَعُهُ، إِنْ أَمْسَكْتَ نَفْسِيْ فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِيْنَ',
      transliteration: 'Bismika robbii wa dho\'tu janbii, wa bika arfa\'uhu, in amsakta nafsii farhamhaa, wa in arsaltahaa fahfazhhaa bimaa tahfazhu bihi \'ibaadakash-sholihiin.',
      translation: 'Dengan nama Engkau, wahai Tuhanku, aku meletakkan lambungku. Dan dengan namaMu pula aku bangun daripadanya. Apabila Engkau menahan rohku (mati), maka berilah rahmat padanya. Tapi apabila Engkau melepaskannya, maka peliharalah, sebagaimana Engkau memelihara hamba-hambaMu yang shalih.',
    ),
    DoaModel(
      title: 'Doa Sebelum Tidur 2',
      arabic: 'بِاسْمِكَ اللَّهُمَّ أَمُوْتُ وَأَحْيَا',
      transliteration: 'Bismika-llaahumma amuutu wa ahyaa.',
      translation: 'Dengan Nama-Mu ya Allah, aku mati dan aku hidup.',
    ),
    DoaModel(
      title: 'Doa Bila Takut Dan Kesepian Ketika Tidur',
      arabic: 'أَعُوْذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ غَضَبِهِ وَعِقَابِهِ، وَشَرِّ عِبَادِهِ، وَمِنْ هَمَزَاتِ الشَّيَاطِيْنِ وَأَنْ يَحْضُرُوْنِ',
      transliteration: 'A\'uudzu bikalimaatillaahit-taammaati min ghodhobihi wa \'iqoobihi, wa syarri \'ibaadihi, wa min hamazaatisy-syayaathiini wa an yahdhuruun.',
      translation: 'Aku berlindung dengan kalimat Allah yang sempurna dari kemarahan dan siksaanNya, serta kejahatan hamba-hambaNya, dan dari godaan setan (bisikannya) serta jangan sampai mereka hadir (kepadaku).',
    ),
    DoaModel(
      title: 'Doa Membalikkan Tubuh Ketika Tidur Malam',
      arabic: 'لاَ إِلَـٰهَ إِلاَّ اللَّهُ الْواحِدُ الْقَهَّارُ، رَبُّ السَّمَاوَاتِ وَاْلأَرْضِ وَمَا بَيْنَهُمَا الْعَزِيْزُ الْغَفَّارُ',
      transliteration: 'Laa ilaaha illallaahul waahidul qohhaar, robbus-samaawaati wal ardhi wa maa bainahumal \'aziizul ghoffaar.',
      translation: 'Tidak ada sesembahan yang berhak disembah kecuali Allah, Yang Maha Esa, Maha Perkasa, Tuhan yang menguasai langit dan bumi dan apa yang di antara keduanya, Yang Maha Mulia lagi Maha Pengampun.',
    ),
    DoaModel(
      title: 'Doa Bila Terjaga Di Malam Hari',
      arabic: 'لاَ إِلَـٰهَ إِلاَّ اللَّهُ، وَحْدَهُ لاَ شَرِيْكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيْرٌ، اَلْحَمْدُ لِلَّهِ، وَسُبْحَانَ اللَّهِ، وَلاَ إِلَـٰهَ إِلاَّ اللَّهُ، وَاللَّهُ أَكْبَرُ، وَلاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ',
      transliteration: 'Laa ilaaha illallaah, wahdahu laa syariika lah, lahul mulku wa lahul hamdu, wa huwa \'alaa kulli syai-in qodiir, alhamdulillaah, wa subhaanallaah, wa laa ilaaha illallaah, wallaahu akbar, wa laa haula wa laa quwwata illaa billaah.',
      translation: 'Tidak ada sesembahan yang berhak disembah kecuali Allah, Yang Maha Esa, tiada sekutu bagiNya. BagiNya kerajaan dan pujian. Dia-lah Yang Maha Kuasa atas segala sesuatu. Segala Puji bagi Allah, Maha Suci Allah, tidak ada sesembahan yang berhak disembah kecuali Allah, Allah Maha Besar, tiada daya dan kekuatan kecuali dengan pertolongan Allah.',
    ),
    DoaModel(
      title: 'Doa Bangun Tidur 1',
      arabic: 'اَلْحَمْدُ لِلَّهِ الَّذِيْ أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُوْرِ',
      transliteration: 'Alhamdulillaahil-ladzii ahyaanaa ba\'da maa amaatanaa wa ilaihin-nusyuur.',
      translation: 'Segala puji bagi Allah, yang membangunkan kami setelah ditidurkanNya dan kepadaNya kami dibangitkan.',
    ),
    DoaModel(
      title: 'Doa Bangun Tidur 2',
      arabic: 'اَلْحَمْدُ لِلَّهِ الَّذِيْ عَافَانِيْ فِيْ جَسَدِيْ، وَرَدَّ عَلَيَّ رُوْحِيْ، وَأَذِنَ لِيْ بِذِكْرِهِ',
      transliteration: 'Alhamdulillaahil-ladzii \'aafaanii fii jasadii, wa rodda \'alayya ruuhii, wa adzina lii bidzikrih.',
      translation: 'Segala puji bagi Allah yang telah memberikan kesehatan pada jasadku dan mengembalikan ruhku kepadaku serta mengizinkanku untuk berdzikir kepadaNya.',
    ),
    DoaModel(
      title: 'Doa Masuk Kamar Mandi',
      arabic: '(بِسْمِ اللَّهِ) اَللَّهُمَّ إِنِّيْ أَعُوْذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ',
      transliteration: '(Bismillaah) Allaahumma innii a\'uudzu bika minal khubutsi wal khobaa-its.',
      translation: 'Dengan nama Allah. Ya Allah, sesungguhnya aku berlindung kepadaMu dari godaan setan laki-laki dan perempuan.',
    ),
    DoaModel(
      title: 'Doa Keluar Kamar Mandi',
      arabic: 'غُفْرَانَكَ',
      transliteration: 'Ghufroonak.',
      translation: 'Aku minta ampun kepadaMu.',
    ),
    DoaModel(
      title: 'Doa Sebelum Wudhu',
      arabic: 'بِسْمِ اللَّهِ',
      transliteration: 'Bismillaah.',
      translation: 'Dengan nama Allah (aku berwudhu).',
    ),
    DoaModel(
      title: 'Doa Setelah Wudhu',
      arabic: 'أَشْهَدُ أَنْ لاَ إِلَـٰهَ إِلاَّ اللَّهُ، وَحْدَهُ لاَ شَرِيْكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُوْلُهُ',
      transliteration: 'Asyhadu al-laa ilaaha illallaah, wahdahu laa syariika lah, wa asyhadu anna muhammadan \'abduhu wa rosuuluh.',
      translation: 'Aku bersaksi, bahwa tidak ada sesembahan yang berhak disembah kecuali Allah, Yang Maha Esa dan tiada sekutu bagiNya. Aku bersaksi, bahwa Muhammad adalah hamba dan utusanNya.',
    ),
    DoaModel(
      title: 'Doa Mengenakan Pakaian',
      arabic: 'اَلْحَمْدُ لِلَّهِ الَّذِيْ كَسَانِيْ هَـٰذَا (الثَّوْبَ) وَرَزَقَنِيْهِ مِنْ غَيْرِ حَوْلٍ مِنِّيْ وَلاَ قُوَّةٍ',
      transliteration: 'Alhamdulillaahil-ladzii kasaanii haadzats-tsauba wa rozaqoniihi min ghoiri haulin minnii wa laa quwwah.',
      translation: 'Segala puji bagi Allah yang memberi pakaian ini kepadaku sebagai rezeki dariNya tanpa daya dan kekuatan dariku.',
    ),
    DoaModel(
      title: 'Doa Mengenakan Pakaian Baru',
      arabic: 'اَللَّهُمَّ لَكَ الْحَمْدُ أَنْتَ كَسَوْتَنِيْهِ، أَسْأَلُكَ مِنْ خَيْرِهِ وَخَيْرِ مَا شُنِعَ لَهُ، وَأَعُوْذُ بِكَ مِنْ شَرِّهِ وَشَرِّ مَا شُنِعَ لَهُ',
      transliteration: 'Allaahumma lakal hamdu anta kasautaniihi, as-aluka min khoirihi wa khoiri maa shuni\'a lahu, wa a\'uudzu bika min syarrihi wa syarri maa shuni\'a lah.',
      translation: 'Ya Allah, hanya milikMu segala puji, Engkaulah yang memberi pakaian ini kepadaku. Aku mohon kepadaMu untuk memperoleh kebaikannya dan kebaikan yang ia diciptakan karenanya. Aku berlindung kepadaMu dari kejahatannya dan kejahatan yang ia diciptakan karenanya.',
    ),
    DoaModel(
      title: 'Doa Melepas/Meletakkan Pakaian',
      arabic: 'بِسْمِ اللَّهِ',
      transliteration: 'Bismillaah',
      translation: 'Dengan nama Allah (aku meletakkan baju).',
    ),
    DoaModel(
      title: 'Doa Berlindung Dari Keburukan',
      arabic: 'اَللَّهُمَّ إِنِّيْ أَعُوْذُ بِكَ مِنْ زَوَالِ نِعْمَتِكَ، وَتَحَوُّلِ عَافِيَتِكَ، وَفُجَاءَةِ نِقْمَتِكَ، وَجَمِيْعِ سَخَطِكَ',
      transliteration: 'Allaahumma innii a\'uudzu bika min zawaali ni\'matik, wa tahawwuli \'aafiyatik, wa fujaa-ati niqmatik, wa jamii\'i sakhathik.',
      translation: 'Ya Allah, sesungguhnya aku berlindung kepada-Mu dari hilangnya nikmat yang telah Engkau berikan, dari berubahnya kesehatan yang telah Engkau anugerahkan, dari siksa-Mu yang datang secara tiba-tiba, dan dari segala kemurkaan-Mu.',
    ),
    DoaModel(
      title: 'Doa Berlindung Dari Sifat Malas, Lemah, Pikun, Kikir',
      arabic: 'اَللَّهُمَّ إِنِّى أَعُوذُ بِكَ مِنَ الْكَسَلِ، وَأَعُوذُ بِكَ مِنَ الْجُبْنِ، وَأَعُوذُ بِكَ مِنَ الْهَرَمِ، وَأَعُوذُ بِكَ مِنَ الْبُخْلِ',
      transliteration: 'Allaahumma innii a\'uudzu bika minal kasali, wa a\'uudzu bika minal jubni, wa a\'uudzu bika minal haromi, wa a\'uudzu bika minal bukhli.',
      translation: 'Ya Allah, aku meminta perlindungan pada-Mu dari rasa malas, aku meminta perlindungan pada-Mu dari lemahnya hati, aku meminta perlindungan pada-Mu dari usia tua (yang sulit untuk beramal) dan aku meminta perlindungan pada-Mu dari sifat kikir (pelit).',
    ),
    DoaModel(
      title: 'Doa Berlindung Dari Syirik',
      arabic: 'اَللَّهُمَّ إِنِّيْ أَعُوْذُ بِكَ أَنْ أُشْرِكَ بِكَ وَأَنَا أَعْلَمُ، وَأَسْتَغْفِرُكَ لِمَا لاَ أَعْلَمُ',
      transliteration: 'Allaahumma innii a\'uudzu bika an usyrika bika wa anaa a\'lam, wa astagh-firuka limaa laa a\'lam.',
      translation: 'Ya Allah, aku berlindung kepada-Mu dari menyekutukan-Mu sedangkan aku mengetahuinya, dan aku memohon ampun terhadap apa yang tidak aku ketahui.',
    ),
    DoaModel(
      title: 'Doa Memohon Ampun Diri Sendiri Dan Orang Tua',
      arabic: 'رَبَّنَا اغْفِرْ لِي وَلِوَالِدَيَّ وَلِلْمُؤْمِنِينَ يَوْمَ يَقُومُ الْحِسَابُ',
      transliteration: 'Robbanagh-fir lii wa liwaalidayya wa lil mu\'miniina yauma yaquumul hisaab.',
      translation: 'Ya Tuhan kami, beri ampunlah aku dan kedua ibu bapakku dan sekalian orang-orang mukmin pada hari terjadinya hisab (hari kiamat).',
    ),
    DoaModel(
      title: 'Doa Naik Kendaraan',
      arabic: 'بِسْمِ اللَّهِ، اَلْحَمْدُ لِلَّهِ (سُبْحَانَ الَّذِيْ سَخَّرَ لَنَا هَـٰذَا وَمَا كُنَّا لَهُ مُقْرِنِيْنَ. وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُوْنَ) اَلْحَمْدُ لِلَّهِ، اَلْحَمْدُ لِلَّهِ، اَلْحَمْدُ لِلَّهِ، اَللَّهُ أَكْبَرُ، اَللَّهُ أَكْبَرُ، اَللَّهُ أَكْبَرُ، سُبْحَانَكَ اللَّهُمَّ إِنِّيْ ظَلَمْتُ نَفْسِيْ فَاغْفِرْ لِيْ، فَإِنَّهُ لاَ يَغْفِرُ الذُّنُوْبَ إِلاَّ أَنْتَ',
      transliteration: 'Bismillaah, alhamdulillaah, (subhaanal-ladzii sakh-khoro lanaa haadzaa wa maa kunnaa lahu muqriniin. Wa innaa ilaa robbinaa lamunqolibuun), alhamdulillaah (3x), allaahu akbar (3x), subhaanakallaahumma innii zholamtu nafsii faghfir lii, fa-innahu laa yaghfirudz-dzunuuba illaa anta.',
      translation: 'Dengan nama Allah, segala puji bagi Allah, (Maha Suci Tuhan yang menundukkan kendaraan ini untuk kami, padahal kami sebelumnya tidak mampu menguasainya. Dan sesungguhnya kami akan kembali kepada Tuhan kami (di hari Kiamat)). Segala puji bagi Allah (3x), Allah Maha Besar (3x), Maha Suci Engkau ya Allah, sesungguhnya aku menganiaya diriku, maka ampunilah aku. Sesungguhnya tidak ada yang mengampuni dosa-dosa kecuali Engkau.',
    ),
    DoaModel(
      title: 'Doa Musafir Kepada Orang Yang Ditinggalkan',
      arabic: 'أَسْتَوْدِعُكُمُ اللَّهَ الَّذِيْ لاَ تَضِيْعُ وَدَائِعُهُ',
      transliteration: 'Astaudi\'ukumullaahal-ladzii laa tadhii\'u wa daa-i\'uh.',
      translation: 'Aku menitipkan kamu kepada Allah yang tidak akan hilang titipan-Nya.',
    ),
    DoaModel(
      title: 'Doa Orang Mukim Kepada Musafir',
      arabic: 'أَسْتَوْدِعُ اللَّهَ دِيْنَكَ وَأَمَانَتَكَ وَخَوَاتِيْمَ عَمَلِكَ',
      transliteration: 'Astaudi\'ullaaha diinaka wa amaanataka wa khowaatiima \'amalik.',
      translation: 'Aku menitipkan agamamu, amanatmu dan penutup amalmu kepada Allah.',
    ),
    DoaModel(
      title: 'Doa Bepergian',
      arabic: 'اَللَّهُ أَكْبَرُ، اَللَّهُ أَكْبَرُ، اَللَّهُ أَكْبَرُ، (سُبْحَانَ الَّذِيْ سَخَّرَ لَنَا هَـٰذَا وَمَا كُنَّا لَهُ مُقْرِنِيْنَ. وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُوْنَ) اَللَّهُمَّ إِنَّا نَسْأَلُكَ فِيْ سَفَرِنَا هَـٰذَا الْبِرَّ وَالتَّقْوَى، وَمِنَ الْعَمَلِ مَا تَرْضَى، اَللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرِنَا هَـٰذَا وَاطْوِ عَنَّا بُعْدَهُ، اَللَّهُمَّ أَنْتَ الصَّاحِبُ فِي السَّفَرِ وَالْخَلِيْفَةُ فِي اْلأَهْلِ، اَللَّهُمَّ إِنِّيْ أَعُوْذُ بِكَ مِنْ وَعْثَاءِ السَّفَرِ وَكَآبَةِ الْمَنْظَرِ وَسُوْءِ الْمُنْقَلَبِ فِي الْمَالِ وَاْلأَهْلِ',
      transliteration: 'Allaahu akbar (3x), (subhaanal-ladzii sakh-khoro lanaa haadzaa wa maa kunnaa lahu muqriniin. Wa innaa ilaa robbinaa lamunqolibuun), allaahumma innaa nas-aluka fii safarinaa haadzal birro wat-taqwaa, wa minal \'amali maa tardhoo, allaahumma hawwin \'alainaa safaronaa haadzaa wathwi \'annaa bu\'dah, allaahumma antash-shoohibu fis-safari wal kholiifatu fil ahli, allaahumma innii a\'uudzu bika min wa\'tsaa-is-safari wa ka-aabatil manzhori wa suu-il munqolabi fil maali wal ahli.',
      translation: 'Allah Maha Besar (3x). (Maha Suci Tuhan yang menundukkan kendaraan ini untuk kami, padahal kami sebelumnya tidak mampu menguasainya. Dan sesungguhnya kami akan kembali kepada Tuhan kami (di hari Kiamat)). Ya Allah, sesungguhnya kami memohon kebaikan dan taqwa dalam bepergian ini, kami mohon perbuatan yang meridhakanMu. Ya Allah, permudahlah perjalanan kami ini, dan dekatkan jaraknya bagi kami. Ya Allah, Engkaulah teman dalam bepergian dan yang mengurusi keluarga(ku). Ya Allah, sesungguhnya aku berlindung kepada-Mu dari kelelahan dalam bepergian, pemandangan yang menyedihkan dan kepulangan yang jelek dalam harta dan keluarga.',
    ),
    DoaModel(
      title: 'Doa Musafir Menjelang Subuh',
      arabic: 'سَمَّعَ سَامِعٌ بِحَمْدِ اللَّهِ، وَحُسْنِ بَلاَئِهِ عَلَيْنَا. رَبَّنَا صَاحِبْنَا، وَأَفْضِلْ عَلَيْنَا عَائِذًا بِاللَّهِ مِنَ النَّارِ',
      transliteration: 'Samma\'a saami\'un bihamdillaah, wa husni balaa-ihi \'alainaa. robbanaa shoohibnaa, wa afdhil \'alainaa \'aa-idzan billaahi minan-naar.',
      translation: 'Semoga ada yang memperdengarkan puji kami kepada Allah (atas nikmat) dan cobaanNya yang baik bagi kami. Wahai Tuhan kami, temanilah kami (peliharalah kami) dan berilah karunia kepada kami dengan berlindung kepada Allah dari api Neraka.',
    ),
    DoaModel(
      title: 'Doa Singgah Di Suatu Tempat',
      arabic: 'أَعُوْذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
      transliteration: 'A\'uudzu bikalimaatillaahit-taammaati min syarri maa kholaq.',
      translation: 'Aku berlindung dengan kalimat-kalimat Allah yang sempurna, dari kejahatan apa yang diciptakan-Nya.',
    ),
    DoaModel(
      title: 'Doa Masuk Desa Atau Kota',
      arabic: 'اَللَّهُمَّ رَبَّ السَّمَاوَاتِ السَّبْعِ وَمَا أَظْلَلْنَ، وَرَبَّ اْلأَرَضِيْنَ السَّبْعِ وَمَا أَقْلَلْنَ، وَرَبَّ الشَّيَاطِيْنِ وَمَا أَضْلَلْنَ، وَرَبَّ الرِّيَاحِ وَمَا ذَرَيْنَ. أَسْأَلُكَ خَيْرَ هَـٰذِهِ الْقَرْيَةِ وَخَيْرَ أَهْلِهَا، وَخَيْرَ مَا فِيْهَا، وَأَعُوْذُ بِكَ مِنْ شَرِّهَا وَشَرِّ أَهْلِهَا وَشَرِّ مَا فِيْهَا',
      transliteration: 'Allaahumma robbas-samaawaatis-sab\'i wa maa azhlalna, wa robbal arodhiinas-sab\'i wa maa aqlalna, wa robbasy-syayaathiini wa maa adhlalna, wa robbar-riyaahi wa maa dzaroina. As-aluka khoiro haadzihil quryati wa khoiro ahlihaa, wa khoiro maa fiihaa, wa a\'uudzu bika min syarrihaa wa syarri ahlihaa wa syarri maa fiihaa.',
      translation: 'Ya Allah, Tuhan tujuh langit dan apa yang dinaunginya, Tuhan penguasa tujuh bumi dan apa yang di atasnya, Tuhan yang menguasai setan-setan dan apa yang mereka sesatkan, Tuhan yang menguasai angin dan apa yang diterbangkannya. Aku mohon kepadaMu kebaikan desa ini, kebaikan penduduknya dan apa yang ada di dalamnya. Aku berlindung kepadaMu dari kejelekan desa ini, kejelekan penduduknya dan apa yang ada di dalamnya.',
    ),
    DoaModel(
      title: 'Doa Masuk Pasar / Pusat Keramaian',
      arabic: 'لاَ إِلَـٰهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِيْ وَيُمِيْتُ وَهُوَ حَيٌّ لاَ يَمُوْتُ، بِيَدِهِ الْخَيْرُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيْرٌ',
      transliteration: 'Laa ilaaha illallaah, wahdahu laa syariika lah, lahul mulku wa lahul hamd, yuhyii wa yumiit, wa huwa hayyun laa yamuut, biyadihil khoir, wa huwa \'alaa kulli syai-in qodiir.',
      translation: 'Tidak ada sesembahan yang berhak disembah kecuali Allah, Yang Maha Esa, tiada sekutu bagiNya. BagiNya kerajaan, bagiNya segala pujian. Dia-lah Yang Menghidupkan dan Yang Mematikan. Dia-lah Yang Hidup, tidak akan mati. Di tanganNya kebaikan. Dia-lah Yang Maha kuasa atas segala sesuatu.',
    ),
    DoaModel(
      title: 'Doa Bila Kendaraan Tergelincir',
      arabic: 'بِسْمِ اللَّهِ',
      transliteration: 'Bismillaah.',
      translation: 'Dengan nama Allah.',
    ),
    DoaModel(
      title: 'Doa Pulang Dari Bepergian',
      arabic: 'اَللَّهُ أَكْبَرُ، اَللَّهُ أَكْبَرُ، اَللَّهُ أَكْبَرُ. لاَ إِلَـٰهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيْكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيْرٌ. آيِبُوْنَ تَائِبُوْنَ عَابِدُوْنَ لِرَبِّنَا حَامِدُوْنَ، صَدَقَ اللَّهُ وَعْدَهُ وَنَصَرَ عَبْدَهُ وَهَزَمَ اْلأَحْزَابَ وَحْدَهُ',
      transliteration: 'Allaahu akbar (3x). Laa ilaaha illallaah, wahdahu laa syariika lah, lahul mulku wa lahul hamdu, wa huwa \'alaa kulli syai-in qodiir. Aayibuuna taa-ibuuna \'aabiduuna lirobbinaa haamiduun, shodaqollaahu wa\'dah, wa nashoro \'abdah, wa hazamal ahzaaba wahdah.',
      translation: 'Allah Maha Besar (3x). Tidak ada sesembahan yang berhak disembah kecuali Allah, Yang Maha Esa, tiada sekutu bagiNya. Bagi-Nya kerajaan dan pujaan. Dia-lah Yang Mahakuasa atas segala sesuatu. Kami kembali dengan bertaubat, beribadah dan memuji kepada Tuhan kami. Allah telah menepati janjiNya, membela hambaNya (Muhammad) dan mengalahkan golongan musuh dengan sendirian.',
    ),
    DoaModel(
      title: 'Doa Kepada Orang Yang Menawarkan Harta',
      arabic: 'بَارَكَ اللَّهُ لَكَ فِيْ أَهْلِكَ وَمَالِكَ',
      transliteration: 'Baarokallaahu laka fii ahlika wa maalika.',
      translation: 'Semoga Allah memberkahimu dalam keluarga dan hartamu.',
    ),
    DoaModel(
      title: 'Doa Membayar Hutang',
      arabic: 'بَارَكَ اللَّهُ لَكَ فِيْ أَهْلِكَ وَمَالِكَ، إِنَّمَا جَزَاءُ السَّلَفِ الْحَمْدُ وَاْلأَدَاءُ',
      transliteration: 'Baarokallaahu laka fii ahlika wa maalika, innamaa jazaa-us-salafil hamdu wal adaa-u.',
      translation: 'Semoga Allah memberikan berkah kepadamu dalam keluarga dan hartamu. Sesungguhnya balasan meminjami adalah pujian dan pembayaran.',
    ),
    DoaModel(
      title: 'Doa Ketika Sempit Rizki',
      arabic: 'اَللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ وَرَحْمَتِكَ، فَإِنَّهُ لاَ يَمْلِكُهَا إِلاَّ أَنْتَ',
      transliteration: 'Allaahumma innii as-aluka min fadhlika wa rohmatik, fa-innahu laa yamlikuhaa illaa anta.',
      translation: 'Ya Allah, aku memohon kepada-Mu akan sebagian karunia-Mu dan rahmat-Mu, karena sesungguhnya tidak ada yang memilikinya kecuali Engkau.',
    ),
    DoaModel(
      title: 'Doa Ketika Orang Sibuk Dengan Harta',
      arabic: 'اَللَّهُمَّ إِنِّي أَسْأَلُكَ الثَّبَاتَ فِي الْأَمْرِ، وَالْعَزِيمَةَ عَلَى الرُّشْدِ، وَأَسْأَلُكَ مُوجِبَاتِ رَحْمَتِكَ، وَعَزَائِمَ مَغْفِرَتِكَ، وَأَسْأَلُكَ شُكْرَ نِعْمَتِكَ، وَحُسْنَ عِبَادَتِكَ، وَأَسْأَلُكَ قَلْبًا سَلِيمًا، وَلِسَانًا صَادِقًا، وَأَسْأَلُكَ مِنْ خَيْرِ مَا تَعْلَمُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا تَعْلَمُ، وَأَسْتَغْفِرُكَ لِمَا تَعْلَمُ، إِنَّكَ أَنْتَ عَلَّامُ الْغُيُوبِ',
      transliteration: 'Allaahumma innii as-alukats-tsabaata fil amri, wal \'aziimata \'alar-rusydi, wa as-aluka muujibaati rohmatika, wa \'azaa-ima magh-firotika, wa as-aluka syukro ni\'matika, wa husna \'ibaadatika, wa as-aluka qolban saliiman, wa lisaanan shoodiqon, wa as-aluka min khoiri maa ta\'lam, wa a\'uudzu bika min syarri maa ta\'lam, wa astagh-firuka limaa ta\'lam, innaka anta \'allaamul ghuyuub.',
      translation: 'Ya Allah, aku memohon kepada-Mu keteguhan dalam segala perkara, dan kesungguhan dalam petunjuk. Aku memohon kepada-Mu segala yang bisa mendatangkan rahmat-Mu, segala yang bisa mengundang ampunan-Mu. Aku memohon kepada-Mu rasa syukur atas nikmat-Mu, dan ibadah yang bagus kepada-Mu. Aku memohon kepada-Mu hati yang selamat, dan lisan yang jujur. Aku memohon kepada-Mu kebaikan yang Engkau ketahui, aku berlindung kepada-Mu dari keburukan yang engkau ketahui, dan aku memohon ampun kepada-Mu atas dosa yang Engkau ketahui. Sesungguhnya Engkau Maha Mengetahui perkara-perkara ghaib.',
    ),
    DoaModel(
      title: 'Doa Berlindung Dari Malas, Hutang, Fitnah Kubur',
      arabic: 'اَللَّهُمَّ إِنِّيْ أَعُوْذُ بِكَ مِنَ الْكَسَلِ وَالْهَرَمِ، وَالْمَأْثَمِ وَالْمَغْرَمِ، وَمِنْ فِتْنَةِ الْقَبْرِ وَعَذَابِ الْقَبْرِ، وَمِنْ فِتْنَةِ النَّارِ وَعَذَابِ النَّارِ، وَمِنْ شَرِّ فِتْنَةِ الْغِنَى، وَأَعُوْذُ بِكَ مِنْ فِتْنَةِ الْفَقْرِ، وَأَعُوْذُ بِكَ مِنْ فِتْنَةِ الْمَسِيْحِ الدَّجَّالِ',
      transliteration: 'Allaahumma innii a\'uudzu bika minal kasali wal haromi, wal ma\'tsami wal maghromi, wa min fitnatil qobri wa \'adzaabil qobri, wa min fitnatin-naari wa \'adzaabin-naari, wa min syarri fitnatil ghinaa, wa a\'uudzu bika min fitnatil faqri, wa a\'uudzu bika min fitnatil masiihid-dajjaal.',
      translation: 'Ya Allah, aku berlindung kepada-Mu dari kemalasan dan pikun/usia jompo, perbuatan dosa dan hutang, fitnah kubur dan azab kubur, fitnah neraka dan azab neraka, keburukan fitnah kekayaan, aku berlindung kepada-Mu dari fitnah kemisminan dan aku berlindung kepada-Mu dari fitnah Al-Masih Dajjal.',
    ),
    DoaModel(
      title: 'Doa Agar Terbebas Hutang',
      arabic: 'اَللَّهُمَّ اكْفِنِيْ بِحَلاَلِكَ عَنْ حَرَامِكَ وَأَغْنِنِيْ بِفَضْلِكَ عَمَّنْ سِوَاكَ',
      transliteration: 'Allaahummakfinii bihalaalika \'an haroomika, wa aghninii bifadhlika \'amman siwaak.',
      translation: 'Ya Allah, cukupilah aku dengan rezekiMu yang halal (hingga aku terhindar) dari yang haram. Jadikanlah aku kaya dengan karuniaMu (hingga aku tidak minta) kepada selainMu.',
    ),
    DoaModel(
      title: 'Doa Bila Tertimpa Musibah',
      arabic: 'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُوْنَ، اَللَّهُمَّ أُجُرْنِيْ فِيْ مُصِيْبَتِيْ وَأَخْلِفْ لِيْ خَيْرًا مِنْهَا',
      transliteration: 'Innaa lillaahi wa innaa ilaihi rooji\'uun, allaahumma ujurnii fii mushiibatii wa akhlif lii khoiron minhaa.',
      translation: 'Sesungguhnya kami milik Allah dan kepadaNya kami akan kembali (di hari Kiamat). Ya Allah, berilah pahala kepadaku dan gantilah untukku dengan yang lebih baik (dari musibahku).',
    ),
    DoaModel(
      title: 'Doa Melihat Orang Tertimpa Musibah',
      arabic: 'اَلْحَمْدُ لِلَّهِ الَّذِيْ عَافَانِيْ مِمَّا ابْتَلَاكَ بِهِ، وَفَضَّلَنِيْ عَلَى كَثِيْرٍ مِمَّنْ خَلَقَ تَفْضِيْلًا',
      transliteration: 'Alhamdulillaahil-ladzii \'aafaanii mimmab-talaaka bihi, wa fadh-dholanii \'alaa katsiirin mimman kholaqo tafdhiilan.',
      translation: 'Segala puji bagi Allah yang telah menyelamatkanku dari musibah yang menimpamu, dan benar-benar memuliakanku dari banyak makhluk lainnya.',
    ),
    DoaModel(
      title: 'Bacaan Bila Ada Sesuatu Menyenangkan',
      arabic: 'اَلْحَمْدُ لِلَّهِ الَّذِي بِنِعْمَتِهِ تَتِمُّ الصَّالِحَاتُ',
      transliteration: 'Alhamdulillaahil-ladzii bini\'matihi tatimmush-shoolihaat.',
      translation: 'Segala puji bagi Allah yang dengan nikmat-Nya segala amal shalih sempurna.',
    ),
    DoaModel(
      title: 'Doa Agar Musibah Tidak Menimpa Agama',
      arabic: 'وَلَا تَجْعَلْ مُصِيْبَتَنَا فِي دِيْنِنَا، وَلَا تَجْعَلِ الدُّنْيَا أَكْبَرَ هَمِّنَا، وَلَا مَبْلَغَ عِلْمِنَا',
      transliteration: 'Wa laa taj\'al mushiibatanaa fii diininaa, wa laa taj\'alid-dunyaa akbaro hamminaa, wa laa mablagho \'ilminaa.',
      translation: '(Ya Allah) Janganlah Engkau jadikan musibah pada kami menimpa agama kami. Janganlah Engkau jadikan dunia (harta dan kemewahan) sebagai cita-cita terbesar kami, jangan juga sebagai tujuan utama dari ilmu kami.',
    ),
    DoaModel(
      title: 'Doa Ketika Sedih / Galau',
      arabic: 'اَللَّهُمَّ إِنِّيْ عَبْدُكَ، وَابْنُ عَبْدِكَ، وَابْنُ أَمَتِكَ، نَاصِيَتِيْ بِيَدِكَ، مَاضٍ فِيَّ حُكْمُكَ، عَدْلٌ فِيَّ قَضَاؤُكَ، أَسْأَلُكَ بِكُلِّ اسْمٍ هُوَ لَكَ، سَمَّيْتَ بِهِ نَفْسَكَ، أَوْ أَنْزَلْتَهُ فِيْ كِتَابِكَ، أَوْ عَلَّمْتَهُ أَحَدًا مِنْ خَلْقِكَ، أَوِ اسْتَأْثَرْتَ بِهِ فِيْ عِلْمِ الْغَيْبِ عِنْدَكَ، أَنْ تَجْعَلَ الْقُرْآنَ رَبِيْعَ قَلْبِيْ، وَنُوْرَ صَدْرِيْ، وَجَلاَءَ حُزْنِيْ، وَذَهَابَ هَمِّيْ',
      transliteration: 'Allaahumma innii \'abduka, wabnu \'abdika, wabnu amatika, naashiyatii biyadika, maadhin fiyya hukmuka, \'adlun fiyya qodhoo-uka, as-aluka bikullismin huwa laka, sammaita bihi nafsaka, au anzaltahu fii kitaabika, au \'allamtahu ahadan min kholqika, awista\'tsarta bihi fii \'ilmil ghoibi \'indaka, an taj\'alal qur-aana robii\'a qolbii, wa nuuro shodrii, wa jalaa-a huznii, wa dzahaaba hammii.',
      translation: 'Ya Allah, sesungguhnya aku adalah hambaMu, anak hambaMu (Adam), dan anak hamba perempuanMu (Hawa), ubun-ubunku berada di tanganMu, hukumMu berlaku terhadap diriku, dan ketetapanMu adil pada diriku. Aku memohon kepadaMu dengan segala Nama yang menjadi milikMu, yang Engkau namai diriMu dengannya, atau yang Engkau turunkan di dalam kitabMu, atau yang Engkau ajarkan kepada seseorang dari makhlukMu, atau yang Engkau rahasiakan dalam ilmu ghaib yang ada di sisiMu, maka aku mohon dengan itu agar Engkau jadikan Al-Qur\'an sebagai penyejuk hatiku, cahaya bagi dadaku, pelipur kesedihanku, dan penghilang bagi kesusahanku.',
    ),
    DoaModel(
      title: 'Doa Memohon Kemudahan',
      arabic: 'اَللَّهُمَّ لاَ سَهْلَ إِلاَّ مَا جَعَلْتَهُ سَهْلاً، وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلاً',
      transliteration: 'Allahumma laa sahla illaa maa ja\'altahu sahlan, wa anta taj\'alul hazna idzaa syi\'ta sahlan.',
      translation: 'Ya Allah, tidak ada kemudahan kecuali apa yang Engkau jadikan mudah. Sedang yang susah bisa Engkau jadikan mudah, apabila Engkau menghendakinya.',
    ),
    DoaModel(
      title: 'Doa Nabi Yunus (Kesulitan)',
      arabic: 'لاَ إِلَـٰهَ إِلاَّ أَنْتَ سُبْحَانَكَ إِنِّيْ كُنْتُ مِنَ الظَّالِمِيْنَ',
      transliteration: 'Laa ilaaha illaa anta, subhaanaka, innii kuntu minazh-zhoolimiin.',
      translation: 'Tidak ada sesembahan yang berhak disembah kecuali Engkau. Maha Suci Engkau. Sesungguhnya aku termasuk orang-orang yang zalim.',
    ),
    DoaModel(
      title: 'Doa Memejamkan Mata Jenazah',
      arabic: 'اَللَّهُمَّ اغْفِرْ لِفُلاَنٍ (بِاسْمِهِ) وَارْفَعْ دَرَجَتَهُ فِي الْمَهْدِيِّيْنَ، وَاخْلُفْهُ فِيْ عَقِبِهِ فِي الْغَابِرِيْنَ، وَاغْفِرْ لَنَا وَلَهُ يَا رَبَّ الْعَالَمِيْنَ، وَافْسَحْ لَهُ فِيْ قَبْرِهِ وَنَوِّرْ لَهُ فِيْهِ',
      transliteration: 'Allaahummaghfir lifulaan (bismihi), warfa\' darojatahu fiil mahdiyyiin, wakhlufhu fii \'aqibihi fiil ghoobiriin, waghfir lanaa wa lahu, yaa robbal \'aalamiin, wafsah lahu fii qobrihi wa nawwir lahu fiihi.',
      translation: 'Ya Allah, ampunilah si Fulan (hendaklah menyebut namanya), angkatlah derajatnya bersama orang-orang yang mendapat petunjuk, berilah penggantinya bagi orang-orang yang ditinggalkan sesudahnya. Dan ampunilah kami dan dia, wahai Tuhan seru sekalian alam. Lebarkan kuburannya dan berilah penerangan di dalamnya.',
    ),
    DoaModel(
      title: 'Doa Belasungkawa (Ta\'ziyah)',
      arabic: 'إِنَّ لِلَّهِ مَا أَخَذَ، وَلَهُ مَا أَعْطَى وَكُلُّ شَيْءٍ عِنْدَهُ بِأَجَلٍ مُسَمًّى، فَلْتَصْبِرْ وَلْتَحْتَسِبْ',
      transliteration: 'Inna lillaahi maa akhodza, wa lahu maa a\'thoo wa kullu syai-in \'indahu bi-ajalin musamman, faltashbir wal tahtasib.',
      translation: 'Sesungguhnya hak Allah adalah mengambil sesuatu dan memberikan sesuatu. Segala sesuatu yang di sisi-Nya dibatasi dengan ajal yang ditentukan. Oleh karena itu, bersabarlah dan carilah ridha Allah.',
    ),
    DoaModel(
      title: 'Doa Memasukkan Jenazah Ke Liang Kubur',
      arabic: 'بِسْمِ اللَّهِ وَعَلَى سُنَّةِ رَسُوْلِ اللَّهِ',
      transliteration: 'Bismillaahi wa \'alaa sunnati rosuulillaah.',
      translation: 'Dengan nama Allah dan sesuai petunjuk Rasulullah.',
    ),
    DoaModel(
      title: 'Doa Setelah Jenazah Dimakamkan',
      arabic: 'اَللَّهُمَّ اغْفِرْ لَهُ اَللَّهُمَّ ثَبِّتْهُ',
      transliteration: 'Allaahummaghfir lahu, allaahumma tsabbit-hu.',
      translation: 'Ya Allah ampunilah dia, Ya Allah teguhkanlah dia (untuk menjawab pertanyaan malaikat).',
    ),
    DoaModel(
      title: 'Doa Ketika Sakit',
      arabic: 'بِسْمِ اللَّهِ (3×) أَعُوذُ بِاللَّهِ وَقُدْرَتِهِ مِنْ شَرِّ مَا أَجِدُ وَأُحَاذِرُ (7×)',
      transliteration: 'Bismillaah (3x). A\'uudzu billaahi wa qudrotihi min syarri maa ajidu wa uhaadzir (7x).',
      translation: 'Dengan nama Allah (3x). Aku berlindung kepada Allah dan kekuasaanNya, dari kejahatan sesuatu yang aku jumpai dan aku khawatirkan (7x).',
    ),
    DoaModel(
      title: 'Doa Nabi Ayyub (Sakit)',
      arabic: 'رَبِّ إِنِّي مَسَّنِيَ الضُّرُّ وَأَنْتَ أَرْحَمُ الرَّاحِمِينَ',
      transliteration: 'Robbi innii massaniyadh-dhurru wa anta arhamur-roohimiin',
      translation: 'Ya Allah, sesungguhnya aku telah ditimpa penyakit, dan Engkau adalah Tuhan Yang Maha Penyayang di antara semua penyayang.',
    ),
    DoaModel(
      title: 'Doa Kepada Orang Sakit',
      arabic: 'اَللَّهُمَّ رَبَّ النَّاسِ، أَذْهِبِ البَاسَ، اِشْفِ، أَنْتَ الشَّافِي، لاَ شِفَاءَ إِلاَّ شِفَاؤُكَ، شِفَاءً لاَ يُغَادِرُ سَقَمًا',
      transliteration: 'Allaahumma robban-naas, adz-hibil baas, isyfi, antasy-syaafii, laa syifaa-a illaa syifaa-uka, syifaa-an laa yughoodiru saqoman.',
      translation: 'Ya Allah, Tuhan seluruh manusia, hilangkanlah sakit ini, sembuhkanlah, Engkaulah As-Syafi (Sang Penyembuh), tidak ada kesembuhan kecuali kesembuhan dari-Mu, kesembuhan yang tidak meninggalkan penyakit.',
    ),
    DoaModel(
      title: 'Doa Sakit Tanpa Harapan Hidup',
      arabic: 'اَللَّهُمَّ اغْفِرْ لِيْ وَارْحَمْنِيْ وَأَلْحِقْنِيْ بِالرَّفِيْقِ اْلأَعْلَى',
      transliteration: 'Allaahummag-fir lii warhamnii wa alhiqnii bir-rofiiqil a\'laa.',
      translation: 'Ya Allah, ampuni aku, rahmati aku, dan kumpulkan aku bersama rekan-rekan yang berada di atas (malaikat).',
    ),
    DoaModel(
      title: 'Doa Setelah Shalat Dhuha',
      arabic: 'اَللَّهُمَّ اغْفِرْ لِي وَتُبْ عَلَيَّ، إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
      transliteration: 'Allaahummagh-fir lii wa tub \'alayya, innaka antat-tawwaabur-rohiim (100x).',
      translation: 'Ya Allah, ampunilah dosaku dan terimalah taubatku, sesungguhnya Engkau Maha Penerima Taubat lagi Maha Penyayang (100x).',
    ),
  ];

  static const List<TahlilModel> listTahlil = [
    TahlilModel(
      title: 'Hadiah Fatihah (Nabi Muhammad)',
      arabic: 'إِلَى حَضْرَةِ النَّبِيِّ الْمُصْطَفَى سَيِّدِنَا مُحمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ وَاٰلِهِ وَأَزْوَاجِهِ وَأَوْلَادِهِ وَذُرِّيَّاتِهِ الْفَــاتِحَةُ',
      transliteration: 'Ila ḫadlratin-nabiyyil-musthafâ sayyidinâ Muḫammadin shallallahu ‘alaihi wa sallama wa âlihi wa azwâjihi wa awlâdihi wa dzurriyyâtihi al-fâtiḫah',
      translation: 'Kepada yang terhormat Nabi Muhammad ﷺ, segenap keluarga, istri-istrinya, anak-anaknya, dan keturunannya. Bacaan Al-Fatihah ini kami tujukan kepada Allah dan pahalanya untuk mereka semua. Al-Fatihah…',
    ),
    TahlilModel(
      title: 'Hadiah Fatihah (Para Nabi, Wali, & Pendiri NU)',
      arabic: 'ثُمَّ إِلَى حَضْرَةِ إِخْوَانِهِ مِنَ الْأَنْبِيَاءِ وَالْمُرْسَلِيْنَ وَالْأَوْلِيَاءِ وَالشُّهَدَاءِ وَالصَّالِحِيْنَ وَالصَّحَابَةِ وَالتَّابِعِيْنَ وَالْعُلَمَاءِ الْعَامِلِيْنَ وَالْمُصَنِّفِيْنَ الْمُخْلِصِيْنَ وَجَمِيْعِ الْمَلَائِكَةِ الْمُقَرَّبِيْنَ، خُصُوْصًا إِلَى سَيِّدِنَا الشَّيْخِ عَبْدِ الْقَادِرِ الْجِيْلَانِي وَخُصُوْصًا إِلَى مُؤَسِّسِيْ جَمْعِيَّةِ نَهْضَةِ الْعُلَمَاءِ الْفَــاتِحَةُ',
      transliteration: 'Tsumma ilâ ḫadlrati ikhwânihi minal-anbiya’i wal-mursalîn wal-auliya’i wasy-syuhadâ’i wash-shâlihîn wash-shaḫâbati wat tâbi‘în wal-‘ulamâ’il-‘âmilîn wal-mushannifînal-mukhlishîn wa jamî‘il-malâikatil-muqarrabîn, khusûshan ilâ sayyidinâsy-syaikh ‘abdil qâdir al-jîlânî wa khushûshan ilâ muassisî jam‘iyyah Nahdlatil Ulama, al-fâtiḫah',
      translation: 'Lalu kepada segenap saudara beliau dari kalangan pada nabi, rasul, wali, syuhada, orang-orang saleh, sahabat, tabi‘in, ulama al-amilin (yang mengamalkan ilmunya), ulama penulis yang ikhlas, semua malaikat Muqarrabin, terkhusus kepada Syekh Abdul Qadir al-Jilani dan para pendiri organisasi Nahdlatul Ulama. Bacaan Al-Fatihah ini kami tujukan kepada Allah dan pahalanya untuk mereka semua. Al-Fatihah.',
    ),
    TahlilModel(
      title: 'Hadiah Fatihah (Ahli Kubur Umum)',
      arabic: 'ثُمَّ إِلَى جَمِيْعِ أَهْلِ الْقُبُوْرِ مِنَ الْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ مِنْ مَشَارِقِ الْأَرْضِ إِلَى مَغَارِبِهَا بَرِّهَا وَبَحْرِهَا خُصُوْصًا إِلَى اٰبَائِنَا وَأُمَّهَاتِنَا وَأَجْدَادِنَا وَجَدَّاتِنَا وَمَشَايِخِنَا وَمَشَايِخِ مَشَايِخِنَا وَأَسَاتِذَةِ أَسَاتِذَتِنَا وَلِمَنْ أَحْسَنَ إِلَيْنَا وَلِمَنِ اجْتَمَعْنَا هٰهُنَا بِسَبَبِهِ الْفَاتِحَةُ',
      transliteration: 'Tsumma ilâ jamî‘i ahlil-qubûri minal-muslimîna wal-muslimâti wal-mu’minîna wal-mu’minâti min masyâriqil-ardli ilâ maghâribihâ barrihâ wa baḫrihâ khushushan ilâ abâ’inâ wa ummahâtinâ wa ajdâdinâ wa jaddâtina wa masyâkhinâ wa masyâyikhi masyâyikhinâ wa asâtidzati asâtidzatinâ wa liman aḫsana ilainâ wa liman ijtama‘nâ hâhunâ bisababihi, al-fâtiḫah',
      translation: 'Kemudian kepada semua ahli kubur Muslimin, Muslimat, Mukminin, Mukminat dari Timur ke Barat, baik di laut dan di darat, khususnya bapak kami, ibu kami, kakek kami, nenek kami, guru kami, pengajar dari guru kami, mereka yang telah berbuat baik kepada kami, dan bagi ahli kubur/arwah yang menjadi sebab kami berkumpul di sini. Bacaan Al-Fatihah ini kami tujukan kepada Allah dan pahalanya untuk mereka semua. Al-Fatihah.',
    ),
    TahlilModel(
      title: 'Hadiah Fatihah (Arwah Khusus)',
      arabic: 'ثُمَّ إِلَى جَمِيْعِ أهْلِ الْقُبُوْرِ مِمَّنْ ذُكِرَتْ أَسْمَاؤُهُ فِيْ هٰذِهِ الرِّسَالَةِ حَضْرَةِ رُوْحِ … وَحَضْرَةِ رُوْحِ … وَحَضْرَةِ رُوْحِ … رَحِمَهُمُ اللهُ وَغَفَرَهُمْ، الْفَاتِحَةُ',
      transliteration: 'Tsumma ilâ jamî‘i ahlil-qubûri mimman dzukirot asmâ’uhu fi hâdzihir risâlati, ḫadlrati rûhi…, wa ḫadlrati rûhi…, wa ḫadlrati rûhi…, roḫimahumullâhu wa ghafarahum, al-fâtiḫah',
      translation: 'Kemudian kepada semua ahli kubur, yang namanya disebutkan dalam risalah ini. Kepada…, dan kepada…, dan kepada…. Semoga Allah merahmati dan mengampuni mereka. Bacaan Al-Fatihah ini kami tujukan kepada Allah dan pahalanya untuk mereka semua. Al-Fatihah.',
    ),
    TahlilModel(
      title: 'Surah Al-Ikhlas',
      arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ قُلْ هُوَ اللّٰهُ اَحَدٌۚ، اَللّٰهُ الصَّمَدُۚ، لَمْ يَلِدْ وَلَمْ يُوْلَدْۙ، وَلَمْ يَكُنْ لَّهٗ كُفُوًا اَحَـــــدٌ ×٣',
      transliteration: 'Bismillâhir-raḫmânir-raḫîm(i), Qul huwallâhu aḫad, Allâhush-shamad, lam yalid wa lam yûlad, wa lam yakul lahû kufuwan aḫad 3x',
      translation: 'Dengan menyebut nama Allah yang maha pengasih lagi maha penyayang. Katakanlah (Muhammad), “Dialah Allah, Yang Maha Esa. Allah tempat meminta segala sesuatu. (Allah) tidak beranak dan tidak pula diperanakkan. Dan tidak ada sesuatu yang setara dengan Dia.” (3 kali).',
    ),
    TahlilModel(
      title: 'Tahlil Pendek',
      arabic: 'لَا إِلٰهَ إِلَّا اللهُ وَاللهُ أَكْبَرُ',
      transliteration: 'Lâ ilâha illâllâhu wallâhu akbar',
      translation: 'Tiada tuhan yang layak disembah kecuali Allah. Allah maha besar.',
    ),
    TahlilModel(
      title: 'Surah Al-Falaq',
      arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ قُلْ اَعُوْذُ بِرَبِّ الْفَلَقِۙ، مِنْ شَرِّ مَـــا خَلَقَۙ، وَمِنْ شَرِّ غَاسِقٍ اِذَا وَقَبَۙ، وَمِنْ شَرِّ النَّفّٰثٰتِ فِى الْعُقَدِۙ، وَمِنْ شَرِّ حَاسِدٍ اِذَا حَسَدَ',
      transliteration: 'Bismillâhir-raḫmânir-raḫîm(i), Qul a‘udzu bi rabbil-falaq, min syarri mâ khalaq, wa min syarri ghâsiqin idzâ waqab, wa min syarrin-naffâtsâti fîl-‘uqad, wa min syarri ḫâsidin idzâ ḫasad',
      translation: 'Dengan menyebut nama Allah yang maha pengasih lagi maha penyayang. Katakanlah, “Aku berlindung kepada Tuhan yang menguasai subuh (fajar), dari kejahatan (makhluk yang) Dia ciptakan, dan dari kejahatan malam apabila telah gelap gulita, dan dari kejahatan (perempuan-perempuan) penyihir yang meniup pada buhul-buhul (talinya), dan dari kejahatan orang yang dengki apabila dia dengki.”',
    ),
    TahlilModel(
      title: 'Surah An-Nas',
      arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ قُلْ اَعُوْذُ بِرَبِّ النَّاسِۙ، مَلِكِ النَّـــاسِۙ، اِلٰهِ النَّاسِۙ، مِنْ شَرِّ الْوَسْوَاسِ ەۙ الْخَنَّاسِۖ، الَّذِيْ يُوَسْوِسُ فِيْ صُدُوْرِ النَّاسِۙ، مِنَ الْجِنَّةِ وَالنَّــاسِ',
      transliteration: 'Bismillâhir-raḫmânir-raḫîm(i), Qul a‘udzû bi rabbin-nâs, malikin-nâs, ilahin-nâs, min syarril-waswâsil khannâs, alladzi yuwaswisu fî shudûrin-nâs, minal-jinnati wan-nâs.',
      translation: 'Dengan menyebut nama Allah yang maha pengasih lagi maha penyayang. Katakanlah, “Aku berlindung kepada Tuhannya manusia, raja manusia, sembahan manusia, dari kejahatan (bisikan) setan yang bersembunyi, yang membisikkan (kejahatan) ke dalam dada manusia, dari (golongan) jin dan manusia.”',
    ),
    TahlilModel(
      title: 'Surah Al-Fatihah',
      arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ، اَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَۙ، الرَّحْمٰنِ الرَّحِيْمِۙ، مٰلِكِ يَوْمِ الدِّيْنِۗ، اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِيْنُۗ، اِهْدِنَا الصِّرَاطَ الْمُسْتَقِيْمَۙ، صِرَاطَ الَّذِيْنَ اَنْعَمْتَ عَلَيْهِمْ ەۙ غَيْرِ الْمَغْضُوْبِ عَلَيْهِمْ وَلَا الضَّاۤلِّيْنَ',
      transliteration: 'Bismillâhir-raḫmânir-raḫîm(i), al-ḫamdu lillâhi rabbil-‘âlamîn, Ar-raḫmânir-raḫîm, mâliki yaumid-dîn, iyyâka na‘budu wa iyyâka nasta‘în, ihdinâsh-shirâthal-mustaqîm, shirâtal ladzîna an‘amta ‘alaihim ghairil-maghdlûbi ‘alaihim wa lâdl-dlâllîn. Âmîn',
      translation: 'Dengan menyebut nama Allah yang maha pengasih lagi maha penyayang. Segala puji bagi Allah, Tuhan semesta alam. Yang maha pengasih lagi maha penyayang. Yang menguasai hari pembalasan. Hanya kepada-Mu kami menyembah. Hanya kepada-Mu pula kami memohon pertolongan. Tunjukkanlah kami ke jalan yang lurus, yaitu jalan orang-orang yang telah Kauanugerahi nikmat kepada mereka, bukan jalan mereka yang dimurkai dan bukan pula jalan mereka yang sesat. Semoga Kaukabulkan permohonan kami.',
    ),
    TahlilModel(
      title: 'Surah Al-Baqarah 1-5',
      arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ، الۤــــــمّۤۚ، ذٰلِكَ الْكِتٰبُ لَا رَيْبَۛ فِيْهِۛ هُدًى لِّلْمُتَّقِيْنَۙ، الَّذِيْنَ يُؤْمِنُوْنَ بِالْغَيْبِ وَيُقِيْمُوْنَ الصَّلٰوةَ وَمِمَّا رَزَقْنٰهُمْ يُنْفِقُوْنَۙ، وَالَّذِيْنَ يُؤْمِنُوْنَ بِمَآ اُنْزِلَ اِلَيْكَ وَمَآ اُنْزِلَ مِنْ قَبْلِكَ ۚ وَبِالْاٰخِرَةِ هُمْ يُوْقِنُوْنَۗ، اُولٰۤىِٕكَ عَلٰى هُدًى مِّنْ رَّبِّهِمْۙ وَاُولٰۤىِٕكَ هُمُ الْمُفْلِحُوْنَ',
      transliteration: 'Bismillâhir-rahmânir-rahîm(i), Alif Lâm Mîm, dzâlikal-kitâbu lâ raiba fîhi, hudal-lilmuttaqîn, al-ladzîna yu’minûna bil-ghaibi wa yuqîmûnash-shalâta wa mimmâ razaqnâhum yunfiqûn, wal-ladzîna yu’minûna bimâ unzila ilaika wa mâ unzila min qablika, wa bil-âkhirati hum yûqinûn, ulâ’ika ‘alâ hudam mir rabbihim wa ulâ’ika humul-mufliḫûn.',
      translation: 'Dengan menyebut nama Allah yang maha pengasih lagi maha penyayang. Alif lam mim. Demikian itu kitab ini tidak ada keraguan padanya. Sebagai petunjuk bagi mereka yang bertakwa. Yaitu mereka yang beriman kepada yang ghaib, yang mendirikan shalat, dan menafkahkan sebagian rezeki yang kami anugerahkan kepada mereka. Dan mereka yang beriman kepada kitab Al-Qur’an yang telah diturunkan kepadamu (Muhammad ﷺ) dan kitab-kitab yang telah diturunkan sebelumnya, serta mereka yakin akan adanya kehidupan akhirat. Mereka itulah yang tetap mendapat petunjuk dari tuhannya. Merekalah orang orang yang beruntung.',
    ),
    TahlilModel(
      title: 'Ayat Tauhid',
      arabic: 'وَإِلٰهُكُمْ إِلٰهٌ وَّاحِدٌ لَا إِلٰهَ إِلَّا هُوَ الرَّحْمٰنُ الرَّحِيمُ',
      transliteration: 'Wa ilâhukum ilâhuw wâḫidul lâ ilâha illa Huwar-raḫmânur-raḫîm.',
      translation: 'Dan Tuhan kalian adalah Tuhan yang maha esa. Tiada tuhan yang layak disembah kecuali Dia yang maha pengasih lagi maha penyayang.',
    ),
    TahlilModel(
      title: 'Ayat Kursi',
      arabic: 'اَللّٰهُ لَآ اِلٰهَ اِلَّا هُوَۚ اَلْحَيُّ الْقَيُّوْمُ ەۚ لَا تَأْخُذُهٗ سِنَةٌ وَّلَا نَوْمٌۗ لَهٗ مَا فِى السَّمٰوٰتِ وَمَا فِى الْاَرْضِۗ مَنْ ذَا الَّذِيْ يَشْفَعُ عِنْدَهٗٓ اِلَّا بِاِذْنِهٖۗ يَعْلَمُ مَا بَيْنَ اَيْدِيْهِمْ وَمَا خَلْفَهُمْۚ وَلَا يُحِيْطُوْنَ بِشَيْءٍ مِّنْ عِلْمِهٖٓ اِلَّا بِمَا شَاۤءَۚ وَسِعَ كُرْسِيُّهُ السَّمٰوٰتِ وَالْاَرْضَۚ وَلَا يَـُٔوْدُهٗ حِفْظُهُمَاۚ وَهُوَ الْعَلِيُّ الْعَظِيْمُ',
      transliteration: 'Allahu lâ ilâha illa huwal-ḫayyul-qayyûm(u). Lâ ta’khudzuhû sinatuw wa lâ naûm(u). Lahû mâ fis-samâwâti wa mâ fil-ardl. Man dzal ladzî yasyfa’u ‘indahû illâ bi idznih(i). Ya’lamu mâ baina aidîhim wa mâ khalfahum. Wa lâ yuḫithûna bi syai’in min ‘ilmihî illâ bimâ syâ’a wasi’a kursiyyuhus-samawâti wal-ardl. Wa lâ ya’ûduhu ḫifdhuhumâ wahuwal-‘aliyyul-adhîm.',
      translation: 'Allah, tiada yang layak disembah kecuali Dia yang hidup kekal lagi berdiri sendiri. Tidak mengantuk dan tidak tidur. Milik-Nya apa yang ada di langit dan di bumi. Tiada yang dapat memberikan syafaat di sisi-Nya kecuali dengan izin-Nya. Dia mengetahui apa yang ada di hadapan dan di belakang mereka. Mereka tidak mengetahui sesuatu dari ilmu-Nya kecuali apa yang dikehendaki-Nya. Kursi Allah meliputi langit dan bumi. Dia tidak merasa berat menjaga keduanya. Dia maha tinggi lagi maha agung.',
    ),
    TahlilModel(
      title: 'Istighfar',
      arabic: 'أَسْتَغْفِرُ اللهَ الْعَـــظِيْمَ ×٣',
      transliteration: 'Astaghfirullâhal-‘adhîm 3 x',
      translation: 'Saya mohon ampun kepada Allah yang maha agung (3 kali).',
    ),
    TahlilModel(
      title: 'Tahlil',
      arabic: 'لَا إِلٰهَ إِلَّا اللهُ ×١٠٠',
      transliteration: 'La ilâha illâllâh 100x',
      translation: 'Tiada tuhan selain Allah (100 kali).',
      note: 'Afdlaludz dzikri fa‘lam annahu lâ ilâha illallâhu ḫayyun maujûd(un)',
    ),
    TahlilModel(
      title: 'Shalawat',
      arabic: 'اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ اَللّٰهُمَّ صَلِّ عَلَيْهِ وَسَلِّمْ ×٢',
      transliteration: 'Allâhumma shalli ‘alâ sayyidinâ Muḫammadin, Allâhumma shalli ‘alaihi wa sallim',
      translation: 'Ya Allah, limpahkan rahmat takzim dan keselamatan kepada pemimpin kami, Nabi Muhammad (2 kali).',
    ),
    TahlilModel(
      title: 'Tasbih',
      arabic: 'سُبْحَــانَ اللهِ وَبِحَمْدِهِ سُبْحَانَ اللهِ الْعَظِيْمِ ×٣٣',
      transliteration: 'Subḫânallâhi wa biḫamdihi subḫânallâhil ‘adhîm',
      translation: 'Mahasuci Allah dengan segala pujian untuk-Nya. Mahasuci Allah yang Mahaagung (33 kali)',
    ),
    TahlilModel(
      title: 'Doa Tahlil (Pembuka)',
      arabic: 'أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ، بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ، الْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَ، حَمْدَ الشَّاكِرِيْنَ حَمْدَ النَّاعِمِيْنَ، حَمْدًا يُّوَافِي نِعَمَهُ وَيُكَافِئُ مَزِيْدَهُ، يَا رَبَّنَا لَكَ الْحَمْدُ كَمَا يَنْبَغِيْ لِجَلَالِ وَجْهِكَ وَعَظِيْمِ سُلْطَانِكَ، اللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ وَّعَلَى اٰلِ سَيِّدِنَا مُحِمَّدٍ',
      transliteration: 'A‘ûdzubillâhi minasy-syaithâr-rajîm, bismillâhir-raḫmânir-raḫîm, al-ḫamdulillâhi rabbil-‘alamîn, ḫamdasy syâkirin, ḫamdan nâ‘imîn, ḫamdan yuwâfî ni‘amahu wa yukâfî’u mazîdah(u), yâ rabbanâ lakal-ḫamdu kamâ yanbaghî lijalâli wajhika wa ‘adhîmi sulthânika, allâhumma shalli ‘alâ sayyidinâ Muḫammadin wa ‘alâ âli sayyidinâ Muḫammadin.',
      translation: 'Aku berlindung diri kepada Engkau dari setan yang di rajam. Dengan nama Allah yang Maha Pengasih lagi Maha Penyayang. Segala puji bagi Allah, Tuhan seru sekalian alam, sebagaimana orang-orang yang bersyukur dan orang yang memperoleh nikmat sama memuji, dengan pujian yang sesuai dengan nikmatnya dan memungkinkan di tambah nikmatnya. Tuhan kami, hanya Engkau segala puji, sebagaimana yang patut terhadap kemuliaan Engkau dan keagungan Engkau. Ya Allah tambahkanlah kesejahteraan dan keselamatan kepada penghulu kami Nabi Muhammad dan kepada keluarganya.',
    ),
    TahlilModel(
      title: 'Doa Tahlil (Inti)',
      arabic: 'اَللّٰهُمَّ تَقَبَّلْ وَأَوْصِلْ ثَوَابَ مَا قَرَاْنَاهُ مِنَ الْقُرْآنِ الْعَظِيْمِ وَمَا هَلَّلْنَا وَمَا سَبَّحْنَا وَمَا اسْتَغْفَرْنَا وَمَا صَلَّيْنَا عَلَى سَيِّدِنَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ هَدِيَّةً وَاصِلَةً وَرَحْمَةً نَازِلَةً وَبَرَكَةً شَامِلَةً إِلَى حَضَرَةِ حَبِيْبِنَا وَشَفِيْعِنَا وَقُرَّةِ أَعْيُنِنَا سَيِّدِنَا وَمَوْلَانَا مُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ، وَإِلَى جَمِيْعِ إِخْوَانِهِ مِنَ الْأَنْبِيَاءِ وَالْمرسَلِيْنَ وَالْأَوْلِيَاءِ وَالشُّهَدَاءِ وَالصَّالِحِيْنَ وَالصَّحَابَةِ وَالتَّابِعِيْنَ وَالْعُلَمَاءِ الْعَامِلِيْنَ وَالْمُصَنِّفِيْنَ الْمُخْلِصِيْنَ وَجَمِيْعِ الْمُجَاهِدِيْنَ فِي سَبِيْلِ اللهِ رَبِّ الْعَلَمِيْنَ وَالْمَلَائِكَةِ الْمُقَرَّبِيْن، خُصُوْصًا إِلَى سَيِّدِنَا الشَّيْخِ عَبْدِ الْقَادِرِ الْجِيْلَانِيّ، ثُمَّ إِلَى أَرْوَاحِ جَمِيْعِ أَهْلِ الْقُبُوْرِ مِنَ الْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ مِنْ مَشَارِقِ الْأَرْضِ وَمَغَارِبِهَا بَرِّهَا وَبَحْرِهَا خُصُوْصًا إِلَى آبَائِنَا وَاُمَّهَاتِنَا وَأَجْدَادِنَا وَجَدَّاتِنَا، وَنَخَصُّ خَصُوْصًا إِلَى مَنِ اجْتَمَعْنَا هٰهُنَا بِسَبَبِهِ وَلِأَجْلِهِ',
      transliteration: 'Allâhumma taqabbal wa aushil tsawâba mâ qara’nâhu minal-qur’anil-‘adhîmi wa mâ hallalnâ wamâ sabbaḫnâ wamâstaghfarnâ wamâ shallainâ ‘alâ sayyidinâ Muḫammadin shallallâhu ‘alaihi wa sallamâ hadiyyatan wâshilatan wa raḫmatan nâzilatan wa barakatan syâmilatan ilâ ḫadlrati ḫabîbinâ wa syafî‘nâ wa qurrati a‘yuninâ sayyidinâ wa maulana Muḫammadin shallallâhu ‘alaihi wa sallamâ, wa ilâ jamî‘i ikhwânihi minal-anbiyâ’i wal mursalîna wal-auliyâ’i wasy-syuhadâ’i wash-shaliḫina wash-shaḫâbati wat-tâbi‘înâ wal-‘ulamâ’il-‘âmilîna wal-mushannifînal-mukhlashîna wa jamî‘il-mujâhidînâ fî sabîlillâhi rabbil-‘âlamîna wal-malâ’ikatil-muqarrabînâ, khusûshan ilâ sayyidinâsy-Syaikhi Abdil Qâdir al-Jîlâni, tsumma ilâ arwâhi jami‘i ahlil-qubûri minal-muslimînâ wal-muslimâti wal-mu’minînâ wal-mu’minâti min masyâriqil-ardli wa maghâribihâ barrihâ wa baḫrihâ khusushan ilâ âbâ’inâ wa ummahâtinâ wa ajdâdinâ wa jaddâtinâ, wa nakhushshu khusûshan ilâ man ijtama‘nâ hahunâ bisababihi wa liajlihi.',
      translation: 'Ya Allah, terimalah dan sampaikanlah pahala ayat-ayat Quranul ‘adhim yang telah kami baca, tahlil kami, tasbih dan istighfar kami, dan bacaan shalawat kami kepada penghulu kami Nabi Muhammad dan kepada keluarganya. Sebagai hadiah yang bisa sampai, rahmat yang turun, dan berkah yang cukup kepada kekasih kami, penolong dan buah mata kami, penghulu dan pemimpin kami, yaitu Nabi Muhammad ﷺ, kepada semua temannya dari para Nabi dan para Utusan, kepada para wali, pahlawan yang gugur (Syuhada), orang-orang yang salih, para sahabat, dan tabi’in (para pengikutnya); kepada para ulama yang mengamalkan ilmunya, para pengarang yang ikhlas, kepada semua pejuang di jalan Allah (membela agama-Nya), Allah raja seru sekalian alam; dan kepada para Malaikat muqarrabin, terutama Syekh Abdul Qadir al-Jilani, kemudian kepada ahli kubur, muslim yang laki-laki dan yang perempuan, mukmin yang laki-laki dan yang perempuan, dari dunia timur dan barat di darat dan di laut, terutama lagi kepada bapak-bapak kami, ibu-ibu kami, nenek-nenek kami yang laki-laki dan yang perempuan, lebih terutama lagi kepada orang yang menyebabkan kami sekalian berkumpul di sini dan untuk keperluannya.',
    ),
    TahlilModel(
      title: 'Doa Tahlil (Penutup)',
      arabic: 'رَبَّنَا أَرِنَا الْحَقَّ حَقًّا وَّارْزُقْنَا اتِّبَاعَهُ، وَأَرِنَا الْبَاطِلَ بَاطِلًا وَّارْزُقْنَا اجْتِنَابَهُ، رَبَّنَا اٰتِنَا فِي الدُّنْيَا حَسَنَةً وَّفِي الْآخِرَةِ حَسَنَةً وَّقِنَا عَذَابَ النَّارِ، سُبْحَانَ رَبِّكَ رَبِّ الْعِزَّةِ عَمَّا يَصِفُوْنَ وَسَلَامٌ عَلَى الْمُرْسَلِيْنَ وَالْحَمْدُ لِلّٰهِ رَبِّ الْعَلَمِيْنَ، اَلْفَاتِحَة',
      transliteration: 'Rabbanâ arinâl-ḫaqqa ḫaqqan warzuqnât-tibâ‘ah, wa arinâl-bâthila bâthilan warzuqnâj tinâbah. Rabbanâ âtinâ fid-dunyâ ḫasanatan wa fil-âkhirati ḫasanatan wa qinâ ‘adzaban-nâr. Subḫâna rabbika rabbil-‘izzati ‘ammâ yashifun, wa salamun ‘alal-mursalîn, wal-ḫamdulillâhi rabbil-‘âlamîn. Al-fâtiḫah..',
      translation: 'Tuhan kami, tunjukkanlah kami kebenaran dengan jelas, jadikanlah kami pengikutnya, tunjukkanlah kami perkara batil dengan jelas, dan jadikanlah kami menjauhinya. Tuhan kami, berikanlah kami kebaikan di dunia dan kebaikan di akhirat, dan jagalah kami dari siksa api neraka, Maha Suci Tuhanku, tuhan yang bersih dari sifat yang di berikan oleh orang-orang kafir, semoga keselamatan tetap melimpahkan kepada para Utusannya dan segala puji bagi Allah Tuhan seru sekalian Alam. Al Fatihah.',
    ),
  ];
}
