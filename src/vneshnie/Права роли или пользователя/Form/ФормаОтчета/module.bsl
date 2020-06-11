﻿// Возвращает таблицу значений со списком типов объектов метаданных и возможными правами доступа для них.
Функция ПолучитьТаблицуТиповОбъектов(отбор = неопределено)
	
	ТаблицаТиповОбъектов = Новый ТаблицаЗначений;
	ТаблицаТиповОбъектов.Колонки.Добавить("ТипОбъектовМетаданных");
	ТаблицаТиповОбъектов.Колонки.Добавить("ВидыПравДоступа");
	ТаблицаТиповОбъектов.Колонки.Добавить("Порядок");
	 
	// Константы, РегистрыСведений, РегистрыРасчета
	ВидыПравДоступа = Новый Массив;
	ВидыПравДоступа.Добавить("Чтение");
	ВидыПравДоступа.Добавить("Изменение");
	ВидыПравДоступа.Добавить("Просмотр");	
	ВидыПравДоступа.Добавить("Редактирование");
	Если типзнч(отбор) = ТипЗнч(Новый Массив) тогда
		Если не отбор.найти("Константы") = Неопределено тогда	
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "Константы";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
			НоваяСтрока.Порядок					= 1;
		КонецЕсли;
		Если не отбор.найти("РегистрыСведений") = Неопределено тогда
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "РегистрыСведений";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
			НоваяСтрока.Порядок					= 10;
		КонецЕсли;
		Если не отбор.найти("РегистрыРасчета") = Неопределено тогда
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "РегистрыРасчета";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
			НоваяСтрока.Порядок					= 13;
		КонецЕсли;
	иначе
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "Константы";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
		НоваяСтрока.Порядок					= 1;
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "РегистрыСведений";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
		НоваяСтрока.Порядок					= 10;
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "РегистрыРасчета";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
		НоваяСтрока.Порядок					= 13;
	КонецЕсли;
	
	
	
	// Справочники, ПланыВидовХарактеристик, ПланыСчетов, ПланыВидовРасчетов
	ВидыПравДоступа = Новый Массив;
	ВидыПравДоступа.Добавить("Чтение");
	ВидыПравДоступа.Добавить("Добавление");
	ВидыПравДоступа.Добавить("Изменение");
	ВидыПравДоступа.Добавить("Удаление");
	ВидыПравДоступа.Добавить("Просмотр");
	ВидыПравДоступа.Добавить("ИнтерактивноеДобавление");
	ВидыПравДоступа.Добавить("Редактирование");
	ВидыПравДоступа.Добавить("ИнтерактивноеУдаление");
	ВидыПравДоступа.Добавить("ИнтерактивнаяПометкаУдаления");
	ВидыПравДоступа.Добавить("ИнтерактивноеСнятиеПометкиУдаления");
	ВидыПравДоступа.Добавить("ИнтерактивноеУдалениеПомеченных");
	ВидыПравДоступа.Добавить("ВводПоСтроке");
	
	Если типзнч(отбор) = ТипЗнч(Новый Массив) тогда
		Если не отбор.найти("Справочники") = Неопределено тогда
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "Справочники";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
			НоваяСтрока.Порядок					= 2;
		КонецЕсли;
		Если не отбор.найти("ПланыВидовХарактеристик") = Неопределено тогда
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "ПланыВидовХарактеристик";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
			НоваяСтрока.Порядок					= 7;
		КонецЕсли;
		Если не отбор.найти("ПланыСчетов") = Неопределено тогда
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "ПланыСчетов";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
			НоваяСтрока.Порядок					= 8;
		КонецЕсли;
		Если не отбор.найти("ПланыВидовРасчета") = Неопределено тогда
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "ПланыВидовРасчета";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
			НоваяСтрока.Порядок					= 9;
		КонецЕсли;
	иначе
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "Справочники";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
		НоваяСтрока.Порядок					= 2;
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "ПланыВидовХарактеристик";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
		НоваяСтрока.Порядок					= 7;
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "ПланыСчетов";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
		НоваяСтрока.Порядок					= 8;
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "ПланыВидовРасчета";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
		НоваяСтрока.Порядок					= 9;
	КонецЕсли;
			
	// Документы
	ВидыПравДоступа = Новый Массив;
	ВидыПравДоступа.Добавить("Чтение");
	ВидыПравДоступа.Добавить("Добавление");
	ВидыПравДоступа.Добавить("Изменение");
	ВидыПравДоступа.Добавить("Удаление");
	ВидыПравДоступа.Добавить("Проведение");
	ВидыПравДоступа.Добавить("ОтменаПроведения");
	ВидыПравДоступа.Добавить("Просмотр");
	ВидыПравДоступа.Добавить("ИнтерактивноеДобавление");
	ВидыПравДоступа.Добавить("Редактирование");
	ВидыПравДоступа.Добавить("ИнтерактивноеУдаление");
	ВидыПравДоступа.Добавить("ИнтерактивнаяПометкаУдаления");
	ВидыПравДоступа.Добавить("ИнтерактивноеСнятиеПометкиУдаления");
	ВидыПравДоступа.Добавить("ИнтерактивноеУдалениеПомеченных");
	ВидыПравДоступа.Добавить("ИнтерактивноеПроведение");
	ВидыПравДоступа.Добавить("ИнтерактивноеПроведениеНеОперативное");
	ВидыПравДоступа.Добавить("ИнтерактивнаяОтменаПроведения");
	ВидыПравДоступа.Добавить("ИнтерактивноеИзменениеПроведенных");
	ВидыПравДоступа.Добавить("ВводПоСтроке");
	
	Если типзнч(отбор) = ТипЗнч(Новый Массив) тогда
		Если не отбор.найти("Документы") = Неопределено тогда
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "Документы";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
			НоваяСтрока.Порядок					= 3;
		КонецЕсли;
	Иначе
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "Документы";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
		НоваяСтрока.Порядок					= 3;
	КонецЕсли;
	
	// ЖурналыДокументов
	ВидыПравДоступа = Новый Массив;
	ВидыПравДоступа.Добавить("Чтение");
	ВидыПравДоступа.Добавить("Просмотр");	
	
	Если типзнч(отбор) = ТипЗнч(Новый Массив) тогда
		Если не отбор.найти("ЖурналыДокументов") = Неопределено тогда	
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "ЖурналыДокументов";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
			НоваяСтрока.Порядок					= 4;
		КонецЕсли;
	иначе
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "ЖурналыДокументов";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
		НоваяСтрока.Порядок					= 4;
	КонецЕсли;
	
	// Отчеты, Обработки
	ВидыПравДоступа = Новый Массив;
	ВидыПравДоступа.Добавить("Использование");
	ВидыПравДоступа.Добавить("Просмотр");	
	
	Если типзнч(отбор) = ТипЗнч(Новый Массив) тогда
		Если не отбор.найти("Отчеты") = Неопределено тогда
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "Отчеты";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
			НоваяСтрока.Порядок					= 5;
		КонецЕсли;
		Если не отбор.найти("Обработки") = Неопределено тогда
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "Обработки";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
			НоваяСтрока.Порядок					= 6; 
		КонецЕсли;
	Иначе
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "Отчеты";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
		НоваяСтрока.Порядок					= 5;
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "Обработки";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
		НоваяСтрока.Порядок					= 6;
	КонецЕсли;
	
	// РегистрыНакопления, РегистрыБухгалтерии
	ВидыПравДоступа = Новый Массив;
	ВидыПравДоступа.Добавить("Чтение");
	ВидыПравДоступа.Добавить("Изменение");
	ВидыПравДоступа.Добавить("Просмотр");	
	ВидыПравДоступа.Добавить("Редактирование");
	ВидыПравДоступа.Добавить("УправлениеИтогами");
	
	Если типзнч(отбор) = ТипЗнч(Новый Массив) тогда
		Если не отбор.найти("РегистрыНакопления") = Неопределено тогда
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "РегистрыНакопления";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
			НоваяСтрока.Порядок					= 11;
		КонецЕсли;	
		Если не отбор.найти("РегистрыБухгалтерии") = Неопределено тогда
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "РегистрыБухгалтерии";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
			НоваяСтрока.Порядок					= 12;
		КонецЕсли;
	иначе
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "РегистрыНакопления";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
		НоваяСтрока.Порядок					= 11;
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "РегистрыБухгалтерии";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;	
		НоваяСтрока.Порядок					= 12;
	КонецЕсли;
	
	// БизнесПроцессы
	ВидыПравДоступа = Новый Массив;
	ВидыПравДоступа.Добавить("Чтение");
	ВидыПравДоступа.Добавить("Добавление");
	ВидыПравДоступа.Добавить("Изменение");
	ВидыПравДоступа.Добавить("Удаление");
	ВидыПравДоступа.Добавить("Просмотр");
	ВидыПравДоступа.Добавить("ИнтерактивноеДобавление");
	ВидыПравДоступа.Добавить("Редактирование");
	ВидыПравДоступа.Добавить("ИнтерактивноеУдаление");
	ВидыПравДоступа.Добавить("ИнтерактивнаяПометкаУдаления");
	ВидыПравДоступа.Добавить("ИнтерактивноеСнятиеПометкиУдаления");
	ВидыПравДоступа.Добавить("ИнтерактивноеУдалениеПомеченных");
	ВидыПравДоступа.Добавить("ВводПоСтроке");
	ВидыПравДоступа.Добавить("ИнтерактивнаяАктивация");
	ВидыПравДоступа.Добавить("Старт");
	ВидыПравДоступа.Добавить("ИнтерактивныйСтарт");
	
	Если типзнч(отбор) = ТипЗнч(Новый Массив) тогда
		Если не отбор.найти("БизнесПроцессы") = Неопределено тогда
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "БизнесПроцессы";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
			НоваяСтрока.Порядок					= 14;
		КонецЕсли;
	иначе
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "БизнесПроцессы";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
		НоваяСтрока.Порядок					= 14;
	КонецЕсли;
	
	// Задачи
	ВидыПравДоступа = Новый Массив;
	ВидыПравДоступа.Добавить("Чтение");
	ВидыПравДоступа.Добавить("Добавление");
	ВидыПравДоступа.Добавить("Изменение");
	ВидыПравДоступа.Добавить("Удаление");
	ВидыПравДоступа.Добавить("Просмотр");
	ВидыПравДоступа.Добавить("ИнтерактивноеДобавление");
	ВидыПравДоступа.Добавить("Редактирование");
	ВидыПравДоступа.Добавить("ИнтерактивноеУдаление");
	ВидыПравДоступа.Добавить("ИнтерактивнаяПометкаУдаления");
	ВидыПравДоступа.Добавить("ИнтерактивноеСнятиеПометкиУдаления");
	ВидыПравДоступа.Добавить("ИнтерактивноеУдалениеПомеченных");
	ВидыПравДоступа.Добавить("ВводПоСтроке");
	ВидыПравДоступа.Добавить("ИнтерактивнаяАктивация");
	ВидыПравДоступа.Добавить("Выполнение");
	ВидыПравДоступа.Добавить("ИнтерактивноеВыполнение");
	
	Если типзнч(отбор) = ТипЗнч(Новый Массив) тогда
		Если не отбор.найти("Задачи") = Неопределено тогда		
			НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
			НоваяСтрока.ТипОбъектовМетаданных	= "Задачи";
			НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
			НоваяСтрока.Порядок					= 15;	
		КонецЕсли;
	иначе
		НоваяСтрока = ТаблицаТиповОбъектов.Добавить();
		НоваяСтрока.ТипОбъектовМетаданных	= "Задачи";
		НоваяСтрока.ВидыПравДоступа			= ВидыПравДоступа;
		НоваяСтрока.Порядок					= 15;
	КонецЕсли;
	
	ТаблицаТиповОбъектов.Сортировать("Порядок");

	// ТаблицаТиповОбъектов.Колонки.Удалить("Порядок");
	
	Возврат ТаблицаТиповОбъектов;
	
