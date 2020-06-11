﻿Перем ТЗ_Адресаты;
Перем Профиль;

Процедура ВыполнитьОтчет()
	Если ТЗ_Адресаты.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ДокументыПоставщиков.ДоговорКонтрагента.Номер ПОДОБНО ""%%OP%%""
	|			ТОГДА ""OP""
	|		КОГДА ДокументыПоставщиков.ДоговорКонтрагента.Номер ПОДОБНО ""%%MP%%""
	|			ТОГДА ""MP""
	|		КОГДА ДокументыПоставщиков.ДоговорКонтрагента.Номер ПОДОБНО ""%%CP%%""
	|			ТОГДА ""CP""
	|		КОГДА ДокументыПоставщиков.ДоговорКонтрагента.Номер ПОДОБНО ""%%VP%%""
	|			ТОГДА ""VP""
	|		КОГДА ДокументыПоставщиков.ДоговорКонтрагента.Номер ПОДОБНО ""%%IP%%""
	|			ТОГДА ""IP""
	|		ИНАЧЕ ДокументыПоставщиков.ДоговорКонтрагента.Номер
	|	КОНЕЦ КАК Подразделение,
	|	НАЧАЛОПЕРИОДА(ДокументыПоставщиков.Дата, ДЕНЬ) КАК Дата,
	|	ДокументыПоставщиков.Ссылка.Представление КАК Документ,
	|	ДокументыПоставщиков.Ссылка КАК Ссылка,
	|	ДокументыПоставщиков.Номер КАК Номер,
	|	ДокументыПоставщиков.Контрагент.Представление КАК Контрагент,
	|	ДокументыПоставщиков.ДоговорКонтрагента КАК Договор,
	|	ДокументыПоставщиков.СуммаДокумента КАК Сумма
	|ПОМЕСТИТЬ Врем
	|ИЗ
	|	ЖурналДокументов.ДокументыПоставщиков КАК ДокументыПоставщиков
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ГраницыЗапретаИзмененияДанных КАК ГраницыЗапретаИзмененияДанных
	|		ПО ДокументыПоставщиков.Организация = ГраницыЗапретаИзмененияДанных.Организация
	|ГДЕ
	|	ИСТИНА
	|	И ДокументыПоставщиков.Номер ПОДОБНО ""SR%%""
	|	И НЕ ДокументыПоставщиков.ПометкаУдаления
	|	И ДокументыПоставщиков.Проведен
	|	И ДокументыПоставщиков.Дата >= ЕСТЬNULL(ГраницыЗапретаИзмененияДанных.ГраницаЗапретаИзменений, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))
	|	И НЕ ЕСТЬNULL(ДокументыПоставщиков.Ссылка.Проверил, ЛОЖЬ)
	|	И ГраницыЗапретаИзмененияДанных.Пользователь = НЕОПРЕДЕЛЕНО
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДокТЧ.Ссылка КАК Ссылка,
	|	МАКСИМУМ(ДокТЧ.ДоговорКонтрагента) КАК Договор
	|ПОМЕСТИТЬ Договора
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг.Товары КАК ДокТЧ
	|ГДЕ
	|	ИСТИНА
	|	И ДокТЧ.НомерСтроки = 1
	|	И ДокТЧ.Ссылка В
	|			(ВЫБРАТЬ
	|				Врем.Ссылка КАК Ссылка
	|			ИЗ
	|				Врем КАК Врем)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДокТЧ.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Врем.Дата КАК Дата,
	|	Врем.Документ КАК Документ,
	|	Врем.Ссылка КАК Ссылка,
	|	Врем.Номер КАК Номер,
	|	Врем.Контрагент КАК Контрагент,
	|	ВЫБОР
	|		КОГДА Врем.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|				И НЕ Договора.Договор ЕСТЬ NULL
	|			ТОГДА Договора.Договор
	|		ИНАЧЕ Врем.Договор
	|	КОНЕЦ КАК Договор,
	|	Врем.Сумма КАК Сумма
	|ПОМЕСТИТЬ Врем2
	|ИЗ
	|	Врем КАК Врем
	|		ЛЕВОЕ СОЕДИНЕНИЕ Договора КАК Договора
	|		ПО Врем.Ссылка = Договора.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Врем2.Договор.Номер ПОДОБНО ""%%OP%%""
	|			ТОГДА ""OP""
	|		КОГДА Врем2.Договор.Номер ПОДОБНО ""%%MP%%""
	|			ТОГДА ""MP""
	|		КОГДА Врем2.Договор.Номер ПОДОБНО ""%%CP%%""
	|			ТОГДА ""CP""
	|		КОГДА Врем2.Договор.Номер ПОДОБНО ""%%VP%%""
	|			ТОГДА ""VP""
	|		КОГДА Врем2.Договор.Номер ПОДОБНО ""%%IP%%""
	|			ТОГДА ""IP""
	|		ИНАЧЕ Врем2.Договор.Номер
	|	КОНЕЦ КАК Подразделение,
	|	Врем2.Дата,
	|	Врем2.Документ,
	|	Врем2.Ссылка,
	|	Врем2.Номер,
	|	Врем2.Контрагент,
	|	Врем2.Договор.Представление КАК Договор,
	|	Врем2.Сумма
	|ИЗ
	|	Врем2 КАК Врем2
	|
	|УПОРЯДОЧИТЬ ПО
	|	Подразделение,
	|	Врем2.Контрагент,
	|	Врем2.Дата,
	|	Врем2.Документ
	|ИТОГИ ПО
	|	Подразделение
	|";
					   
	ВыборкаПоПодразделениям = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Макет = ПолучитьМакет("Макет");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	Шапка.Параметры.ДатаОтчета = ТекущаяДата();
	СтрокаОтчета = Макет.ПолучитьОбласть("Строка");
	
	Пока ВыборкаПоПодразделениям.Следующий() Цикл 
		Таблица = Новый ТабличныйДокумент;
		
		Подразделение = ВыборкаПоПодразделениям.Подразделение;
		Шапка.Параметры.Подразделение = Подразделение;
		Таблица.Вывести(Шапка);
		
		Детализация = ВыборкаПоПодразделениям.Выбрать();
		#Если Клиент Тогда
			Сообщить("По подразделению "+Подразделение +" получено " + Детализация.Количество() + " документов.");
		#КонецЕсли
		Пока Детализация.Следующий() Цикл 
			ЗаполнитьЗначенияСвойств(СтрокаОтчета.Параметры, Детализация);
			Таблица.Вывести(СтрокаОтчета);
		КонецЦикла;
		
		Таблица.ОтображатьГруппировки = Ложь;
		Таблица.ОтображатьЗаголовки = Ложь;
		Таблица.ОтображатьСетку = Ложь;
		ОтослатьПочту(Таблица, Подразделение);
	КонецЦикла;
	#Если Клиент Тогда
		Сообщить("Готово.");
	#КонецЕсли
