﻿ Перем ИмяФормата;

// Отказ от открытия обработки, выдаем сообщение о "служебности" обработки
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Предупреждение("Обработка вызывается только из ПП ""Обмен информацией между ПП ""1С:Предприятие 8.0"" и системами ""Клиент-Банк""");
	Отказ = Истина;
КонецПроцедуры

// Возвращает Истина, если код в банке есть, Ложь - иначе
//
// Параметры: нет
//
// Возвращаемое значение:
//
//   Булево   – Истина, если код в банке есть, Ложь - иначе
//
Функция ЕстьКодВБанке() Экспорт
	Возврат Ложь;
КонецФункции	
	
// Возвращает наименование кода в банке
//
// Параметры:
//
//	нет
//
// Возвращаемое значение:
//
// 	Строка - наименование кода
//
Функция ПолучитьНаименованиеКода() Экспорт
	Возврат "";
КонецФункции		

// Возвращает код банка организации
//
// Параметры:
//
//  Структура Параметры
// 		Ключ Организация - Организация - Справочник.Ссылки.Организация          
//
// Возвращаемое значение:
//
//   Строка   – код организации в банке
//
Функция кбПолучитьКодОрганизации(Параметры) Экспорт
	Возврат "";
КонецФункции

// Формирует имя файла по умолчанию
//
// Параметры:
//
// 	Структура Параметры
//		Ключ Режим - Режим - Строка "Импорт"/"Экспорт"
// 		Ключ Дата -  Дата выписки (импорт) - Дата
// 		Ключ Организация - Организация - Справочник.Ссылки.Организация          
// 		Ключ КодВБанке - код в банке (если есть) 
//		Ключ РСчет - Расчетный счет
// 
// Возвращаемое значение:
//
//   имя файла по умолчанию
//
Функция СформироватьИмяФайла(Параметры) Экспорт 
	ИмяФайла = ВосстановитьЗначение(ИмяФормата + Параметры.Организация +  "ИмяФайла" + Параметры.Режим);
	Если Параметры.Режим = "Импорт" Тогда
		Если ИмяФайла = Неопределено Тогда
			Возврат "Export.txt";
		Иначе
			Возврат ИмяФайла;
		КонецЕсли;	
	Иначе	
		
		Если ИмяФайла = Неопределено Тогда
			Возврат "Import.txt";
		Иначе
			Возврат ИмяФайла;
		КонецЕсли;	
	КонецЕсли;	
КонецФункции

// Выбирает имя файла
//
// Параметры:
//
// 	Структура Параметры
//		Ключ Режим - Режим - Строка "Импорт"/"Экспорт"
// 		Ключ Дата -  Дата выписки (импорт) - Дата
// 		Ключ КодВБанке - код в банке (если есть) 
//      Ключ ТекущееИмяФайла - строка - текущее имя файла в основной обработке
//      Ключ ТекущийТипФайла - текущий тип файла ("TXT"/"DBF"/"XML")
//
// Возвращаемое значение:
//
//   Строка   – выбранное имя файла
//
Функция ВыбратьИмяФайла(Параметры) Экспорт
	
	РежимДиалога = ?(Параметры.Режим = "Импорт", РежимДиалогаВыбораФайла.Открытие, РежимДиалогаВыбораФайла.Сохранение);
	Длг = Новый ДиалогВыбораФайла(РежимДиалога);
	
	Длг.ПолноеИмяФайла = Параметры.ТекущееИмяФайла;
	Длг.Заголовок = "Выберите файл";
	Длг.Фильтр = "Текстовые файлы (*.txt)|*.txt";
	Длг.Расширение = "*";   //Параметры.ТекущийТипФайла;
	
	Если Длг.Выбрать() Тогда
		Возврат Длг.ПолноеИмяФайла;
	КонецЕсли;
	
	Возврат Параметры.ТекущееИмяФайла;
КонецФункции

// Возвращает сохраненный тип файла
//
// Параметры:
//
// 	Структура Параметры
//		Ключ Режим - Режим - Строка "Импорт"/"Экспорт"
//
// Возвращаемое значение:
//
//   Строка – текущий тип файла ("TXT"/"DBF"/"XML")
//
Функция ПолучитьТекущийТипФайла(Параметры) Экспорт
	
	ТипФайла = ВосстановитьЗначение(ИмяФормата + Параметры.Организация +  "ТипФайла" + Параметры.Режим);
	
	Если Параметры.Режим = "Импорт" Тогда
		Если ТипФайла = Неопределено Тогда
			Возврат "TXT";
		Иначе
			Возврат ТипФайла;
		КонецЕсли;	
	Иначе 
		// Параметры.Режим = "Экспорт"
		Если ТипФайла = Неопределено Тогда
			Возврат "TXT";
		Иначе
			Возврат ТипФайла;
		КонецЕсли;	
	КонецЕсли;	
	