КонецФункции

Функция ПолучитьТаблицуПравДоступа(ТипОбъектовМетаданных, ВидыПравДоступа, РольПользователь, ЗаполнитьТолькоУстановленныеПрава = Ложь)
	
	// формирование структуры таблицы прав доступа
	ТаблицаПравДоступа = Новый ТаблицаЗначений;
	ТаблицаПравДоступа.Колонки.Добавить("ТипОбъектаМетаданных");
	ТаблицаПравДоступа.Колонки.Добавить("ОбъектМетаданных");
	Для Каждого ВидПраваДоступа Из ВидыПравДоступа Цикл
		ТаблицаПравДоступа.Колонки.Добавить(ВидПраваДоступа);
	КонецЦикла;	
	
	// заполнение таблицы прав доступа
	Для Каждого ОбъектМетаданных Из Метаданные[ТипОбъектовМетаданных] Цикл
		НоваяСтрока = ТаблицаПравДоступа.Добавить();
		НоваяСтрока.ТипОбъектаМетаданных	= ТипОбъектовМетаданных;
		НоваяСтрока.ОбъектМетаданных		= ОбъектМетаданных.Имя;
		Для Каждого ВидПраваДоступа Из ВидыПравДоступа Цикл
			НоваяСтрока[ВидПраваДоступа] = ПравоДоступа(ВидПраваДоступа, ОбъектМетаданных, РольПользователь);
		КонецЦикла;		
	КонецЦикла;
	
	// добавление колонки ЕстьДоступ (индикатор что установлено хотя бы одно из прав доступа к объекту)
	ТаблицаПравДоступа.Колонки.Добавить("ЕстьДоступ");
	Для Каждого СтрокаТаблицы Из ТаблицаПравДоступа Цикл
		СтрокаТаблицы.ЕстьДоступ = Ложь;
		Для Каждого ВидПраваДоступа Из ВидыПравДоступа Цикл
			Если СтрокаТаблицы[ВидПраваДоступа] Тогда
				// таки какой-то доступ есть
				СтрокаТаблицы.ЕстьДоступ = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;				
	КонецЦикла;	
	
	Если ЗаполнитьТолькоУстановленныеПрава Тогда
		СтруктураПоиска = Новый Структура("ЕстьДоступ", Ложь);
		МассивСтрокКУдаление = ТаблицаПравДоступа.НайтиСтроки(СтруктураПоиска);
		Для Каждого СтрокаКУдалению Из МассивСтрокКУдаление Цикл
			ТаблицаПравДоступа.Удалить(СтрокаКУдалению);
		КонецЦикла;
	КонецЕсли;
	
	// ТаблицаПравДоступа.Колонки.Удалить("ЕстьДоступ");
	
	Возврат ТаблицаПравДоступа;
	
