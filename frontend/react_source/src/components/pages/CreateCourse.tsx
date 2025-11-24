import { useState } from 'react';
import { ArrowLeft, Plus, Image, Type, Video, HelpCircle, GripVertical, Trash2 } from 'lucide-react';

interface CreateCourseProps {
  onBack: () => void;
}

type BlockType = 'text' | 'image' | 'video' | 'quiz';

interface ContentBlock {
  id: string;
  type: BlockType;
  content: string;
}

interface Section {
  id: string;
  title: string;
  blocks: ContentBlock[];
}

export function CreateCourse({ onBack }: CreateCourseProps) {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [sections, setSections] = useState<Section[]>([]);

  const addSection = () => {
    const newSection: Section = {
      id: Date.now().toString(),
      title: 'Nowa sekcja',
      blocks: [],
    };
    setSections([...sections, newSection]);
  };

  const removeSection = (sectionId: string) => {
    setSections(sections.filter(s => s.id !== sectionId));
  };

  const updateSectionTitle = (sectionId: string, newTitle: string) => {
    setSections(sections.map(s => 
      s.id === sectionId ? { ...s, title: newTitle } : s
    ));
  };

  const addBlock = (sectionId: string, type: BlockType) => {
    const newBlock: ContentBlock = {
      id: Date.now().toString(),
      type,
      content: '',
    };
    setSections(sections.map(s => 
      s.id === sectionId ? { ...s, blocks: [...s.blocks, newBlock] } : s
    ));
  };

  const removeBlock = (sectionId: string, blockId: string) => {
    setSections(sections.map(s => 
      s.id === sectionId ? { ...s, blocks: s.blocks.filter(b => b.id !== blockId) } : s
    ));
  };

  const blockTypeConfig = {
    text: { icon: Type, label: 'Blok tekstu', placeholder: 'Wpisz treść...' },
    image: { icon: Image, label: 'Obraz', placeholder: 'URL obrazu...' },
    video: { icon: Video, label: 'Wideo', placeholder: 'URL wideo...' },
    quiz: { icon: HelpCircle, label: 'Quiz', placeholder: 'Pytanie quizu...' },
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center gap-4">
        <button
          onClick={onBack}
          className="p-2 hover:bg-[#F1F5F9] rounded-xl transition-colors"
        >
          <ArrowLeft className="w-5 h-5 text-[#475569]" />
        </button>
        <div className="flex-1">
          <h2 className="text-[#0F172A]">Tworzenie nowego kursu</h2>
          <p className="text-[#475569]">Wypełnij informacje i dodaj zawartość kursu</p>
        </div>
        <div className="flex items-center gap-3">
          <button className="px-6 py-3 bg-[#F8FAFC] text-[#475569] rounded-xl hover:bg-[#F1F5F9] transition-colors">
            Zapisz szkic
          </button>
          <button className="px-6 py-3 bg-[#2563EB] text-white rounded-xl hover:bg-[#3B82F6] transition-colors">
            Opublikuj
          </button>
        </div>
      </div>

      {/* Course info */}
      <div className="bg-white rounded-2xl border border-gray-200 p-6 space-y-6">
        <h3 className="text-[#0F172A]">Informacje o kursie</h3>
        
        <div>
          <label className="block text-[#0F172A] mb-2">Tytuł kursu</label>
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="np. Wprowadzenie do React"
            className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
          />
        </div>

        <div>
          <label className="block text-[#0F172A] mb-2">Opis</label>
          <textarea
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            placeholder="Opisz czego użytkownicy nauczą się w tym kursie..."
            rows={4}
            className="w-full px-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB] resize-none"
          />
        </div>

        <div>
          <label className="block text-[#0F172A] mb-2">Miniatura kursu</label>
          <div className="flex items-center gap-4">
            <div className="w-32 h-32 bg-[#F1F5F9] rounded-xl flex items-center justify-center border border-gray-300">
              <Image className="w-8 h-8 text-[#475569]" />
            </div>
            <button className="px-4 py-2 bg-[#F8FAFC] text-[#475569] rounded-xl hover:bg-[#F1F5F9] transition-colors border border-gray-300">
              Prześlij obraz
            </button>
          </div>
        </div>
      </div>

      {/* Sections */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-[#0F172A]">Sekcje kursu</h3>
          <button
            onClick={addSection}
            className="flex items-center gap-2 px-4 py-2 bg-[#F8FAFC] text-[#2563EB] rounded-xl hover:bg-[#F1F5F9] transition-colors border border-gray-300"
          >
            <Plus className="w-4 h-4" />
            Dodaj sekcję
          </button>
        </div>

        {sections.length === 0 ? (
          <div className="bg-white rounded-2xl border border-gray-200 p-12 text-center">
            <p className="text-[#475569]">Brak sekcji. Kliknij "Dodaj sekcję", aby rozpocząć.</p>
          </div>
        ) : (
          sections.map((section, sectionIndex) => (
            <div key={section.id} className="bg-white rounded-2xl border border-gray-200 p-6 space-y-4">
              {/* Section header */}
              <div className="flex items-center gap-3">
                <GripVertical className="w-5 h-5 text-[#475569]" />
                <input
                  type="text"
                  value={section.title}
                  onChange={(e) => updateSectionTitle(section.id, e.target.value)}
                  className="flex-1 px-4 py-2 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
                />
                <button
                  onClick={() => removeSection(section.id)}
                  className="p-2 hover:bg-red-50 text-red-600 rounded-xl transition-colors"
                >
                  <Trash2 className="w-5 h-5" />
                </button>
              </div>

              {/* Content blocks */}
              {section.blocks.length > 0 && (
                <div className="space-y-3 ml-8">
                  {section.blocks.map((block) => {
                    const config = blockTypeConfig[block.type];
                    const Icon = config.icon;
                    return (
                      <div key={block.id} className="flex items-start gap-3 p-4 bg-[#F8FAFC] rounded-xl border border-gray-200">
                        <Icon className="w-5 h-5 text-[#475569] mt-1" />
                        <div className="flex-1">
                          <p className="text-sm text-[#475569] mb-2">{config.label}</p>
                          <input
                            type="text"
                            placeholder={config.placeholder}
                            className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#2563EB]"
                          />
                        </div>
                        <button
                          onClick={() => removeBlock(section.id, block.id)}
                          className="p-1 hover:bg-red-50 text-red-600 rounded-lg transition-colors"
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    );
                  })}
                </div>
              )}

              {/* Add block buttons */}
              <div className="ml-8 flex flex-wrap gap-2">
                {(Object.keys(blockTypeConfig) as BlockType[]).map((type) => {
                  const config = blockTypeConfig[type];
                  const Icon = config.icon;
                  return (
                    <button
                      key={type}
                      onClick={() => addBlock(section.id, type)}
                      className="flex items-center gap-2 px-3 py-2 bg-white text-[#475569] rounded-lg hover:bg-[#F1F5F9] transition-colors border border-gray-300 text-sm"
                    >
                      <Icon className="w-4 h-4" />
                      {config.label}
                    </button>
                  );
                })}
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}