КонецФункции

// Сохраняет значения для формата:
//
//	Имя файла
// 	Тип файла 
// 	Код в банке, если такой существует
//
// Параметры:
// 		Структура Параметры
//		Ключ Режим - Режим - Строка "Импорт"/"Экспорт"
// 		Ключ Организация - Организация - Справочник.Ссылки.Организация          
// 		Ключ КодВБанке - код в банке (если есть) 
//      Ключ ТекущееИмяФайла - строка - текущее имя файла в основной обработке
//      Ключ ТекущийТипФайла - строка - текущий тип файла в основной обработке
//  
Процедура СохранитьЗначения(Параметры) Экспорт
	
	СохранитьЗначение(ИмяФормата + Параметры.Организация +  "ИмяФайла" + Параметры.Режим, Параметры.ТекущееИмяФайла);
	СохранитьЗначение(ИмяФормата + Параметры.Организация +  "ТипФайла" + Параметры.Режим, Параметры.ТекущийТипФайла);
	Если ЕстьКодВБанке() Тогда 
		СохранитьЗначение(ИмяФормата + Параметры.Организация +  "КодВБанке", Параметры.КодВБанке); // если есть 
	КонецЕсли;	
	
КонецПроцедуры

// Обработка формата должна вернуть режимы и типы файлов, которая она поддерживает.
//
// Параметры: нет
//
//  Возвращаемое значение:
//
//	Возвращает структуру со следующими ключами:
//
//	Импорт (Истина/Ложь)
//	ИмпортTXT (Истина/Ложь)
//	ИмпортDBF (Истина/Ложь)
//	ИмпортXML (Истина/Ложь)
//	Экспорт (Истина/Ложь)
//	ЭкспортTXT (Истина/Ложь) 
//	ЭкспортDBF (Истина/Ложь)
//	ЭкспортXML (Истина/Ложь)
//
Функция ПолучитьПоддерживаемыеРежимы() Экспорт
	
	ИмпортЭкспорт = Новый Структура;
	ИмпортЭкспорт.Вставить("Импорт", Истина);
	ИмпортЭкспорт.Вставить("ИмпортTXT", Истина);
	ИмпортЭкспорт.Вставить("ИмпортDBF", Ложь);
	ИмпортЭкспорт.Вставить("ИмпортXML", Ложь);
	
	ИмпортЭкспорт.Вставить("Экспорт", Истина);
	ИмпортЭкспорт.Вставить("ЭкспортTXT", Истина);
	ИмпортЭкспорт.Вставить("ЭкспортDBF", Ложь);
	ИмпортЭкспорт.Вставить("ЭкспортXML", Ложь);
	
	Возврат ИмпортЭкспорт;
	
КонецФункции

Функция ПолучитьЗначение(Стр)
	Рзд = Символ(9);
	Значение = "";
	Поз = Найти(Стр, Рзд);
	Если Поз > 0 Тогда
		Значение = Лев(Стр, Поз-1);
		Стр = Сред(Стр, Поз+1);
	Иначе
		Значение = Стр;
		Стр = "";
	КонецЕсли;
	Возврат СокрЛП(Значение);
КонецФункции // ПолучитьЗначение

