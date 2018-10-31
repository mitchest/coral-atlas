# cairns cook geo
def to_num(name):
 if name == 'Shallow Lagoon':
  out = 1
 if name == 'Outer Reef Flat':
  out = 2
 if name == 'Inner Reef Flat':
  out = 3
 if name == 'Deep Slope 10 m + Windward':
  out = 4
 if name == 'Slope 3- 10 m Windward':
  out = 4
 if name == 'Slope 3- 10 m Leeward no lagoon':
  out = 4
 if name == 'Deep Slope 10 m + Leeward':
  out = 4
 if name == 'Reef Crest':
  out = 5
 if name == 'Open Comlex Lagoon':
  out = 6
 if name == 'Plateau 3-10 m':
  out = 7
 if name == 'Plateau 10 m +':
  out = 7
 if name == 'Deep Lagoon  (Not Reef Top)':
  out = 8
 return out

 #cap bunk geo
def to_num(name):
 if name == 'Back Reef slope 10-90d':
  out = 4
 if name == 'Crest Reef':
  out = 5
 if name == 'Deep Lagoon (0.75 - 20 m)':
  out = 8
 if name == 'Fore Reef slope 20-90d':
  out = 4
 if name == 'Inner Reef Flat':
  out = 3
 if name == 'Outer Reef Flat':
  out = 2
 if name == 'Plateau High Energey Deep':
  out = 7
 if name == 'Plateau Low Energey Deep':
  out = 7
 if name == 'Reef slope 20-90d Deep':
  out = 4
 if name == 'Shallow Lagoon (> 0.75 m)':
  out = 1
 return out
 
 #cairn cook benthic
def to_num(name):
 if name == 'B  Coral/Algae IRF':
  out = 1
 if name == 'B  Coral/Algae ORF':
  out = 1
 if name == 'B  Coral/Algae RC':
  out = 1
 if name == 'B Rock IRF':
  out = 2
 if name == 'B Rock ORF':
  out = 2
 if name == 'B Rock RC':
  out = 2
 if name == 'B Rock SL':
  out = 2
 if name == 'B Rubble IRF':
  out = 3
 if name == 'B Rubble ORF':
  out = 3
 if name == 'B Rubble RC':
  out = 3
 if name == 'B Rubble SL':
  out = 3
 if name == 'B Sand IRF':
  out = 4
 if name == 'B Sand ORF':
  out = 4
 if name == 'B Sand SL':
  out = 4
 if name == 'Deep Lagoon  (Not Reef Top)':
  out = 5
 if name == 'Deep Slope 10 m + Leeward':
  out = 6
 if name == 'Deep Slope 10 m + Windward':
  out = 6
 if name == 'Open Comlex Lagoon':
  out = 7
 if name == 'Plateau 10 m +':
  out = 8
 if name == 'Plateau 3-10 m':
  out = 8
 if name == 'Slope 3- 10 m Leeward no lagoon':
  out = 6
 if name == 'Slope 3- 10 m Windward':
  out = 6
 return out
 
 #cap bunk benthic
def to_num(name):
 if name == 'Algae Dominant':
  out = 1
 if name == 'Bommies with Sand':
  out = 1
 if name == 'Coral Dominant':
  out = 1
 if name == 'Coral Rock Dominant':
  out = 2
 if name == 'Mixed Coral Algae Rubble':
  out = 1
 if name == 'Plateau High Energey Deep':
  out = 8
 if name == 'Plateau Low Energey Deep':
  out = 8
 if name == 'Rubble Dominant':
  out = 3
 if name == 'Sand Dominant':
  out = 4
 if name == 'Slope (<10 m) hard substrate':
  out = 6
 if name == 'Slope (<10 m) sand':
  out = 6
 if name == 'Slope (>10 m)':
  out = 6
 return out
 


