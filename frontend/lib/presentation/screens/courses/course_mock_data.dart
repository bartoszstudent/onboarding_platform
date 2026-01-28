final List<Map<String, dynamic>> mockCourses = [
  {
    "id": 1,
    "title": "Wprowadzenie do firmy",
    "description": "Dowiedz się, jak działa nasza organizacja.",
    "thumbnail": "https://picsum.photos/400/200?1",
    "sections": [
      {
        "title": "Powitanie",
        "content": [
          {"type": "text", "data": "Witaj w firmie Onboardly!"},
          {"type": "image", "data": "https://picsum.photos/600/300?welcome"},
          {
            "type": "quiz",
            "data": {
              "question": "Jak się nazywa firma?",
              "answers": ["Onboardly", "Offboardly", "Boardly", "Onboard Plus"],
              "correct": 0
            }
          }
        ]
      }
    ]
  },
  {
    "id": 2,
    "title": "Bezpieczeństwo w pracy",
    "description": "Poznaj zasady bezpieczeństwa i higieny pracy.",
    "thumbnail": "https://picsum.photos/400/200?2",
    "sections": [
      {
        "title": "Zasady bezpieczeństwa",
        "content": [
          {
            "type": "text",
            "data": "Oto główne zasady bezpieczeństwa w naszej firmie..."
          },
          {
            "type": "quiz",
            "data": {
              "question": "Ile czasu powinno się myć ręce?",
              "answers": ["10 sekund", "20 sekund", "30 sekund", "1 minuta"],
              "correct": 1
            }
          }
        ]
      }
    ]
  }
];