// Осуществляет импорт выписки из файла типа "TXT"
//
// Параметры:
//
//	Структура Параметры   
//
// 		Ключ ДатаДок - Дата выписки  – дата 
// 		Ключ Организация - Организация - СправочникСсылка.Организации
//		Ключ РСчет - Расчетный счет организации - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//
//
// Возвращаемое значение:
//
//   Таблица значений тзВыписка
//		
//		тзВыписка - Таблица платежей – таблица значений тзВыписка с полями 
//			НомерПП – строка, номер платежного поручения 
//			Приход – число, сумма прихода
//			Расход – число, сумма расхода
//			ОКПО – строка, ЕДРПОУ контрагента
//			Контрагент – строка, наименование контрагента, как оно указано в выписке
//			МФО - строка, МФО банка контрагента
//			РСчет - строка, расчетный счет контрагента
//			Содержание - строка, содержание платежа
//
//		Если при импорте выписки произошли ошибки, возвращается Неопределенно.
//      
//      При проверке на дату платежа, если платежей с датой, которая отличается от переданной было > 0
//      необходимо выдать предупреждение
//
Функция ИмпортTXT(Параметры)
	ФайлTXT	= Новый ТекстовыйДокумент;
	ИмяФайла = Параметры.ИмяФайла;
	Попытка
		ФайлTXT.Прочитать(ИмяФайла, КодировкаТекста.ANSI); //Windows
	Исключение
		Предупреждение("Ошибка открытия файла " + ИмяФайла);
		Возврат Неопределено;
	КонецПопытки;		
	
	тзВыписка =  Новый ТаблицаЗначений;
	тзВыписка.Колонки.Добавить("НомерПП");
	тзВыписка.Колонки.Добавить("Приход");
	тзВыписка.Колонки.Добавить("Расход");
	тзВыписка.Колонки.Добавить("ОКПО");
	тзВыписка.Колонки.Добавить("Контрагент");
	тзВыписка.Колонки.Добавить("МФО");
	тзВыписка.Колонки.Добавить("РСчет");
	тзВыписка.Колонки.Добавить("Содержание");
	
	Для н = 1 По ФайлTXT.КоличествоСтрок() Цикл
		ТекСтрока = ФайлTXT.ПолучитьСтроку(н);
		
		Для инд1 = 1 По 2 Цикл // пропускаем наименование нашей организации и МФО
			ПолучитьЗначение(ТекСтрока);
		КонецЦикла;
		
		Если СокрЛП(ПолучитьЗначение(ТекСтрока)) <> Параметры.РСчет Тогда // не наш р/счет!
			Продолжить;
		КонецЕсли;
		
		ПолучитьЗначение(ТекСтрока); // наш ОКПО
		Контрагент = ПолучитьЗначение(ТекСтрока);
		ТекМФО = ПолучитьЗначение(ТекСтрока);
		
		РСчет 		= ПолучитьЗначение(ТекСтрока);
		ОКПО 		= ПолучитьЗначение(ТекСтрока);
		НомерПП 	= ПолучитьЗначение(ТекСтрока);
		Содержание	= ПолучитьЗначение(ТекСтрока);
		Приход 		= Цел(ПолучитьЗначение(ТекСтрока))/100;
		Расход 		= Цел(ПолучитьЗначение(ТекСтрока))/100;
		
		// определим дату проведения документа банком
		ДатаПП = ПолучитьЗначение(ТекСтрока); // в формате ДД.ММ.ГГГГ
		ДатаПроведения = ПолучитьЗначение(ТекСтрока); // в формате ММДД
		
		//ДатаПроведения = Дата(Прав(ДатаПроведения, 2)+"."+Лев(ДатаПроведения, 2)+"."+Прав(ДатаПП,4));
		//ДатаПП = Дата(ДатаПП);
		//
		//Если ДатаПроведения < ДатаПП Тогда
		//	// Может быть такая ситуация: если документ проведен позже, чем он создан, например создан 31.12.2001,
		//	// а проведен 01.01.2002, тогда получим ДатаПП 31.12.2001, ДатаПроведения 01.01.2001  !!!
		//	ДатаПроведения = ДобавитьМесяц(ДатаПроведения, 12);
		//КонецЕсли;
		
		//Если ДатаПроведения <> Формат(Параметры.ДатаДок,"ДФ=dd.MM.yyyy") Тогда
		//	Продолжить;
		//КонецЕсли;
		
		Если ДатаПП <> Формат(Параметры.ДатаДок,"ДФ=dd.MM.yyyy") Тогда
			Продолжить;
		КонецЕсли;
		
		НовСтрока = тзВыписка.Добавить();
		НовСтрока.Контрагент	= Контрагент;
		НовСтрока.Приход		= Приход;
		НовСтрока.Расход		= Расход;
		НовСтрока.РСчет			= РСчет;
		НовСтрока.ОКПО			= ОКПО;
		НовСтрока.НомерПП		= НомерПП;
		НовСтрока.Содержание	= Содержание;
		
		Если Цел(ТекМФО) = 0 Тогда // счет контрагента в нашем банке...
//			НовСтрока.МФО		= Параметры.НашМФО; //убрал временно
		Иначе
			НовСтрока.МФО		= ТекМФО;
		КонецЕсли;
		
	КонецЦикла;	
	
	Если НЕ тзВыписка.Количество() И ФайлTXT.КоличествоСтрок() Тогда
		Предупреждение("В текущем файле нет платежей с данной датой выписки и расчетным счетом!");
	КонецЕсли;
	
	Возврат тзВыписка;	