КонецФункции

Процедура КнопкаСформироватьНажатие(Кнопка)
	
	Если ПустаяСтрока(ИмяСубъектаДоступа) Тогда
		Предупреждение("Не заполнен реквизит ""Имя""!");
		Возврат;
	КонецЕсли;
	//Роли = Новый Массив;	
	Попытка
		Если ВыбранныйТипИмени = 1 Тогда
			// роль
			СубъектДоступа = Метаданные.Роли[ИмяСубъектаДоступа];
		Иначе
			// пользователь
			СубъектДоступа = ПользователиИнформационнойБазы.НайтиПоИмени(ИмяСубъектаДоступа);
		КонецЕсли;
	Исключение
		СубъектДоступа = Неопределено;
	КонецПопытки;	
	
	Если СубъектДоступа = Неопределено Тогда
		Предупреждение("Не удалось найти " 
						+ ?(ВыбранныйТипИмени = 1, "роль", "пользователя") 
						+ " с именем """ + ИмяСубъектаДоступа + """!");
		Возврат;
	КонецЕсли;
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Отметка", Истина);
	массивотбора = Новый Массив;
	Для Каждого стр из ТипыОбъектов.НайтиСтроки(ПараметрыОтбора) цикл
		массивотбора.Добавить(стр.ТипОбъекта);
	КонецЦикла;
	ТаблицаТиповОбъектов = ПолучитьТаблицуТиповОбъектов(массивотбора);
	
	Таб = Новый ТабличныйДокумент;
	Макет = ПолучитьМакет("Макет");
	Таб.НачатьАвтогруппировкуСтрок();
	ШапкаОбщиеКолонки	= Макет.ПолучитьОбласть("Шапка|ОбщиеКолонки");
	ШапкаКолонкаПраво	= Макет.ПолучитьОбласть("Шапка|КолонкаПраво");
	группаОбщиеКолонки  = Макет.ПолучитьОбласть("Группа|ОбщиеКолонки");
	СтрокаОбщиеКолонки	= Макет.ПолучитьОбласть("Строка|ОбщиеКолонки");
	СтрокаКолонкаПраво	= Макет.ПолучитьОбласть("Строка|КолонкаПраво");
	ПустаяСтрока		= Макет.ПолучитьОбласть("ПустаяСтрока");
	Роли = Макет.ПолучитьОбласть("Роли");
	
	счСт = 1;
	Таб.Вывести(ПустаяСтрока);
	
	Если ТипЗнч(СубъектДоступа) = ТипЗнч(ПользователиИнформационнойБазы.ТекущийПользователь()) Тогда
		Для Каждого стр из СубъектДоступа.Роли цикл
			роли.Параметры.роль = стр;
			Таб.Вывести(роли);
			счСт = счСт+1;
		КонецЦикла;
	КонецЕсли;	
	
	Таб.Вывести(ПустаяСтрока);
	счСт = счСт+1;
	
	Для Каждого СтрокаТипаОбъектов Из ТаблицаТиповОбъектов Цикл
		счКл = 1;
		ТипОбъектовМетаданных	= СтрокаТипаОбъектов.ТипОбъектовМетаданных;
		ВидыПравДоступа			= СтрокаТипаОбъектов.ВидыПравДоступа;
		
		// получение таблицы прав доступа
		ПраваДоступа = ПолучитьТаблицуПравДоступа(ТипОбъектовМетаданных, ВидыПравДоступа, СубъектДоступа, ВыводитьТолькоУстановленныеПрава);
		Если ПраваДоступа.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		// вывод данных в отчет
		Таб.Вывести(ШапкаОбщиеКолонки, 0, "Шапка", Истина);
		счСт = счСт+1;
		Для Каждого ВидПраваДоступа Из ВидыПравДоступа Цикл
			ШапкаКолонкаПраво.Параметры.ВидПраваДоступа = ВидПраваДоступа;
			Таб.Присоединить(ШапкаКолонкаПраво);
		КонецЦикла;	
        группаОбщиеКолонки.Параметры.ТипОбъектаМетаданных = ТипОбъектовМетаданных;
		Таб.Вывести(группаОбщиеКолонки);
		счСт = счСт+1;
		Для Каждого СтрокаТаблицы Из ПраваДоступа Цикл
			счКл = 1;
			//СтрокаОбщиеКолонки.Параметры.ТипОбъектаМетаданных	= СтрокаТаблицы.ТипОбъектаМетаданных;
			СтрокаОбщиеКолонки.Параметры.ОбъектМетаданных		= СтрокаТаблицы.ОбъектМетаданных;
			Таб.Вывести(СтрокаОбщиеКолонки,1,"Группа",Истина);
			счСт = счСт+1;
			Для Каждого ВидПраваДоступа Из ВидыПравДоступа Цикл
				СтрокаКолонкаПраво.Параметры.Право = СтрокаТаблицы[ВидПраваДоступа];
				Таб.Присоединить(СтрокаКолонкаПраво,1,"Группа",Истина);
				счКл = счКл+1;
				Если СтрокаТаблицы[ВидПраваДоступа] = Истина тогда
					Таб.Область("R"+Формат(счСт, "ЧГ = 99")+"C"+счКл).ЦветТекста = WebЦвета.Красный;
				КонецЕсли;
			КонецЦикла;	
		КонецЦикла;
		
		Таб.Вывести(ПустаяСтрока);
		счСт = счСт+1;
	КонецЦикла;	
	Таб.ЗакончитьАвтогруппировкуСтрок();	
	Таб.Показать(ИмяСубъектаДоступа);
	
КонецПроцедуры

Процедура ЗаполнитьСписокВыбораРолейИлиПользователей()
	
	Если ВыбранныйТипИмени = 1 Тогда
		// роль
		СписокРолейИлиПользователей = Новый СписокЗначений;
		Для Каждого МетаРоль Из Метаданные.Роли Цикл
			СписокРолейИлиПользователей.Добавить(МетаРоль.Имя);
		КонецЦикла;
		
		ТекИмяСубъектаДоступа = ИмяСубъектаДоступа;
	
		ЭлементыФормы.ИмяСубъектаДоступа.СписокВыбора = СписокРолейИлиПользователей;	
				
		Если СписокРолейИлиПользователей.НайтиПоЗначению(ИмяСубъектаДоступа) = Неопределено Тогда
			ИмяСубъектаДоступа = "";
		Иначе
			ИмяСубъектаДоступа = ТекИмяСубъектаДоступа;
		КонецЕсли;
	ИначеЕсли ВыбранныйТипИмени = 2 Тогда
		// пользователь
		Если ТипЗнч(ИмяСубъектаДоступа) = ТипЗнч(Новый СписокЗначений) тогда
			МассивПользователейИБ = ПользователиИнформационнойБазы.ПолучитьПользователей();
			Для Каждого ПользовательИБ Из МассивПользователейИБ Цикл 
				СписокРолейИлиПользователей.Добавить(ПользовательИБ.Имя);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

Процедура ВыбранныйТипИмениПриИзменении(Элемент)
	Если ВыбранныйТипИмени = 1 тогда
		ЭлементыФормы.ИмяСубъектаДоступа.КнопкаВыбора = Ложь;
		ЭлементыФормы.ИмяСубъектаДоступа.КнопкаСпискаВыбора = Истина;
		ИмяСубъектаДоступа = Новый СписокЗначений;
	ИначеЕсли ВыбранныйТипИмени = 2 тогда
		Если Не Метаданные.Справочники.Найти("Пользователи") = Неопределено тогда
			ЭлементыФормы.ИмяСубъектаДоступа.КнопкаВыбора = Истина;
			ЭлементыФормы.ИмяСубъектаДоступа.КнопкаСпискаВыбора = Ложь;
			ИмяСубъектаДоступа = Справочники.Пользователи.ПустаяСсылка();
		иначе
			ЭлементыФормы.ТабличноеПоле1.Видимость = Истина;
			ИмяСубъектаДоступа = Новый СписокЗначений;
		КонецЕсли;
	КонецЕсли;
	ЗаполнитьСписокВыбораРолейИлиПользователей();
	
КонецПроцедуры

Процедура ПриОткрытии()
	Для i = 1 по ПолучитьТаблицуТиповОбъектов().выгрузитьКолонку("ТипОбъектовМетаданных").количество() Цикл
		ТипыОбъектов.Добавить();
	КонецЦикла;
	ТипыОбъектов.ЗагрузитьКолонку(ПолучитьТаблицуТиповОбъектов().выгрузитьКолонку("ТипОбъектовМетаданных"), "ТипОбъекта");
	Для Каждого стр из ТипыОбъектов Цикл 
		Если стр.ТипОбъекта = "Справочники" или стр.ТипОбъекта = "Документы" или стр.ТипОбъекта = "Отчеты" или стр.ТипОбъекта = "Обработки" Тогда
			стр.Отметка = Истина;
		КонецЕсли;
	КонецЦикла;
	ВыбранныйТипИмени = 2;
	ВыбранныйТипИмениПриИзменении(ТекущийЭлемент);
	ЗаполнитьСписокВыбораРолейИлиПользователей();
	ВыводитьТолькоУстановленныеПрава = Истина;
КонецПроцедуры

Процедура ИмяСубъектаДоступаНачалоВыбора(Элемент, СтандартнаяОбработка)
	ИмяСубъектаДоступа = Справочники.Пользователи.ПолучитьФормуВыбора().ОткрытьМодально();
КонецПроцедуры