КонецПроцедуры

Процедура ОтослатьПочту(ТабДок, Подразделение)
	Если 1=0 Тогда
		ТабДок = Новый ТабличныйДокумент;	
	КонецЕсли;
	
	АдресаTO = Новый СписокЗначений; АдресаCC = Новый СписокЗначений;
	Адреса = ТЗ_Адресаты.НайтиСтроки(Новый Структура("Подразделение", Подразделение));
	Для каждого СтрокаАдресат Из Адреса Цикл
		ЗаполнитьАдресаИзСтроки(АдресаTO, СокрЛП(СтрокаАдресат.TO));
		ЗаполнитьАдресаИзСтроки(АдресаCC, СокрЛП(СтрокаАдресат.CC));
	КонецЦикла;
	
	Если (АдресаTO.Количество()=0) и (АдресаCC.Количество()=0) Тогда
		Возврат; // некуда отправить
	КонецЕсли;
		
	ИмяФайлаВложения = КаталогВременныхФайлов() + Подразделение + ".xlsx"; 
	ТабДок.Записать(ИмяФайлаВложения,ТипФайлаТабличногоДокумента.XLSX);
	ОтправитьФайлПоПочте(ИмяФайлаВложения, АдресаTO, АдресаCC);
	УдалитьФайлы(ИмяФайлаВложения);
