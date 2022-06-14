class CheckBoxState {
  final String title;
  bool value;
 static const List<String> checkUpTitleList =[
    'Are  you currently pregnant, or is there a chance you may be pregnant ?',
    'Do you have any heart diseases ?',
    'Do you have any lung diseases ?',
    'Did you have any surgeries un the past 3 years ?',
    'Are you taking any routine medications ?',
  ];

  static const List<String> covidTitleList =[
    'Fatigue',
    'Headache',
    'Fever',
    'Dry cough',
    'Aches and pains',
    'Sore throat',
    'Loss of taste and smell',
    'A rash on skin',
    'Breath difficulty',
  ];

  static const List<String> illnessTitleList= [
    'Influenza',
    'RSV',
    'Rhinovirus',
    'Enterovirus',
    'Adenovirus',
    'Chlamydia pneumoniae',
    'Mycoplasma',
    'Parainfluenze',
    'Human Metapneumonvirus',
  ];

  CheckBoxState({
    required this.title,
    this.value = false,
  });
}
