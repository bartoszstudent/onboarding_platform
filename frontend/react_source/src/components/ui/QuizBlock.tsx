import { useState } from 'react';
import { CheckCircle, XCircle } from 'lucide-react';

interface QuizBlockProps {
  question: string;
  answers: string[];
  correctAnswer: number;
}

export function QuizBlock({ question, answers, correctAnswer }: QuizBlockProps) {
  const [selectedAnswer, setSelectedAnswer] = useState<number | null>(null);
  const [submitted, setSubmitted] = useState(false);

  const handleSubmit = () => {
    if (selectedAnswer !== null) {
      setSubmitted(true);
    }
  };

  const isCorrect = selectedAnswer === correctAnswer;

  return (
    <div className="bg-[#F8FAFC] rounded-2xl p-6 border border-gray-200">
      <h4 className="text-[#0F172A] mb-4">{question}</h4>

      <div className="space-y-3 mb-6">
        {answers.map((answer, index) => {
          const isSelected = selectedAnswer === index;
          const showFeedback = submitted && isSelected;
          
          return (
            <button
              key={index}
              onClick={() => !submitted && setSelectedAnswer(index)}
              disabled={submitted}
              className={`w-full text-left p-4 rounded-xl border-2 transition-all ${
                !submitted
                  ? isSelected
                    ? 'border-[#2563EB] bg-blue-50'
                    : 'border-gray-300 bg-white hover:border-[#2563EB]/50'
                  : showFeedback
                  ? isCorrect
                    ? 'border-green-500 bg-green-50'
                    : 'border-red-500 bg-red-50'
                  : 'border-gray-300 bg-white opacity-50'
              } ${submitted ? 'cursor-not-allowed' : 'cursor-pointer'}`}
            >
              <div className="flex items-center gap-3">
                <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center ${
                  !submitted
                    ? isSelected
                      ? 'border-[#2563EB] bg-[#2563EB]'
                      : 'border-gray-300'
                    : showFeedback
                    ? isCorrect
                      ? 'border-green-500 bg-green-500'
                      : 'border-red-500 bg-red-500'
                    : 'border-gray-300'
                }`}>
                  {isSelected && (
                    <div className="w-2 h-2 bg-white rounded-full" />
                  )}
                </div>
                <span className="flex-1 text-[#0F172A]">{answer}</span>
                {showFeedback && (
                  isCorrect ? (
                    <CheckCircle className="w-5 h-5 text-green-600" />
                  ) : (
                    <XCircle className="w-5 h-5 text-red-600" />
                  )
                )}
              </div>
            </button>
          );
        })}
      </div>

      {!submitted ? (
        <button
          onClick={handleSubmit}
          disabled={selectedAnswer === null}
          className="w-full bg-[#2563EB] text-white py-3 rounded-xl hover:bg-[#3B82F6] transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Sprawdź odpowiedź
        </button>
      ) : (
        <div className={`p-4 rounded-xl ${isCorrect ? 'bg-green-50 border border-green-200' : 'bg-red-50 border border-red-200'}`}>
          <p className={`text-sm ${isCorrect ? 'text-green-700' : 'text-red-700'}`}>
            {isCorrect ? '✓ Świetnie! To poprawna odpowiedź.' : '✗ Niestety, to nie jest poprawna odpowiedź. Spróbuj ponownie w następnym podejściu.'}
          </p>
        </div>
      )}
    </div>
  );
}