КонецПроцедуры

Процедура ЗаполнитьАдресаИзСтроки(Список, СтрокаСРазделителями)
	СтрокаАдресов = СтрокаСРазделителями;
	Пока не ПустаяСтрока(СтрокаАдресов) Цикл
		ПозицияЗапятой = Найти(СтрокаАдресов ,",");
		Если ПозицияЗапятой = 0 Тогда
			Адрес = СтрокаАдресов;
		Иначе
			Адрес = Лев(СтрокаАдресов,ПозицияЗапятой-1);			
		КонецЕсли;
		Список.Добавить(Адрес);
		Если Адрес = СтрокаАдресов Тогда
			Прервать;
		КонецЕсли;
		СтрокаАдресов = Сред(СтрокаАдресов,ПозицияЗапятой+1);
	КонецЦикла;
КонецПроцедуры

Процедура ОтправитьФайлПоПочте(ИмяФайлаВложения, АдресаTO, АдресаCC)
	// Создадим почтовое сообщение
    Почта = Новый ИнтернетПочта;
	
	Письмо = Новый ИнтернетПочтовоеСообщение;
    Текст = Письмо.Тексты.Добавить("");
    Текст.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
    Письмо.Тема = "Перечень отсутствующих первичных документов на бумажных носителях на " + ТекущаяДата(); 
	Письмо.Вложения.Добавить(ИмяФайлаВложения,"Отчет");
    Письмо.Отправитель = "Robot1C.Kyiv@glencore.com.ua";
    Письмо.ИмяОтправителя = "Робот 1С";
	Для каждого АдресПочты Из АдресаTO Цикл
		Письмо.Получатели.Добавить(АдресПочты.Значение);	
	КонецЦикла;
	
	Для каждого АдресПочты Из АдресаCC Цикл
		Письмо.Копии.Добавить(АдресПочты.Значение);	
	КонецЦикла;
	
    Попытка
        Почта.Подключиться(Профиль);
        Почта.Послать(Письмо);
		#Если Клиент Тогда
			Сообщить("Письмо выслано.");
		#КонецЕсли
    Исключение
    КонецПопытки;
    
    Почта.Отключиться();    
КонецПроцедуры

Процедура Инициализация()
	ТЗ_Адресаты = Новый ТаблицаЗначений;
	ТЗ_Адресаты.Колонки.Добавить("Подразделение", Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(2, ДопустимаяДлина.Переменная)));
	ТЗ_Адресаты.Колонки.Добавить("TO", Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));
	ТЗ_Адресаты.Колонки.Добавить("CC", Новый ОписаниеТипов("Строка", ,Новый КвалификаторыСтроки(0, ДопустимаяДлина.Переменная)));	
	
	МакетАдресов = ПолучитьМакет("Адресаты");
	Область = МакетАдресов.ПолучитьОбласть("Адреса");
	Для Н = 1 По Область.ВысотаТаблицы Цикл
		НовСтр = ТЗ_Адресаты.Добавить();	
		НовСтр.Подразделение = СокрЛП(Область.Область(Н,1).Текст);
		НовСтр.TO = СокрЛП(Область.Область(Н,2).Текст);
		НовСтр.CC = СокрЛП(Область.Область(Н,3).Текст);
	КонецЦикла;
	
	Если ТЗ_Адресаты.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// значения свойств в примере условны
	Профиль = Новый ИнтернетПочтовыйПрофиль;
    Профиль.АдресСервераSMTP = "10.104.10.32";
    Профиль.АдресСервераPOP3 = "10.104.10.32";
    Профиль.ПортPOP3 = 110;
    Профиль.ПортSMTP = 25;
    Профиль.Пользователь = "Robot1C.Kyiv";
    Профиль.Пароль = "R0b0t1$";
    Профиль.ПользовательSMTP = "Robot1C.Kyiv";
    Профиль.ПарольSMTP = "R0b0t1$";
    Профиль.АутентификацияSMTP = СпособSMTPАутентификации.Login;
КонецПроцедуры

Инициализация();
ВыполнитьОтчет();