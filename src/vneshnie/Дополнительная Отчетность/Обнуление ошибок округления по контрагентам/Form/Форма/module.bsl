﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Если Не ЗначениеЗаполнено(ДатаОстатков) Тогда Сообщить("Не заполнен реквизит 'Дата остатков'"); Возврат; КонецЕсли;
	Если Не ЗначениеЗаполнено(ПределСуммы) Тогда Сообщить("Не заполнен реквизит 'Предел суммы'"); Возврат; КонецЕсли;
	Если Не ЗначениеЗаполнено(СтатьяДоходовПрочие) Тогда Сообщить("Не заполнен реквизит 'Статья доходов - прочие'"); Возврат; КонецЕсли;
	Если Не ЗначениеЗаполнено(СтатьяЗатратПрочие) Тогда Сообщить("Не заполнен реквизит 'Статья затрат - прочие'"); Возврат; КонецЕсли;
	Если Не ЗначениеЗаполнено(БухгалтерскаяСправка) Тогда Сообщить("Не заполнен реквизит 'Бухгалтерская cправка'"); Возврат; КонецЕсли;
	Если Не КонецДня(ДатаОстатков) = КонецДня(БухгалтерскаяСправка.Дата) Тогда Сообщить("Дата остатков не соответствует дате документа 'Бухгалтерская cправка'"); Возврат; КонецЕсли;
	Если Не Переформировывать и (БухгалтерскаяСправка.Проводки.Количество() > 0) Тогда Сообщить("Указанная бухгалтерская cправка уже заполнена"); Возврат; КонецЕсли;
	лОбъектБухгалтерскаяСправка = БухгалтерскаяСправка.ПолучитьОбъект();
	лОбъектБухгалтерскаяСправка.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	Если (лОбъектБухгалтерскаяСправка.Проводки.Количество() > 0) Тогда
		лОбъектБухгалтерскаяСправка.Проводки.Очистить();
	КонецЕсли;
	
	лСписокСчетов = Новый СписокЗначений;
	Для каждого лСтрока Из СписокСчетов Цикл
		Если Не лСтрока.Обнулять Тогда Продолжить; КонецЕсли;
		лСписокСчетов.Добавить( лСтрока.Счет );
	КонецЦикла;
	
	лЗапрос = Новый Запрос;
	лЗапрос.УстановитьПараметр("Дата",  КонецДня(ДатаОстатков) );
	лЗапрос.УстановитьПараметр("ПределСуммы", ПределСуммы);
	лЗапрос.УстановитьПараметр("СтатьяДоходовПрочие", СтатьяДоходовПрочие);
	лЗапрос.УстановитьПараметр("СтатьяЗатратПрочие", СтатьяЗатратПрочие);
	лЗапрос.УстановитьПараметр("СписокСчетов", лСписокСчетов);
	лЗапрос.Текст =
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Активный,
	|	Рег.Счет.Валютный КАК Валютный,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.Счет
	|		ИНАЧЕ ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДругиеЗатратыОперационнойДеятельности)
	|	КОНЕЦ КАК СчетДт,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.НалоговоеНазначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность)
	|	КОНЕЦ КАК НалоговоеНазначениеДт,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.Субконто1
	|		ИНАЧЕ &СтатьяЗатратПрочие
	|	КОНЕЦ КАК СубконтоДт1,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.Субконто2
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК СубконтоДт2,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.Субконто3
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК СубконтоДт3,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ДругиеДоходыОтОперационнойДеятельности)
	|		ИНАЧЕ Рег.Счет
	|	КОНЕЦ КАК СчетКт,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.НалоговыеНазначенияАктивовИЗатрат.НКУ_НеХозДеятельность)
	|		ИНАЧЕ Рег.НалоговоеНазначение
	|	КОНЕЦ КАК НалоговоеНазначениеКт,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА &СтатьяДоходовПрочие
	|		ИНАЧЕ Рег.Субконто1
	|	КОНЕЦ КАК СубконтоКт1,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА NULL
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
	|		ИНАЧЕ Рег.СуммаОстаток
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.СуммаНУОстатокКт
	|		ИНАЧЕ Рег.СуммаНУОстаток
	|	КОНЕЦ КАК СуммаНУ,
	|	Рег.Валюта КАК Валюта,
	|	ВЫБОР
	|		КОГДА Рег.Счет.Вид = ЗНАЧЕНИЕ(ВидСчета.Пассивный)
	|			ТОГДА Рег.КоличествоОстатокКт
	|		ИНАЧЕ Рег.КоличествоОстаток
	|	КОНЕЦ КАК Количество
	|ПОМЕСТИТЬ Остатки
	|ИЗ
	|	РегистрБухгалтерии.Хозрасчетный.Остатки(&Дата, Счет В (&СписокСчетов), , ) КАК Рег
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
	|		КОГДА Остатки.СчетДт.Валютный
	|			ТОГДА Остатки.Валюта
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК ВалютаДт,
	|	ВЫБОР
	|		КОГДА Остатки.СчетДт.НалоговыйУчет
	|				И Остатки.СчетДт.УчетПоНалоговымНазначениямНДС
	|			ТОГДА Остатки.НалоговоеНазначениеДт
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
	|		КОГДА Остатки.СчетКт.Валютный
	|			ТОГДА Остатки.Валюта
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК ВалютаКт,
	|	ВЫБОР
	|		КОГДА Остатки.СчетКт.НалоговыйУчет
	|				И Остатки.СчетКт.УчетПоНалоговымНазначениямНДС
	|			ТОГДА Остатки.НалоговоеНазначениеКт
	|		ИНАЧЕ NULL
	|	КОНЕЦ КАК НалоговоеНазначениеКт,
	|	Остатки.Сумма,
	|	Остатки.СуммаНУ
	|ИЗ
	|	Остатки КАК Остатки
	|ГДЕ
	|	(ИСТИНА
	|				И Остатки.Сумма <= &ПределСуммы
	|				И Остатки.Сумма >= -&ПределСуммы
	|				И НЕ Остатки.Сумма = 0
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
	лОбъектБухгалтерскаяСправка.Проводки.Загрузить( лтзРез );
	лОбъектБухгалтерскаяСправка.Записать(РежимЗаписиДокумента.Проведение);
КонецПроцедуры

Процедура ПриОткрытии()
	Если СписокСчетов.Количество()=0 Тогда
		лтзСписок = СписокСчетов.Выгрузить();
		лНоваяСтрока = лтзСписок.Добавить(); лНоваяСтрока.Счет = ПланыСчетов.Хозрасчетный.РасчетыСОтечественнымиПокупателями;				// 361
		лНоваяСтрока = лтзСписок.Добавить(); лНоваяСтрока.Счет = ПланыСчетов.Хозрасчетный.РасчетыСИностраннымиПокупателями;					// 362
		лНоваяСтрока = лтзСписок.Добавить(); лНоваяСтрока.Счет = ПланыСчетов.Хозрасчетный.РасчетыПоАвансамПолученнымВНациональнойВалюте;	// 6811
		лНоваяСтрока = лтзСписок.Добавить(); лНоваяСтрока.Счет = ПланыСчетов.Хозрасчетный.РасчетыПоАвансамПолученнымВИностраннойВалюте;		// 6812
	
		лНоваяСтрока = лтзСписок.Добавить(); лНоваяСтрока.Счет = ПланыСчетов.Хозрасчетный.РасчетыПоВыданнымАвансамВНациональнойВалюте;		// 3711
		лНоваяСтрока = лтзСписок.Добавить(); лНоваяСтрока.Счет = ПланыСчетов.Хозрасчетный.РасчетыСОтечественнымиПоставщиками;				// 631
	
		лНоваяСтрока = лтзСписок.Добавить(); лНоваяСтрока.Счет = ПланыСчетов.Хозрасчетный.НалоговыеОбязательства;							// 6431
		лНоваяСтрока = лтзСписок.Добавить(); лНоваяСтрока.Счет = ПланыСчетов.Хозрасчетный.НалоговыеОбязательстваНеподтвержденные;			// 6432
		лНоваяСтрока = лтзСписок.Добавить(); лНоваяСтрока.Счет = ПланыСчетов.Хозрасчетный.КорректировкиНалоговыхОбязательств;				// 6433
		лНоваяСтрока = лтзСписок.Добавить(); лНоваяСтрока.Счет = ПланыСчетов.Хозрасчетный.НалоговыйКредит;									// 6441
		лНоваяСтрока = лтзСписок.Добавить(); лНоваяСтрока.Счет = ПланыСчетов.Хозрасчетный.НалоговыйКредитНеподтвержденный;					// 6442
		
		лтзСписок.ЗаполнитьЗначения(Истина, "Обнулять");
		СписокСчетов.Загрузить( лтзСписок );
	КонецЕсли;
КонецПроцедуры
