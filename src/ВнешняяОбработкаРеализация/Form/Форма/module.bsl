﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	Если Не ЗначениеЗаполнено(Документ) Тогда Сообщить("Не указан документ!"); КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Документ", Документ);
	Запрос.Текст ="ВЫБРАТЬ
	                |	РеализацияТоваровУслуг.Страна,
	                |	РеализацияТоваровУслуг.Теплоход,
	                |	РеализацияТоваровУслуг.НомерГТД,
	                |	РеализацияТоваровУслуг.ДатаГТД,
	                |	РеализацияТоваровУслуг.ДатаПересеченияТамТеритории,
	                |	РеализацияТоваровУслуг.ПереходПраваСобственности,
	                |	РеализацияТоваровУслуг.ДатаКоносамента
	                |ИЗ
	                |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	                |ГДЕ
	                |	РеализацияТоваровУслуг.Ссылка = &Документ";
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий()  Цикл
		
	Страна=Выборка.Страна;
	Теплоход=Выборка.Теплоход ;
	НомерГТД=Выборка.НомерГТД;
	ДатаГТД=Выборка.ДатаГТД;
	ДатаПересеченияТамТеритории=Выборка.ДатаПересеченияТамТеритории;
	ПереходПраваСобственности=Выборка.ПереходПраваСобственности;
	ДатаКоносамента=Выборка.ДатаКоносамента;

	КонецЦикла;	
			
КонецПроцедуры

Процедура ОсновныеДействияФормыЗаписать(Кнопка)
	лОбъект = Документ.ПолучитьОбъект();
	лОбъект.ДатаГТД = ДатаГТД;
	лОбъект.Страна = Страна;
	лОбъект.Теплоход = Теплоход;
	лОбъект.НомерГТД = НомерГТД;
	лОбъект.ДатаГТД = ДатаГТД;
	лОбъект.ДатаПересеченияТамТеритории = ДатаПересеченияТамТеритории;
	лОбъект.ПереходПраваСобственности = ПереходПраваСобственности;
	лОбъект.ДатаКоносамента = ДатаКоносамента;
	
	лОбъект.ОбменДанными.Загрузка = Истина;
	лОбъект.Записать( РежимЗаписиДокумента.Запись );
	
КонецПроцедуры

Процедура ДокументПриИзменении(Элемент)
	КнопкаВыполнитьНажатие( Элемент );
КонецПроцедуры

Процедура ПриОткрытии()
	КнопкаВыполнитьНажатие( "" );
КонецПроцедуры
