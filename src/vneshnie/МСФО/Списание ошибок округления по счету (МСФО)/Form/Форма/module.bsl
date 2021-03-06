﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Если Не ЗначениеЗаполнено(ДатаОстатков) Тогда Сообщить("Не заполнен реквизит 'Дата остатков'"); Возврат; КонецЕсли;
	Если Не ЗначениеЗаполнено(ПределСуммы) Тогда Сообщить("Не заполнен реквизит 'Предел суммы'"); Возврат; КонецЕсли;
	Если Не ЗначениеЗаполнено(СтатьяДоходовПрочие) Тогда Сообщить("Не заполнен реквизит 'Статья доходов - прочие'"); Возврат; КонецЕсли;
	Если Не ЗначениеЗаполнено(СтатьяЗатратПрочие) Тогда Сообщить("Не заполнен реквизит 'Статья затрат - прочие'"); Возврат; КонецЕсли;
	Если Не ЗначениеЗаполнено(СчетМСФО) Тогда Сообщить("Не заполнен реквизит 'Счет МСФО'"); Возврат; КонецЕсли;
	Если Не Переформировывать и (БухгалтерскаяСправка.Проводки.Количество() > 0) Тогда Сообщить("Указанная бухгалтерская cправка уже заполнена"); Возврат; КонецЕсли;
	
	Если Не ЗначениеЗаполнено(БухгалтерскаяСправка) Тогда
		// Надо создать бух.справку
		лБухСправка = Документы.БухгалтерскаяСправка.СоздатьДокумент();
		лБухСправка.Дата = КонецДня(ДатаОстатков) - 600;
		лБухСправка.Организация = глЗначениеПеременной("ОсновнаяОрганизация");
		лБухСправка.БИТ_МСФО_ПланСчетов = Справочники.БИТ_МСФО_ПланыСчетов.Международный;
		лБухСправка.Ответственный = ОбщегоНазначения.ПолучитьЗначениеПеременной("глТекущийПользователь");
		лБухСправка.Редактировавший = ОбщегоНазначения.ПолучитьЗначениеПеременной("глТекущийПользователь");
		лБухСправка.Комментарий = "Списание ошибок округления по счету МСФО - " + СчетМСФО.Код;
		лБухСправка.НеПереформировыватьМСФО = Истина;
		лБухСправка.Записать();
		БухгалтерскаяСправка = лБухСправка.Ссылка;
	КонецЕсли;
	
	лОбъектБухгалтерскаяСправка = БухгалтерскаяСправка.ПолучитьОбъект();
	лОбъектБухгалтерскаяСправка.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	Если (лОбъектБухгалтерскаяСправка.Проводки.Количество() > 0) Тогда
		лОбъектБухгалтерскаяСправка.Проводки.Очистить();
	КонецЕсли;
	
	лЗапрос = Новый Запрос;
	лЗапрос.УстановитьПараметр("Дата",  КонецДня(ДатаОстатков) );
	лЗапрос.УстановитьПараметр("ПределСуммы", ПределСуммы);
	лЗапрос.УстановитьПараметр("СтатьяДоходовПрочие", СтатьяДоходовПрочие);
	лЗапрос.УстановитьПараметр("СтатьяЗатратПрочие", СтатьяЗатратПрочие);
	лЗапрос.УстановитьПараметр("Счет744", ПланыСчетов.МСФО.НайтиПоКоду("744") );
	лЗапрос.УстановитьПараметр("Счет974", ПланыСчетов.МСФО.НайтиПоКоду("974") );
	лЗапрос.УстановитьПараметр("СчетМСФО", СчетМСФО);
	лЗапрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Активный,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НКУ_ХозДеятельность)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность)
	|	КОНЕЦ КАК НалоговоеНазначение,
	|	Рег.Валюта,
	|	Рег.Intercompany,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.Счет
	|		ИНАЧЕ &Счет974
	|	КОНЕЦ КАК СчетДт,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.Субконто1
	|		ИНАЧЕ &СтатьяЗатратПрочие
	|	КОНЕЦ КАК СубконтоДт1,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.Субконто2
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.ДляРаспределенияПоКультурам)
	|	КОНЕЦ КАК СубконтоДт2,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.Субконто3
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК СубконтоДт3,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА &Счет744
	|		ИНАЧЕ Рег.Счет
	|	КОНЕЦ КАК СчетКт,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА &СтатьяДоходовПрочие
	|		ИНАЧЕ Рег.Субконто1
	|	КОНЕЦ КАК СубконтоКт1,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.НоменклатурныеГруппы.ДляРаспределенияПоКультурам)
	|		ИНАЧЕ Рег.Субконто2
	|	КОНЕЦ КАК СубконтоКт2,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА NULL
	|		ИНАЧЕ Рег.Субконто3
	|	КОНЕЦ КАК СубконтоКт3,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.СуммаОстатокКт
	|		ИНАЧЕ Рег.СуммаОстатокДт
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.КоличествоОстатокКт
	|		ИНАЧЕ Рег.КоличествоОстатокДт
	|	КОНЕЦ КАК Количество,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.ВалютнаяСуммаОстатокКт
	|		ИНАЧЕ Рег.ВалютнаяСуммаОстатокДт
	|	КОНЕЦ КАК ВалютнаяСумма
	|ПОМЕСТИТЬ Остатки
	|ИЗ
	|	РегистрБухгалтерии.МСФО.Остатки(&Дата, Счет В ИЕРАРХИИ (&СчетМСФО), , ) КАК Рег
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Остатки.СчетДт КАК СчетДт,
	|	Остатки.СубконтоДт1 КАК СубконтоДт1,
	|	Остатки.СубконтоДт2 КАК СубконтоДт2,
	|	Остатки.СубконтоДт3 КАК СубконтоДт3,
	|	ВЫБОР
	|		КОГДА Остатки.СчетДт.Количественный
	|			ТОГДА Остатки.Количество
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК КоличествоДт,
	|	ВЫБОР
	|		КОГДА Остатки.СчетДт.НалоговыйУчет
	|			ТОГДА Остатки.НалоговоеНазначение
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК НалоговоеНазначениеДт,
	|	Остатки.СчетКт КАК СчетКт,
	|	Остатки.СубконтоКт1 КАК СубконтоКт1,
	|	Остатки.СубконтоКт2 КАК СубконтоКт2,
	|	Остатки.СубконтоКт3 КАК СубконтоКт3,
	|	ВЫБОР
	|		КОГДА Остатки.СчетКт.Количественный
	|			ТОГДА Остатки.Количество
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК КоличествоКт,
	|	ВЫБОР
	|		КОГДА Остатки.СчетКт.НалоговыйУчет
	|			ТОГДА Остатки.НалоговоеНазначение
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК НалоговоеНазначениеКт,
	|	ВЫБОР
	|		КОГДА Остатки.СчетДт.Intercompany
	|			ТОГДА Остатки.Intercompany
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК IntercompanyДт,
	|	ВЫБОР
	|		КОГДА Остатки.СчетКт.Intercompany
	|			ТОГДА Остатки.Intercompany
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК IntercompanyКт,
	|	Остатки.Сумма,
	|	Остатки.ВалютнаяСумма КАК ВалютнаяСуммаДт,
	|	Остатки.ВалютнаяСумма КАК ВалютнаяСуммаКт
	|ИЗ
	|	Остатки КАК Остатки
	|ГДЕ
	|	(Остатки.Сумма <= &ПределСуммы
	|				И Остатки.Сумма >= -&ПределСуммы
	|				И НЕ Остатки.Сумма = 0
	|				И Остатки.ВалютнаяСумма = 0
	|			ИЛИ Остатки.Сумма = 0
	|				И НЕ Остатки.Количество = 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	СчетКт,
	|	СубконтоКт1,
	|	СубконтоКт2,
	|	СубконтоКт3,
	|	СчетДт,
	|	СубконтоДт1,
	|	СубконтоДт2,
	|	СубконтоДт3
	|АВТОУПОРЯДОЧИВАНИЕ";
	лтзРез = лЗапрос.Выполнить().Выгрузить();
	лОбъектБухгалтерскаяСправка.ПроводкиМСФО.Загрузить( лтзРез );
	лОбъектБухгалтерскаяСправка.Записать(РежимЗаписиДокумента.Проведение);
КонецПроцедуры
