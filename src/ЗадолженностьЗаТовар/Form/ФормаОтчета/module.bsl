﻿// УстановитьОтбор
//
Процедура УстановитьОтбор(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра, ВидСравнения)
	ЭлементОтбора = КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПараметра);
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	ЭлементОтбора.ПравоеЗначение = ЗначениеПараметра;	
	ЭлементОтбора.ВидСравнения = ВидСравнения;
	ЭлементОтбора.Использование = ЗначениеЗаполнено(ЗначениеПараметра);
КонецПроцедуры

// УстановитьПараметр
//
Процедура УстановитьПараметр(КомпоновщикНастроек, ИмяПараметра, ЗначениеПараметра)
	ПараметрДанныхТекущий = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	ПараметрДанныхТекущий.Значение = ЗначениеПараметра;
	ПараметрДанныхТекущий.Использование = ЗначениеЗаполнено(ЗначениеПараметра);
КонецПроцедуры

Процедура УстановитьПараметрыОтборы()
	УстановитьПараметр(КомпоновщикНастроек, "НаДату", НаДату );
	УстановитьПараметр(КомпоновщикНастроек, "СвойствоКурс", ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию("07. курс USD/грн") );
	УстановитьПараметр(КомпоновщикНастроек, "Серна", глЗначениеПеременной("ОсновнаяОрганизация") );
КонецПроцедуры

Процедура ПриОткрытии()
	Если Не ЗначениеЗаполнено(НаДату) Тогда НаДату = ТекущаяДата(); КонецЕсли;
	УстановитьПараметрыОтборы();
КонецПроцедуры

Процедура НаДатуПриИзменении(Элемент)
	Если Не ЗначениеЗаполнено(НаДату) Тогда НаДату = ТекущаяДата(); КонецЕсли;
	УстановитьПараметрыОтборы();
КонецПроцедуры
