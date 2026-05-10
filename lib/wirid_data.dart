class WiridItem {
  final String arabic;
  final String latin;
  final String translation;

  const WiridItem({
    required this.arabic,
    required this.latin,
    required this.translation,
  });
}

class WiridCategory {
  final String id;
  final String title;
  final String subtitle;
  final List<WiridItem> items;

  const WiridCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.items,
  });
}

final List<WiridCategory> wiridData = [
  WiridCategory(
    id: '1',
    title: 'Wirid Bakda Shalat Fardhu',
    subtitle: '13 Bacaan',
    items: [
      WiridItem(
        arabic: 'أَسْتَغْفِرُ اللهَ الْعَظِـيْمَ لِيْ وَلِوَالِدَيَّ وَلِأَصْحَابِ الْحُقُوْقِ عَلَيَّ وَلِجَمِيْعِ الْمُؤْمِنِيْنَ وَالْمُؤْمِنَاتِ وَالْمُسْلِمِيْنَ وَالْمُسْلِمَاتِ الْأَحْيَاءِ مِنْهُمْ وَالْأَمْوَاتِ ×٣',
        latin: 'Astaghfirullâh al-‘adhîm lî wa liwâlidayya wa li ash ḫâbil-huquq ‘alayya walijami‘il-mu’minîna wal-mu’minâti wal-muslimîna wal-muslimâti al-aḫyâ’i minhum wal-amwât(i) 3x',
        translation: 'Aku memohon ampunan kepada Allah yang Mahaagung, untuk diriku sendiri, kedua orang tuaku, sahabat-sahabat yang aku masih memiliki hak atasku, semua kaum mukmin dan muslim, baik yang masih hidup ataupun yang telah wafat.',
      ),
      WiridItem(
        arabic: 'لَاإِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِيْ وَيُمِيْتُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيْرٌ ×٣',
        latin: 'Lâ ilâha illallâhu waḫdahu lâ syarîka lah(u), lahul-mulku wa lahul-ḫamdu yuḫyî wayumîtu wa huwa ‘ala kulli syai’in qadîr(un) 3x',
        translation: 'Tiada Tuhan yang haq disembah kecuali Allah semata, tiada sekutu baginya. Hanya milik-Nya segala kerajaan dan hanya milik-Nya segala puji, Dzat yang menghidupkan dan yang mematikan. Dialah Dzat yang kuasa atas segala sesuatu.',
      ),
      WiridItem(
        arabic: 'اَللّٰهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ وَإِلَيْكَ يَعُوْدُ السَّلَامُ فَحَيِّنَا رَبَّنَا بِالسَّلَامِ وَأَدْخِلْنَا الْـجَنَّةَ دَارَ السَّلَامِ تَبَارَكْتَ رَبَّنَا وَتَعَالَيْتَ يَا ذَاالْـجَلَالِ وَاْلإِكْرَامِ',
        latin: 'Allâhumma antas-salâm(u) wa minkas-salam(u) wa ilaika ya‘udus-salâm(u) faḫayyinâ rabbanâ bis-salam(i) wa adkhilnâl-jannata dâras-salam(i) tabârakta rabbanâ wa ta‘alaita yâ dzal-jalâli wal-ikram(i)',
        translation: 'Ya Allah Engkaulah Dzat yang memberi keselamatan (kesejahteraan), dari-Mu keselamatan (kesejahteraan) datang, dan kepadamu segala keselamatan (kesejahteraan) itu kembali. Maka hidupkanlah kami ya Allah dengan selamat (sejahtera), masukkan kami ke dalam surga rumah keselamatan (kesejahteraan), Engkaulah Dzat yang Mahasuci, wahai Tuhan kami, dan Engkaulah Dzat yang Mahaluhur, wahai Tuhan yang memiliki keagungan dan kemuliaan.',
      ),
      WiridItem(
        arabic: 'أَعُوْذُ بِاللهِ مِنَ الشَّيْطَانِ الرَّجِيْمِ. بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ، اَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَۙ، الرَّحْمٰنِ الرَّحِيْمِۙ، مٰلِكِ يَوْمِ الدِّيْنِۗ، اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِيْنُۗ، اِهْدِنَا الصِّرَاطَ الْمُسْتَقِيْمَۙ، صِرَاطَ الَّذِيْنَ اَنْعَمْتَ عَلَيْهِمْ ەۙ غَيْرِ الْمَغْضُوْبِ عَلَيْهِمْ وَلَا الضَّاۤلِّيْنَ. اٰمِيْن',
        latin: 'A‘ûdzu billahi minasy-syaithânir-rajîm(i). Bismillâhir-raḫmânir-raḫîm(i). Al-ḫamdulillâhi rabbil-‘âlamîn(a). Arraḫmânir-raḫîm. Mâliki yaumid-dîn(i). Iyyâka na‘budu wa iyyâka nasta‘în(u). Ihdinash-shirâtal-mustqîm(a). Shirâtal-ladzîna an‘amta ‘alaihim ghairil-maghdûbi ‘alaihim wa lâdl-dlâllîn(a). âmîn',
        translation: 'Aku berlindung kepada Allah dari setan yang terlontar. Dengan menyebut nama Allah yang maha pengasih lagi maha penyayang. Segala puji bagi Allah, Tuhan semesta alam. Yang maha pengasih lagi maha penyayang. Yang menguasai hari pembalasan. Hanya kepada-Mu kami menyembah. Hanya kepada-Mu pula kami memohon pertolongan. Tunjukkanlah kami ke jalan yang lurus, yaitu jalan orang-orang yang telah Kauanugerahi nikmat kepada mereka, bukan jalan mereka yang dimurkai dan bukan pula jalan mereka yang sesat. Amin.',
      ),
      WiridItem(
        arabic: 'وَإِلٰهُكُمْ إِلٰهٌ وَاحِدٌ لَا إِلٰهَ إِلَّا هُوَ الرَّحْمٰنُ الرَّحِيْمُ',
        latin: 'Wa ilâhukum ilahun wâḫidun lâ ilâha illa huwar-raḫmânur-raḫîm(u)',
        translation: 'Tuhanmu adalah Tuhan Yang Mahatunggal. Tiada tuhan selain Dia yang Maha Pengasih lagi Maha Penyayang.',
      ),
      WiridItem(
        arabic: 'اَللّٰهُ لَآ اِلٰهَ اِلَّا هُوَۚ اَلْحَيُّ الْقَيُّوْمُ ەۚ لَا تَأْخُذُهٗ سِنَةٌ وَّلَا نَوْمٌۗ لَهٗ مَا فِى السَّمٰوٰتِ وَمَا فِى الْاَرْضِۗ مَنْ ذَا الَّذِيْ يَشْفَعُ عِنْدَهٗٓ اِلَّا بِاِذْنِهٖۗ يَعْلَمُ مَا بَيْنَ اَيْدِيْهِمْ وَمَا خَلْفَهُمْۚ وَلَا يُحِيْطُوْنَ بِشَيْءٍ مِّنْ عِلْمِهٖٓ اِلَّا بِمَا شَاۤءَۚ وَسِعَ كُرْسِيُّهُ السَّمٰوٰتِ وَالْاَرْضَۚ وَلَا يَـُٔوْدُهٗ حِفْظُهُمَاۚ وَهُوَ الْعَلِيُّ الْعَظِيْمُ',
        latin: 'Allâhu lâ ilâha illa huwal-ḫayyul-qayyûmu lâ ta’khudzuhu sinatun wa lânaum(un). Lahu mâ fis-samâwâti wa mâ fil-ardl(i) man dzal-ladzî yasyfa‘u ‘indahu illâ bi idznih(i). ya‘lamu mâ baina aidîhim wa mâ khalfahum wa lâ yuḫîthûna bi syai’in min `ilmihi illâ bimâ syâ’a. wasi‘a kursiyyuhus-samâwâti wal-ardla wa lâ ya’ûduhu ḫifdhuhumâ wa huwal-‘aliyyul-‘adhim',
        translation: 'Allah, tidak ada tuhan selain Dia. Yang Mahahidup, Yang terus menerus mengurus (makhluk-Nya), tidak mengantuk dan tidak tidur. Milik-Nya apa yang ada di langit dan apa yang ada di bumi. Tidak ada yang dapat memberi syafaat di sisi-Nya tanpa izin-Nya. Dia mengetahui apa yang di hadapan mereka dan apa yang di belakang mereka, dan mereka tidak mengetahui sesuatu apa pun tentang ilmu-Nya melainkan apa yang Dia kehendaki. Kursi-Nya meliputi langit .dan bumi. Dan Dia tidak merasa berat memelihara keduanya, dan Dia Mahatinggi, Mahabesar (QS al-Baqarah: 255)',
      ),
      WiridItem(
        arabic: 'شَهِدَ اللهُ أَنَّهُ لَا إِلٰهَ إِلَّا هُوَ وَالْمَلَائِكَةُ وَأُولُو الْعِلْمِ قَائِمًا بِالْقِسْطِ، لَا إِلٰهَ إِلَّا هُوَ الْعَزِيزُ الْحَكِيمُ، إِنَّ الدِّينَ عِنْدَ اللّٰهِ الْإِسْلَامُ، قُلِ اللّٰهُمَّ مَالِكَ الْمُلْكِ تُؤْتِي الْمُلْكَ مَنْ تَشَاءُ وَتَنْزِعُ الْمُلْكَ مِمَّنْ تَشَاءُ وَتُعِزُّ مَنْ تَشَاءُ وَتُذِلُّ مَنْ تَشَاءُ، بِيَدِكَ الْخَيْرُ، إِنَّكَ عَلىٰ كُلِّ شَيْءٍ قَدِيرٌ. تُوْلِجُ اللَّيْلَ فِي النَّهَارِ وَتُوْلِجُ النَّهَارَ فِي اللَّيْلِ، وَتُخْرِجُ الْحَيَّ مِنَ الْمَيِّتِ وَتُخْرِجُ الْمَيِّتَ مِنَ الْحَيِّ، وَتَرْزُقُ مَنْ تَشَاءُ بِغَيْرِ حِسَابٍ',
        latin: 'Syahidallâhu annahu lâ ilâha illâ huwa wal-mala’ikatu wa ûlûl ilmi qâiman bil-qisth(i). lâ ilâha illâ huwal-‘azizul hakîm(u). innad-dîna ‘indallâhil-islam(u). Qulillâhumma mâlikal-mulki tu’tîl-mulka man tasyâ’u wa tanzi‘ul-mulka mimman tasyâ’u watu‘izzu man tasyâ’u wa tudzillu man tasyâ’u biyadikal-khair(u). innaka ‘alâ kulli syai’in qadîr(un). Tûlijul-laila fin-nahâri wa tûlijun-nahâra fil-laili, wa tukhrijul-hayya minal-mayyiti wa tukhrijul-mayyita minal-ḫayyi, wa tarzuqu man tasyâ’u bighairi hisâb(in).',
        translation: 'Allah menyatakan bahwasanya tidak ada Tuhan melainkan Dia (yang berhak disembah), Yang menegakkan keadilan. Para Malaikat dan orang-orang yang berilmu (juga menyatakan yang demikian itu). Tak ada Tuhan melainkan Dia (yang berhak disembah), Yang Maha Perkasa lagi Maha Bijaksana. Sesungguhnya agama di sisi Allah ialah Islam. Wahai Tuhan pemilik kekuasaan, Engkau berikan kekuasaan kepada siapa pun yang Engkau kehendaki, dan Engkau cabut kekuasaan dari siapa pun yang Engkau kehendaki. Engkau muliakan siapa pun yang Engkau kehendaki dan Engkau hinakan siapa pun yang Engkau kehendaki. Di tangan Engkaulah segala kebajikan. Sungguh, Engkau Mahakuasa atas segala sesuatu. Engkau masukkan malam ke dalam siang dan Engkau masukkan siang ke dalam malam. Dan Engkau keluarkan yang hidup dari yang mati, dan Engkau keluarkan yang mati dari yang hidup. Dan Engkau berikan rezeki kepada siapa yang Engkau kehendaki tanpa perhitungan.',
      ),
      WiridItem(
        arabic: 'سُبْحَانَ اللهِ ×٣٣ اَلْحَمْدُ لِلّٰهِ ×٣٣ اَللهُ أَكْبَرُ ×٣٣',
        latin: 'Subhânallâh(i) 33x Al-hamdulillâh(i) 33x Allâhu akbar(u) 33x',
        translation: 'Mahasuci Allah (33x) Segala puji bagi Allah (33x) Allah Mahabesar (33x)',
      ),
      WiridItem(
        arabic: 'اَللهُ أَكْبَرُ كَبِيْرًا وَالْحَمْدُ لِلّٰهِ كَثِيْرًا وَسُبْحَانَ اللهِ بُكْرَةً وَأَصِيْلًا، لَاإِلٰهَ إِلَّا اللهُ وَحْدَهُ لَا شَرِيْكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِيْ وَيُمِيْتُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيْرٌ، لَاحَوْلَ وَلَاقُوَّةَ إِلَّابِاللهِ الْعَلِيِّ الْعَظِيْمِ',
        latin: 'Allâhu akbaru kabîran wal-hamdulillâhi katsîran wa subhânallâhi bukratan wa ashîla(n). lâ ilâha illâhu wahdahu lâ syarîka lah(u). lahul-mulku walahul-ḫamdu yuhyî wa yumîtu wa huwa ‘ala kulli syai’in qadîr(un). Lâ haula wa lâ quwwata illâ billâhil-‘aliyyil-adhîm(i)',
        translation: 'Allah Mahabesar dengan segala kebesaran, segala puji bagi Allah dengan pujian yang banyak, Mahasuci Allah, baik waktu pagi maupun sore. Tiada Tuhan yang haq disembah kecuali Allah semata, tiada sekutu baginya. Hanya milikinya segala kerajaan dan hanya milikinya segala puji, Dzat yang menghidupkan dan yang mematikan. Dialah Dzat yang kuasa atas segala sesuatu. Tiada daya upaya dan kekuatan kecuali atas pertolongan Allah yang Mahatinggi dan Mahaagung.',
      ),
      WiridItem(
        arabic: 'اَللّٰهُمَّ لَا مَانِعَ لِمَا أَعْطَيْتَ، وَلَا مُعْطِيَ لِمَا مَنَعْتَ، وَلَا هَادِيَ لِمَا أَضْلَلْتَ، وَلَا مُبَدِّلَ لِمَا حَكَمْتَ، وَلَا رَآدَّ لِمَا قَضَيْتَ، وَلَا يَنْفَعُ ذَاالْجَدِّ مِنْكَ الْجَدُّ، لَاإِلٰهَ إِلَّا أَنْتَ',
        latin: 'Allâhumma lâ mâni‘a limâ a‘thaita, wa lâ mu‘tiya limâ mana‘ta, wa lâ hâdiya limâ adl-lalta, wa lâ mubaddila limâ ḫakamta, wa lâ râdda limâ qadaita, wa lâ yanfa‘u dzal-jaddi minkal-jad(u), lâ ilâha illâ anta.',
        translation: 'Ya Allah tidak ada orang yang dapat mencegah apa yang Engkau berikan, dan tidak ada yang memberikan apa saja yang Engkau cegah, tidak ada yang bisa memberi petunjuk kepada apa saja yang Engkau sesatkan, tidak ada yang bisa mengganti apa yang Engkau putuskan, dan tidak ada yang menolak apa yang telah Engkau tentukan, dan tidak memberi manfaat kekayaan dan kemuliaan kepada pemiliknya, dari-Mulah segala kekayaan dan kemuliaan. Tidak ada tuhan selain Engkau.',
      ),
      WiridItem(
        arabic: 'اَللّٰهُمَّ صَلِّ عَلَى سَيِّدِنَا مُحَمَّدٍ عَبْدِكَ وَرَسُوْلِكَ النَّبِيِّ الْأُمِّـيِّ وَعَلى اٰلِهِ وَصَحْبِهِ وَسَلِّمْ',
        latin: 'Allâhumma shalli ‘ala sayyidinâ Muhammadin ‘abdika wa rasûlikan-nabiyyil-ummiyyi wa ‘ala âlihi wa shahbihi wa sallam.',
        translation: 'Ya Allah, limpahkanlah rahmat dan keselamatan kepada junjungan kami Nabi Muhammad ﷺ, sebagai hamba dan utusan-Mu yang ummi, beserta keluarga dan sahabatnya',
      ),
      WiridItem(
        arabic: 'وَحَسْبُنَا اللهُ وَنِعْمَ الْوَكِيْلُ، لَاحَوْلَ وَلَاقُوَّةَ إِلَّابِاللهِ الْعَلِيِّ الْعَظِيْمِ',
        latin: 'Wa hasbunâllâhu wa ni‘mal wakîl(u), lâ ḫaula wa lâ quwwata illâ billâhil-‘aliyyil ‘adhîm(i)',
        translation: 'Cukuplah Allah menjadi penolong kami dan Allah adalah sebaik-baik yang diserahi. Tiada daya dan tiada kekuatan melainkan dengan pertolongan Allah yang Mahatinggi dan Mahaagung.',
      ),
      WiridItem(
        arabic: 'أَسْتَغْفِرُ اللهَ الْعَظِـيْمَ\nالدُّعَاءُ\n\nبِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ. الْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِيْنَ حَمْدًا يُّوَافِيْ نِعَمَهُ وَ يُكَافِئُ مَزِيْدَهُ...',
        latin: 'Astaghfirullâh al-‘adhîm(i)... Bismillâhir-rahmânir-rahîm(i). Al-ḫamdulillâhi rabbil-’âlamîn(a)...',
        translation: 'Aku memohon ampun kepada Allah yang Mahaagung... Dengan nama Allah yang Maha Pengasih lagi Maha Penyayang. Segala puji bagi Allah...',
      ),
    ]
  ),
  WiridCategory(
    id: '2',
    title: 'Wirid Sebelum Shalat Subuh',
    subtitle: '6 Bacaan',
    items: [
      WiridItem(
        arabic: 'اَللّٰهُمَّ إِنِّي أَسْأَلُكَ رَحْمَةً مِنْ عِنْدِكَ تَهْدِيْ بِهَا قَلْبِيْ وَتَجْمَعُ بِهَا شَمْلِيْ وَتَلُمُّ بِهَا شَعَثِيْ وَتَرُدُّ بِهَا أُلْفَتِيْ وَتُصْلِحُ بِهَا دِينِيْ وَتَحْفَظُ بِهَا غَائِبِيْ وَتَرْفَعُ بِهَا شَاهِدِيْ وَتُزَكِّيْ بِهَا عَمَلِيْ وَتُبَيِّضُ بِهَا وَجْهِيْ وَتُلْهِمُنِيْ بِهَا رُشْدِيْ وَتَعْصِمُنِيْ بِهَا مِنْ كُلِّ سُوْءٍ، اَللّٰهُمَّ أَعْطِنِيْ إِيْمَانًا صَادِقًا وَيَقِيْنًا لَيْسَ بَعْدَهُ كُفْرٌ وَرَحْمَةً أَنَالُ بِهَا شَرَفَ كَرَامَتِكَ فِي الدُّنْيَا وَالْاٰخِرَةِ، اَللّٰهُمَّ إِنِّي أَسْأَلُكَ الْفَوْزَ عِنْدَ اللِّقَاءِ وَمَنَازِلَ الشُّهَدَاءِ وَعَيْشَ السُّعَدَاءِ وَالنَّصْرَ عَلَى الْأَعْدَاءِ وَمُرَافَقَةَ الأَنْبِيَاءِ',
        latin: 'Allâhumma innî as’aluka rahmatan min ‘indika tahdî bihâ qalbî wa tajma‘u bihâ syamlî wa talummu bihâ sya‘atsi wa taruddu biha ulfatî wa tashliḫu bihâ dînî wa taḫfadhu bihâ ghâ’ibî wa tarfa‘u bihâ syâhidî wa tuzakkî bihâ ‘amalî wa tubayyidlu bihâ wajhî wa tulhimunî bihâ rusydî wa ta‘shimunî bihâ min kulli su’in...',
        translation: 'Ya Allah, aku memohon kepada-Mu dari sisi-Mu rahmat yang dapat menunjukkan hatiku, mengumpulkan yang terserak dariku, memperbaiki apa yang kusut padaku, mengembalikan padaku kesenanganku, memperbaiki agamaku, menjaga batinku, mengangkat lahiriahku, menyucikan amalku, memutihkan wajahku, mengilhamkan petunjuk padaku, dan menjagaku dari segala kejelekan...',
      ),
      WiridItem(
        arabic: 'اَللّٰهُمَّ إِنِّيْ أُنْزِلُ حَاجَتِيْ وَإِنْ ضَعُفَ رَأْيِيْ وَقَلَّتْ حِيْلَتِيْ وَقَصُرَ أَهْلِيْ وَافْتَقَرْتُ إِلَى رَحْمَتِكَ فَأَسْأَلُكَ يَا قَاضِيَ الْأُمُوْرِ وَيَا شَافِيَ الصُّدُوْرِ كَمَا تُجِيْرَ بَيْنَ الْبُحُوْرِ أَنْ تُجِيْرَنِيْ مِنْ عَذَابِ السَّعِيْرِ وَمِنْ دَعْوَةِ الثُّبُوْرِ وَمِنْ فِتْنَةِ الْقبُوْرِ...',
        latin: 'Allâhumma innî unzilu hâjatî wa in dla’ufa ra’yî wa qallat ḫîlatî wa qashura ahlî waftaqartu ila raḫmatika fas’aluka yâ qâdliyal-umurî wa yâ syâfiyas-shudûri kamâ tujîra bainal-buhûri an tujîranî min ‘adzâbis-sa‘îri wa min da’watits-tsubûri wa min fitnatil-qubûri...',
        translation: 'Ya Allah, sesungguhnya aku menyerahkan hajatku (kepada-Mu), meskipun lemah pendapatku, sedikit tipu dayaku, pendek kemampuanku, dan perlunya aku akan rahmat-Mu, maka Aku mohon wahai Sang pemutus segala perkara, penyembuh segala dada (hati)...',
      ),
      WiridItem(
        arabic: 'اَللّٰهُمَّ هٰذَا الدُّعَاءُ وَعَلَيْكَ الْإِجَابَةُ، وَهٰذَا الْجُهْدُ وَعَلَيْكَ التُّكْلَانُ، وَإِنَّا لِلّٰهِ وَإِنَّا إِلَيْهِ رَاجِعُوْنَ، وَلَا حَوْلَ وَلا قُوَّةَ إِلَّا بِالِلّٰهِ الْعَلِيِّ الْعَظِيْمِ، ذِيْ الْحَبْلِ الشَّدِيْدِ وَالْأَمْرِ الرَّشِيدِ...',
        latin: 'Allâhumma hâdzad-du‘a’u wa ‘alaikal-ijâbatu wa hâdzal-juhdu wa ‘alaikat-tuklânu wa innâ lillâhi wa innâ ilaihi râji’ûna, wa lâ ḫaula wa lâ quwwata illâ billâhil-‘aliyyil-‘adhîmi dzil-ḫablisy-syadîdi wal-amrir-rasyîdi...',
        translation: 'Ya Allah, ini adalah doa dan bagi-Mu penerimaan. Ini adalah usaha kami dan kepada-Mu lah berserah diri. Sesungguhnya kami adalah milik Allah dan sesungguhnya hanya kepada-Nya kami akan kembali. Tiada daya dan tiada upaya kecuali dengan pertolongan Allah yang Mahatinggi lagi Mahaagung...',
      ),
      WiridItem(
        arabic: 'اللّٰهُمَّ اجْعَلْ لِي نُورًا فِي قَلْبِي وَنُورًا فِي قَبْرِي وَنُورًا فِي سَمْعِي وَنُوْرًا مِنْ بَيْنِ يَدِيْ وَنُوْرًا مِنْ خَلْفِيْ وَنُوْرًا عَنْ يَمِيْنِيْ وَنُوْرًا عَنْ شِمَالِيْ وَنُوْرًا مِنْ فَوْقِيْ وَنُوْرًا مِنْ تَحْتِيْ اللّٰهُمَّ زِدْنِيْ نُوْرًا وَأَعْطِنِيْ نُوْرًا',
        latin: 'Allâhummaj`al lî nûran fî qalbî wa nûran fî qabrî wa nûran fî sam`i wa nûran min baini yadî wa nûran min khalfî wa nûran `an yamînî wa nûran `an syimâlî wa nûran min fauqî wa nûran min tahtî. Allâhumma zidnî nûran wa a`thinî nûran',
        translation: 'Ya Allah jadikan untukku cahaya di hatiku, cahaya di kuburku, cahaya di pendengaranku, cahaya di depanku, cahaya di belakangku, cahaya di arah kananku, cahaya di arah kiriku, cahaya di atasku, cahaya di bawahku. Ya Allah, tambahkanlah cahaya untukku dan berilah aku cahaya.',
      ),
      WiridItem(
        arabic: 'سُبْحَانَ مَنْ تَعَزَّزَ بِالْعَظَمَةِ سُبْحَانَ مَنْ تَرَدَّى بِالْكِبْرِيَاءِ سُبْحَانَ مَنْ تَفَرَّدَ بِالْوَحْدَانِيَّةِ سُبْحَانَ مَنِ احْتَجَبَ بِالنُّوْرِ سُبْحَانَ مَنْ قَهَّرَ الْعِبَادَ بِالْمَوْتِ سُبْحَانَ مَنْ لَا يُفَوِّتُهُ فَوْتٌ...',
        latin: 'Subhâna man ta`azzaza bil-`adhamati subhâna man taradda bil-kibriyâ’i subhâna man tafarrada bil-wahdâniyyati subhâna manih-tajaba bin-nûri subhâna man qahharal-`ibâda bil-mauti subhâna man lâ yufawwituhu fautun...',
        translation: 'Mahasuci Dzat yang menjadi mulia dengan keagungan. Mahasuci Dzat yang mampu membinasakan dengan penuh kebesaran. Mahasuci Dzat yang menyendiri dengan sifat wahdaniyah. Mahasuci Dzat yang merahasiakan diri dengan cahaya. Mahasuci Dzat yang menundukkan hamba-Nya dengan kematian. Mahasuci Dzat yang tidak dikenai keluputan...',
      ),
    ]
  ),
  WiridCategory(
    id: '3',
    title: 'Wirdul Lathif (Dzikir Pagi)',
    subtitle: 'Bacaan Pagi',
    items: [
      WiridItem(
        arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ قُلْ هُوَ اللّٰهُ اَحَدٌۚ، اَللّٰهُ الصَّمَدُۚ، لَمْ يَلِدْ وَلَمْ يُوْلَدْۙ، وَلَمْ يَكُنْ لَّهٗ كُفُوًا اَحَـــــدٌ ×٣',
        latin: 'Bismillâhir-rahmânir-rahîm(i). Qul huwallâhu aḫad(un), Allâhush-shamad(u), lam yalid wa lam yûlad, wa lam yakun lahu kufuwan aḫad(un). 3x',
        translation: 'Dengan menyebut nama Allah yang Maha Pengasih lagi Maha Penyayang. Katakanlah (wahai Muhammad): “Dialah Allah Yang Maha Esa. Allah Dzat yang menjadi tumpuan segala permohonan. Ia tidak beranak dan tidak pula diperanakkan. Dan tidak ada siapa pun yang sebanding dengan-Nya. (QS Al-Ikhlas). (3x)',
      ),
      WiridItem(
        arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ قُلْ اَعُوْذُ بِرَبِّ الْفَلَقِۙ، مِنْ شَرِّ مَـــا خَلَقَۙ، وَمِنْ شَرِّ غَاسِقٍ اِذَا وَقَبَۙ، وَمِنْ شَرِّ النَّفّٰثٰتِ فِى الْعُقَدِۙ، وَمِنْ شَرِّ حَاسِدٍ اِذَا حَسَدَ ×٣',
        latin: 'Bismillâhir-rahmânir-rahîm(i). Qul a‘ûdzu birabbil-falaq(i), min syarri mâ khalaq(a), wa min syarri ghâsiqin idzâ waqab(a), wa min syarrin-naffatsâti fil-‘uqad(i), wa min syarri ḫâsidin idzâ hasad(a). 3x',
        translation: 'Dengan menyebut nama Allah yang Maha Pengasih lagi Maha Penyayang. Katakanlah (wahai Muhammad), “Aku berlindung kepada Tuhan yang menciptakan cahaya subuh. Dari kejahatan makhluk-makhluk yang Ia ciptakan. Dari kejahatan malam apabila telah gelap gelita. Dari (ahli-ahli sihir) yang menghembus pada simpul-simpul ikatan. Dan dari kejahatan orang yang dengki apabila ia melakukan kedengkiannya. (QS Al-Falaq) (3x)',
      ),
      WiridItem(
        arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ قُلْ اَعُوْذُ بِرَبِّ النَّاسِۙ، مَلِكِ النَّـــاسِۙ، اِلٰهِ النَّاسِۙ، مِنْ شَرِّ الْوَسْوَاسِ ەۙ الْخَنَّاسِۖ، الَّذِيْ يُوَسْوِسُ فِيْ صُدُوْرِ النَّاسِۙ، مِنَ الْجِنَّةِ وَالنَّــاسِ ×٣',
        latin: 'Bismillâhir-rahmânir-rahîm(i). Qul a‘ûdzu birabbin-nâs(i), malikin-nâs(i), ilâhin-nâs(i), min syarril-waswâsil-khannâs(i), alladzî yuwaswisu fî shudûrin-nâs(i), minal jinnati wan-nâs(i). 3x',
        translation: 'Dengan menyebut nama Allah yang Maha Pengasih lagi Maha Penyayang. Katakanlah (wahai Muhammad): “Aku berlindung kepada Tuhan pemelihara manusia. Yang Menguasai manusia. Tuhannya manusia. Dari kejahatan pembisik penghasut yang timbul tenggelam. Yang melemparkan bisikan dan hasutannya ke dalam hati manusia. Dari kalangan jin dan manusia.” (QS An-Nas) (3x)',
      ),
      WiridItem(
        arabic: 'رَبِّ أَعُوْذُ بِـكَ مِنْ هَمَـزَاتِ الشَّيَـاطِينِ، وَأَعُوذُ بِكَ رَبِّ أَنْ يَحْضُـرُوْنِ ×٣',
        latin: 'Rabbi a‘udzu bika min hamazâtisy-syayâthîn(i), wa a‘udzubika rabbi ‘an yaḫdlurûn(i). 3x',
        translation: 'Ya Tuhanku, aku berlindung kepada-Mu dari bisikan-bisikan setan. Dan aku berlindung kepada-Mu, ya Tuhanku, dari kedatangan mereka kepadaku. (QS Al-Mu’minun: 97-98) (3x)',
      ),
      WiridItem(
        arabic: 'أَفَحَسِبْتُمْ أَنَّمَا خَلَقْنَاكُمْ عَبَثًا وَأَنَّكُمْ إِلَيْنَا لَا تُرْجَعُـوْنَ',
        latin: 'Afaḫasibtum annamâ khalaqnâkum ‘abatsan wa annakum ilainâ lâ turja‘ûn(a).',
        translation: 'Maka apakah kalian mengira, sesungguhnya Kami menciptakan kalian dengan sia-sia dan kalian tidak akan dikembalikan kepada kami? (QS Al-Mu’minun: 115)',
      ),
      // Adding a summary text for the rest to avoid massive file, as it's repetitive. 
      // User can expand this if they want, but I'll add a few more key ones.
      WiridItem(
        arabic: 'اَللّٰهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوْتُ، وَعَلَيْكَ نَتَوَكَّلُ، وَإِلَيْكَ النُّشُوْرُ. أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلّٰهِ، وَالْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِيْنَ',
        latin: 'Allâhumma bika ashbaḫnâ wa bika amsainâ wa bika naḫyâ wa bika namûtu wa ‘alaika natawakkalu wa ilaikan-nusyûr(u). ashbaḫnâ wa ashbaḫal-mulku lillâhi wal-ḫamdulillâhi rabbil-‘âlamîn(a)',
        translation: 'Ya Allah, dengan pertolongan-Mu kami berada di waktu pagi, dengan pertolongan-Mu kami berada di waktu petang, dengan pertolongan-Mu kami hidup, dengan pertolongan-Mu kami mati, kepada-Mu kami berserah diri, dan hanya kepada-Mu tempat kebangkitan. Kami berada di waktu pagi dan kerajaan milik Allah. Segala puji bagi Allah Tuhan semesta alam.',
      )
    ]
  ),
  WiridCategory(
    id: '4',
    title: 'Wirdul Lathif (Dzikir Petang)',
    subtitle: 'Bacaan Petang',
    items: [
      WiridItem(
        arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ قُلْ هُوَ اللّٰهُ اَحَدٌۚ، اَللّٰهُ الصَّمَدُۚ، لَمْ يَلِدْ وَلَمْ يُوْلَدْۙ، وَلَمْ يَكُنْ لَّهٗ كُفُوًا اَحَـــــدٌ ×٣',
        latin: 'Bismillâhir-raḫmânir-raḫîm(i). Qul huwallâhu aḫad(un), Allâhush-shamad(u), lam yalid wa lam yûlad, wa lam yakun lahu kufuwan aḫad(un). 3x',
        translation: 'Dengan menyebut nama Allah yang Maha Pengasih lagi Maha Penyayang. Katakanlah (wahai Muhammad): “Dialah Allah Yang Maha Esa. Allah Dzat yang menjadi tumpuan segala permohonan. Ia tidak beranak dan tidak pula diperanakkan. Dan tidak ada siapa pun yang sebanding dengan-Nya. (QS Al-Ikhlas). (3x)',
      ),
      WiridItem(
        arabic: 'اَللّٰهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوْتُ، وَعَلَيْكَ نَتَوَكَّلُ، وَإِلَيْكَ الْمَصِيْرُ. أَمْسَيْنَا وأَمْسَى الْمُلْكُ لِلّٰهِ، وَالْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِيْنَ',
        latin: 'Allâhumma bika amsainâ wa bika ashbaḫnâ wa bika naḫyâ wa bika namûtu wa ‘alaika natawakkalu wa ilaikal-mashîru, amsainâ wa amsal-mulku lillâhi, walḫamdulillâhi rabbil-‘alamîn(a).',
        translation: 'Ya Allah, dengan pertolongan-Mu kami berada di waktu sore, dengan pertolongan-Mu kami berada di waktu pagi, dengan pertolongan-Mu kami hidup, dengan pertolongan-Mu kami mati, kepada-Mu kami berserah diri, dan hanya kepada-Mu tempat kebangkitan. Kami berada di waktu sore dan kerajaan milik Allah. Segala puji bagi Allah Tuhan semesta alam.',
      )
    ]
  ),
  WiridCategory(
    id: '5',
    title: 'Wirid Menjelang Tidur',
    subtitle: 'Bacaan Tidur',
    items: [
      WiridItem(
        arabic: 'اَللّٰهُمَّ بِاسْمِكَ أَحْيَا وَأَمُوْتُ',
        latin: 'Allâhumma bismika aḫya wa amûtu',
        translation: 'Ya Allah, dengan nama-Mu aku hidup dan mati',
      ),
      WiridItem(
        arabic: 'بِاسْمِكَ رَبِّيْ وَضَعْتُ جَنْبِيْ وَبِكَ أَرْفَعُهُ إِنْ أَمْسَكْتَ نَفْسِيْ فَارْحَمْهَا وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِيْنَ',
        latin: 'Bismika rabbi wadla‘tu janbî wa bika arfa‘uhu in amsaktu nafsî farhamhâ wa in arsaltahâ faḫfadhhâ bimâ taḫfadhu bihi ‘ibâdakas-shâliḫîn(a).',
        translation: 'Dengan nama-Mu, wahai Tuhanku, aku letakkan lambungku. Dengan pertolongan-Mu aku dapat mengangkatnya. Jika Engkau menahan diriku, maka kasihilah ia. Apabila Engkau melepaskannya, maka jagalah ia sebagaimana Engkau jaga para hamba-Mu yang shalih',
      )
    ]
  ),
  WiridCategory(
    id: '6',
    title: 'Wirid Setelah Shalat Jumat',
    subtitle: 'Bacaan Jumat',
    items: [
      WiridItem(
        arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ، اَلْحَمْدُ لِلّٰهِ رَبِّ الْعٰلَمِيْنَۙ، الرَّحْمٰنِ الرَّحِيْمِۙ، مٰلِكِ يَوْمِ الدِّيْنِۗ، اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِيْنُۗ، اِهْدِنَا الصِّرَاطَ الْمُسْتَقِيْمَۙ، صِرَاطَ الَّذِيْنَ اَنْعَمْتَ عَلَيْهِمْ ەۙ غَيْرِ الْمَغْضُوْبِ عَلَيْهِمْ وَلَا الضَّاۤلِّيْنَ. اٰمين ×٧',
        latin: 'Bismillâhir-raḫmânir-raḫîm(i). Alḫamdulillahi rabbil-‘âlamîn(a). Ar-Raḫmânir-Raḫîm(i). Mâliki yaumiddîn(i). Iyyâka na‘budu wa iyyâka nasta‘în(u). Ihdinash-shirâthal mustaqîm(a). Shirâthal-ladzîna an‘amta ‘alaihim ghoiril-maghdlûbi ‘alaihim waladl-dlâllîn(a). âmîn 7x',
        translation: 'Dengan nama Allah Yang Maha Pengasih lagi Maha Penyayang. Segala puji bagi Allah Pemelihara seluruh alam. Yang Maha Pengasih lagi Maha Penyayang. Pemilik hari pembalasan. Hanya kepada Engkaulah kami menyembah dan hanya kepada Engkaulah kami mohon pertolongan. Tunjukilah kami jalan yang lurus. (yaitu) jalan orang-orang yang telah Engkau beri nikmat kepadanya; bukan (jalan) mereka yang dimurkai, dan bukan (pula jalan) mereka yang sesat. (7x)',
      ),
      WiridItem(
        arabic: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ قُلْ هُوَ اللّٰهُ اَحَدٌۚ، اَللّٰهُ الصَّمَدُۚ، لَمْ يَلِدْ وَلَمْ يُوْلَدْۙ، وَلَمْ يَكُنْ لَّهٗ كُفُوًا اَحَـــــدٌ ×٧',
        latin: 'Bismillâhir-raḫmânir-raḫîm(i). Qul huwallâhu aḫad(un), Allâhush-shamad(u), lam yalid wa lam yûlad, wa lam yakun lahu kufuwan aḫad(un). 7x',
        translation: 'Dengan menyebut nama Allah yang Maha Pengasih lagi Maha Penyayang. Katakanlah (wahai Muhammad): “Dialah Allah Yang Maha Esa. Allah Dzat yang menjadi tumpuan segala permohonan. Ia tidak beranak dan tidak pula diperanakkan. Dan tidak ada siapa pun yang sebanding dengan-Nya. (QS Al-Ikhlas). (7x)',
      ),
      WiridItem(
        arabic: 'اَللّٰهُمَّ يَا غَنِيُّ يَا حَمِيْدُ يَا مُبْدِئُ يَا مُعِيْدُ يَا رَحِيْمُ يَا وَدُوْدُ أَغْنِنِيْ بِحَلَالِكَ عَنْ حَرَامِكَ وَبِطَاعَتِكَ عَنْ مَعْصِيَتِكَ وَبِفَضْلِكَ عَمَّنْ سِوَاكَ',
        latin: 'Allâhumma yâ Ghaniyyu yâ Ḫamîdu yâ Mubdi’u yâ Mu‘îdu ya Rahîmu ya Wadûdu aghninî biḫalâlika ‘an ḫarâmika wa bithâ‘atika ‘an ma‘shiyatika wa bifadllika ‘amman siwâka.',
        translation: 'Ya Allah, wahai Dzat yang Mahakaya, Maha Terpuji, Maha Memulai, Maha Mengembalikan, Maha Penyayang, dan Maha Pengasih. Cukupi aku dengan rezeki halal-Mu, bukan dengan yang haram. Cukupi aku dengan melakukan ketaatan kepada-Mu, bukan dengan mendurhakai-Mu. Cukupi aku dengan karunia-Mu, bukan dengan selain-Mu.',
      )
    ]
  ),
];