КонецФункции	

// Осуществляет импорт выписки из файла типа "XML"
//
// Параметры:
//
//	Структура Параметры   
//
// 		Ключ ДатаДок - Дата выписки  – дата 
// 		Ключ Организация - Организация - СправочникСсылка.Организации
//		Ключ РСчет - Расчетный счет организации - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//
//
// Возвращаемое значение:
//
//   Таблица значений тзВыписка
//		
//		тзВыписка - Таблица платежей – таблица значений тзВыписка с полями 
//			НомерПП – строка, номер платежного поручения 
//			Приход – число, сумма прихода
//			Расход – число, сумма расхода
//			ОКПО – строка, ЕДРПОУ контрагента
//			Контрагент – строка, наименование контрагента, как оно указано в выписке
//			МФО - строка, МФО банка контрагента
//			РСчет - строка, расчетный счет контрагента
//			Содержание - строка, содержание платежа
//
//		Если при импорте выписки произошли ошибки, возвращается Неопределенно.
//      
//      При проверке на дату платежа, если платежей с датой, которая отличается от переданной было > 0
//      необходимо выдать предупреждение
//
Функция ИмпортXML(Параметры)
	Возврат Неопределено;	
КонецФункции	

// Осуществляет импорт выписки из файла типа "DBF"
//
// Параметры:
//
//	Структура Параметры   
//
// 		Ключ ДатаДок - Дата выписки  – дата 
// 		Ключ Организация - Организация - СправочникСсылка.Организации
//		Ключ РСчет - Расчетный счет организации - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//
//
// Возвращаемое значение:
//
//   Таблица значений тзВыписка
//		
//		тзВыписка - Таблица платежей – таблица значений тзВыписка с полями 
//			НомерПП – строка, номер платежного поручения 
//			Приход – число, сумма прихода
//			Расход – число, сумма расхода
//			ОКПО – строка, ЕДРПОУ контрагента
//			Контрагент – строка, наименование контрагента, как оно указано в выписке
//			МФО - строка, МФО банка контрагента
//			РСчет - строка, расчетный счет контрагента
//			Содержание - строка, содержание платежа
//
//		Если при импорте выписки произошли ошибки, возвращается Неопределенно.
//      
//      При проверке на дату платежа, если платежей с датой, которая отличается от переданной было > 0
//      необходимо выдать предупреждение
//
Функция ИмпортDBF(Параметры)
	Возврат Неопределено;	
КонецФункции	

// Осуществляет импорт выписки из файла
//
// Параметры:
//
//	Структура Параметры   
//
// 		Ключ ДатаДок - Дата выписки  – дата 
// 		Ключ Организация - Организация - СправочникСсылка.Организации
//		Ключ РСчет - Расчетный счет организации - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//
//
// Возвращаемое значение:
//
//   Таблица значений тзВыписка
//		
//		тзВыписка - Таблица платежей – таблица значений тзВыписка с полями 
//			НомерПП – строка, номер платежного поручения 
//			Приход – число, сумма прихода
//			Расход – число, сумма расхода
//			ОКПО – строка, ЕДРПОУ контрагента
//			Контрагент – строка, наименование контрагента, как оно указано в выписке
//			МФО - строка, МФО банка контрагента
//			РСчет - строка, расчетный счет контрагента
//			Содержание - строка, содержание платежа
//
//		Если при импорте выписки произошли ошибки, возвращается Неопределенно.
//      
//      При проверке на дату платежа, если платежей с датой, которая отличается от переданной было > 0
//      необходимо выдать предупреждение
//
Функция ИмпортВыписки(Параметры) Экспорт
	Если Параметры.ТипФайла = "DBF" Тогда
		Возврат ИмпортDBF(Параметры);	
	ИначеЕсли Параметры.ТипФайла = "TXT" Тогда
		Возврат ИмпортTXT(Параметры);
	ИначеЕсли Параметры.ТипФайла = "XML" Тогда
		Возврат ИмпортXML(Параметры);
	КонецЕсли;	
КонецФункции

