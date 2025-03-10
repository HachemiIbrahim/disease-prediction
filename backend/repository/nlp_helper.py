import spacy
from fuzzywuzzy import process
from spacy.matcher import PhraseMatcher

# Load spaCy NLP model
nlp = spacy.load("en_core_web_sm")

# List of known symptoms
KNOWN_SYMPTOMS = [
    "headache",
    "vomiting",
    "burning abdominal pain",
    "nausea",
    "sharp chest pain",
    "sharp abdominal pain",
    "back pain",
    "cough",
    "weakness",
    "shortness of breath",
    "pelvic pain",
    "fever",
    "dizziness",
    "chest tightness",
    "sore throat",
    "leg pain",
    "problems with movement",
    "lower body pain",
    "lower abdominal pain",
    "arm pain",
    "joint pain",
    "nasal congestion",
    "chills",
    "side pain",
    "difficulty breathing",
    "foot or toe pain",
    "knee pain",
    "neck pain",
    "abnormal involuntary movements",
    "ache all over",
    "low back pain",
    "decreased appetite",
    "coryza",
    "skin rash",
    "diarrhea",
    "heartburn",
    "disturbance of memory",
    "vaginal discharge",
    "allergic reaction",
    "shoulder pain",
    "skin moles",
    "loss of sensation",
    "retention of urine",
    "fainting",
    "rectal bleeding",
    "constipation",
    "hip pain",
    "skin swelling",
    "abusing alcohol",
    "wheezing",
    "abnormal appearing skin",
    "vomiting blood",
    "difficulty in swallowing",
    "coughing up sputum",
    "leg weakness",
    "warts",
    "paresthesia",
    "problems during pregnancy",
    "intermenstrual bleeding",
    "hot flashes",
    "upper abdominal pain",
    "pus draining from ear",
    "blood in stool",
    "sneezing",
    "ear pain",
    "pain during pregnancy",
    "peripheral edema",
    "pain during intercourse",
    "skin growth",
    "hand or finger pain",
    "vaginal pain",
    "flu-like syndrome",
    "depressive or psychotic symptoms",
    "feeling ill",
    "arm weakness",
    "hurts to breath",
    "uterine contractions",
    "cramps and spasms",
    "suprapubic pain",
    "swollen eye",
    "facial pain",
    "depression",
    "groin pain",
    "infertility",
    "sleepiness",
    "insomnia",
    "irregular appearing scalp",
    "regurgitation.1",
    "skin irritation",
    "hemoptysis",
    "itchy scalp",
    "symptoms of the face",
    "itching of skin",
    "acne or pimples",
    "skin lesion",
    "temper problems",
    "fears and phobias",
    "elbow pain",
    "changes in stool appearance",
    "spotting or bleeding during pregnancy",
    "fatigue",
    "neck mass",
    "stomach bloating",
    "anxiety and nervousness",
    "ankle pain",
    "melena",
    "congestion in chest",
    "palpitations",
    "wrist pain",
    "pulling at ears",
    "difficulty speaking",
    "sinus congestion",
    "eye redness",
    "ankle swelling",
    "frontal headache",
    "painful urination",
    "wrist swelling",
    "eye burns or stings",
    "skin dryness, peeling, scaliness, or roughness",
    "fluid retention",
    "white discharge from eye",
    "leg swelling",
    "irregular heartbeat",
    "painful sinuses",
    "symptoms of the kidneys",
    "increased heart rate",
    "involuntary urination",
    "symptoms of eye",
    "sweating",
    "blood clots during menstrual periods",
    "seizures",
    "elbow swelling",
    "unpredictable menstruation",
    "heavy menstrual flow",
    "hand or finger swelling",
    "nosebleed",
    "knee swelling",
    "frequent menstruation",
    "drug abuse",
    "weight gain",
    "diminished vision",
    "arm swelling",
    "lacrimation",
    "bones are painful",
    "pain in eye",
    "double vision",
    "low self-esteem",
    "obsessions and compulsions",
    "painful menstruation",
    "mass on eyelid",
    "ringing in ear",
    "excessive urination at night",
    "restlessness",
    "fluid in ear",
    "swollen or red tonsils",
    "vaginal itching",
    "decreased heart rate",
    "hostile behavior",
    "abnormal breathing sounds",
    "pain of the anus",
    "symptoms of bladder",
    "delusions or hallucinations",
    "hip stiffness or tightness",
    "throat swelling",
    "hand or finger weakness",
    "infant feeding problem",
    "hand or finger lump or mass",
    "swelling of scrotum",
    "shoulder stiffness or tightness",
    "irregular appearing nails",
    "hesitancy",
    "irritable infant",
    "focal weakness",
    "jaundice",
    "foot or toe swelling",
    "long menstrual periods",
    "pain in testicles",
    "frequent urination",
    "excessive anger",
    "rib pain",
    "itchiness of eye",
    "gum pain",
    "redness in ear",
    "blood in urine",
    "arm stiffness or tightness",
    "knee stiffness or tightness",
    "breathing fast",
    "foreign body sensation in eye",
    "kidney mass",
    "burning chest pain",
    "mouth dryness",
    "symptoms of prostate",
    "plugged feeling in ear",
    "diminished hearing",
    "eyelid swelling",
    "spots or clouds in vision",
    "vaginal redness",
    "apnea",
    "jaw swelling",
    "pain in gums",
]

# Create PhraseMatcher for exact symptom detection
matcher = PhraseMatcher(nlp.vocab, attr="LOWER")
patterns = [nlp(symptom) for symptom in KNOWN_SYMPTOMS]
matcher.add("SYMPTOMS", patterns)

# Create a PhraseMatcher to detect known symptoms
matcher = PhraseMatcher(nlp.vocab, attr="LOWER")
patterns = [nlp(symptom) for symptom in KNOWN_SYMPTOMS]
matcher.add("SYMPTOMS", patterns)


def extract_symptoms(user_input):
    """
    Extract symptoms from user input using NLP phrase matching and fuzzy matching.
    """
    doc = nlp(user_input.lower())
    extracted_symptoms = set()

    # 1️⃣ **Exact Phrase Matching** (More Accurate)
    matches = matcher(doc)
    for match_id, start, end in matches:
        extracted_symptoms.add(doc[start:end].text)

    # 2️⃣ **Fuzzy Matching** (Handles Misspellings & Variations)
    noun_phrases = [chunk.text for chunk in doc.noun_chunks]  # Extract noun phrases
    for phrase in noun_phrases:
        fuzzy_matches = process.extract(
            phrase, KNOWN_SYMPTOMS, limit=3
        )  # Get top 3 matches
        for match, score in fuzzy_matches:
            if score > 90:  # Adjusted threshold for better recall
                extracted_symptoms.add(match)

    return list(extracted_symptoms)


# 🔍 **Test Case**
user_input = "I have a bad headache, fever and throat swelling."
print(extract_symptoms(user_input))