// Осуществляет экспорт платежных поручений в файл типа "TXT"
//
// Параметры:
//
//	Структура Параметры   
//                 
//		Ключ НашМФО - МФО организации - строка
//		Ключ НашСчет - 	Расчетный счет организации - строка
//      Ключ НашОКПО - 	ЕДРПОУ организации  - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//		Ключ тзПлатежныеПоручения - Таблица значений с полями:
//			Номер платежного поручения (НомерПП) - строка
//			Дата платежного поручения (ДатаПП) - строка
//			Контрагент (Контрагент) - строка
//			МФО расчетного счета контрагента (МФО) - строка
//			Расчетный счет контрагента (Счет) - строка
//			ЕДРПОУ контрагента (ОКПО) - строка
//			Сумма платежного поручения (Сумма) – число 
//			Содержание платежа (Содержание) – строка 
//			!!!(Банк) - строка
//
// Возвращаемое значение:
//
//   Булево - Истина - успешный экспорт
//
Функция ЭкспортTXT(Параметры)
	Текст = Новый ТекстовыйДокумент;
	
	//ТекСтрока = "";

	Ном = 0;
	Пайп = Символ(9);
	
	Для Каждого Строка из Параметры.тзПлатежныеПоручения Цикл
		Ном = Ном + 1;
		
		ТекСтрока = СокрЛП(Строка.НомерПП) + Пайп; //Payment order Number
		ТекСтрока = ТекСтрока + Формат(Строка.ДатаПП,"ДФ=dd.MM.yyyy") + Пайп; //Date
		ТекСтрока = ТекСтрока + Формат(Строка.ДатаПП,"ДФ=dd.MM.yyyy") + Пайп; //Value Date

		ТекСтрока = ТекСтрока + СокрЛП(Параметры.НашОКПО) + Пайп; // Payer Code (Payer company ID)
		ТекСтрока = ТекСтрока + СокрЛП(Параметры.НашаФирма) + Пайп; // Customer (Payer) Name
		ТекСтрока = ТекСтрока +  "840" + Пайп; // Country code - 3 пробела
		ТекСтрока = ТекСтрока + СокрЛП(Параметры.НашМФО) + Пайп; // Payer bank Code
		ТекСтрока = ТекСтрока + СокрЛП(Параметры.НашБанк) + Пайп; // Payer’s Bank Name
		ТекСтрока = ТекСтрока + СокрЛП(Параметры.НашСчет) + Пайп; // Payer‘s Account number

		ТекСтрока = ТекСтрока + СтрЗаменить(Формат(Строка.Сумма, "ЧГ=0"),",",".") + Пайп; // Amount In Digits

		ТекСтрока = ТекСтрока + СокрЛП(Строка.ОКПО) + Пайп; // Code (Beneficiary company ID)
		ТекСтрока = ТекСтрока + СтрЗаменить(СокрЛП(Строка.Контрагент),"""","") + Пайп; // Beneficiary name
		ТекСтрока = ТекСтрока +  "840" + Пайп; // Country code - 3 пробела
		ТекСтрока = ТекСтрока + СокрЛП(Строка.МФО) + Пайп; // Beneficiary bank Code (MFO code)
		ТекСтрока = ТекСтрока + СокрЛП(Строка.Банк) + Пайп; // Beneficiary Bank Name
		ТекСтрока = ТекСтрока + СокрЛП(Строка.Счет) + Пайп; // Beneficiary Account number
		
		СуммаПрописью = ЧислоПрописью(Строка.Сумма,,"гривна, гривны, гривен, ж, копейка, копейки, копеек, ж, 2");
		//СуммаПрописью = ЧислоПрописью(Строка.Сумма);

		ТекСтрока = ТекСтрока + Лев(СуммаПрописью, 255) + Пайп; // Amount in words
		//ТекСтрока = ТекСтрока + СокрЛП(СуммаПрописью) + Пайп; // Amount in words
		ТекСтрока = ТекСтрока + СокрЛП(Строка.Содержание) + Пайп; // Purpose of Payment

		ТекСтрока = ТекСтрока + " " + Пайп + " " + Пайп + " " + Пайп + " " + Пайп; 
		
		Текст.ДобавитьСтроку(ТекСтрока);			
		
	КонецЦикла;        
	
	ИмяФайла = Параметры.ИмяФайла;	
	Попытка
		Текст.Записать(ИмяФайла, КодировкаТекста.ANSI);
	Исключение
		Предупреждение("Ошибка записи файла " + ИмяФайла);
		Возврат Ложь;
	КонецПопытки;		
	
	Возврат Истина;

	КонецФункции

// Осуществляет экспорт платежных поручений в файл типа "XML"
//
// Параметры:
//
//	Структура Параметры   
//                 
//		Ключ НашМФО - МФО организации - строка
//		Ключ НашСчет - 	Расчетный счет организации - строка
//      Ключ НашОКПО - 	ЕДРПОУ организации  - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//		Ключ тзПлатежныеПоручения - Таблица значений с полями:
//			Номер платежного поручения (НомерПП) - строка
//			Дата платежного поручения (ДатаПП) - строка
//			Контрагент (Контрагент) - строка
//			МФО расчетного счета контрагента (МФО) - строка
//			Расчетный счет контрагента (Счет) - строка
//			ЕДРПОУ контрагента (ОКПО) - строка
//			Сумма платежного поручения (Сумма) – число 
//			Содержание платежа (Содержание) – строка 
//			!!!(Банк) - строка
//
// Возвращаемое значение:
//
//   Булево - Истина - успешный экспорт
//
Функция ЭкспортXML(Параметры)
	Возврат Ложь;
КонецФункции

// Осуществляет экспорт платежных поручений в файл типа "DBF"
//
// Параметры:
//
//	Структура Параметры   
//                 
//		Ключ НашМФО - МФО организации - строка
//		Ключ НашСчет - 	Расчетный счет организации - строка
//      Ключ НашОКПО - 	ЕДРПОУ организации  - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//		Ключ тзПлатежныеПоручения - Таблица значений с полями:
//			Номер платежного поручения (НомерПП) - строка
//			Дата платежного поручения (ДатаПП) - строка
//			Контрагент (Контрагент) - строка
//			МФО расчетного счета контрагента (МФО) - строка
//			Расчетный счет контрагента (Счет) - строка
//			ЕДРПОУ контрагента (ОКПО) - строка
//			Сумма платежного поручения (Сумма) – число 
//			Содержание платежа (Содержание) – строка 
//			!!!(Банк) - строка
//
// Возвращаемое значение:
//
//   Булево - Истина - успешный экспорт
//
Функция ЭкспортDBF(Параметры)
	Возврат Ложь;
КонецФункции

// Осуществляет экспорт платежных поручений в файл
//
// Параметры:
//
//	Структура Параметры   
//                 
//		Ключ НашМФО - МФО организации - строка
//		Ключ НашСчет - 	Расчетный счет организации - строка
//      Ключ НашОКПО - 	ЕДРПОУ организации  - строка
//		Ключ ИмяФайла - Имя файла  - строка  
//		Ключ ТипФайла - Тип файла  - строка ("TXT"/"DBF"/"XML")
//		Ключ тзПлатежныеПоручения - Таблица значений с полями:
//			Номер платежного поручения (НомерПП) - строка
//			Дата платежного поручения (ДатаПП) - строка
//			Контрагент (Контрагент) - строка
//			МФО расчетного счета контрагента (МФО) - строка
//			Расчетный счет контрагента (Счет) - строка
//			ЕДРПОУ контрагента (ОКПО) - строка
//			Сумма платежного поручения (Сумма) – число 
//			Содержание платежа (Содержание) – строка 
//
// Возвращаемое значение:
//
//   Булево - Истина - успешный экспорт
//
Функция ЭкспортПлатежныхПоручений(Параметры) Экспорт
	Если Параметры.ТипФайла = "DBF" Тогда
		Возврат ЭкспортDBF(Параметры);	
	ИначеЕсли Параметры.ТипФайла = "TXT" Тогда
		Возврат ЭкспортTXT(Параметры);
	ИначеЕсли Параметры.ТипФайла = "XML" Тогда
		Возврат ЭкспортXML(Параметры);
	КонецЕсли;	
		
КонецФункции

// Надо ли перекодировать текстовые поля (Контрагент, Содержание) после импорта. 
// Под перекодировкой понимается замена украинских символов
//
// Параметры: нет
//
//
// Возвращаемое значение:
//
//   Булево    – Истина - надо перекодировать/Ложь - не надо перекодировать
//
Функция ПерекодировкаИмпорта() Экспорт
	Возврат Ложь;
КонецФункции

// Надо ли перекодировать текстовые поля (Контрагент, Содержание) перед экспортом. 
// Под перекодировкой понимается замена украинских символов
//
// Параметры: нет
//
// Возвращаемое значение:
//
//   Булево    – Истина - надо перекодировать/Ложь - не надо перекодировать
//
Функция ПерекодировкаЭкспорта() Экспорт
	Возврат Ложь;
КонецФункции

ИмяФормата = "ING";

