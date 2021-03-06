﻿
&НаКлиенте
Процедура Сформировать(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВопросЗавершение", ЭтотОбъект);
	
	ПоказатьВопрос(ОписаниеОповещения, "Изменить параметры", РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗавершение(Ответ, ДопПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
	
		СформироватьНаСервере();
		Состояние("Обработка завершена");
		
	КонецЕсли;	
		
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Заявка", Объект.Заявка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Док.Ссылка
	|ИЗ
	|	Документ.СписаниеБезналичныхДенежныхСредств КАК Док
	|ГДЕ
	|	Док.ЗаявкаНаРасходованиеДенежныхСредств = &Заявка
	|	И Док.Проведен";
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	НачатьТранзакцию();
	
	Для каждого СтрокаТЗ из Таблица Цикл
		
		ДокументОбъект = СтрокаТЗ.Ссылка.ПолучитьОбъект();
		ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		
	КонецЦикла;	
	
	ДокументОбъект = Объект.Заявка.ПолучитьОбъект();
	
	Если Объект.ОтключитьСверхЛимита Тогда
		ДокументОбъект.СверхЛимита = Ложь;
	КонецЕсли;	
	
	Если Объект.УстановитьСтатьюДДС Тогда
		
		Для каждого СтрокаТЧ из ДокументОбъект.РасшифровкаПлатежа Цикл
			СтрокаТЧ.СтатьяДвиженияДенежныхСредств = Объект.СтатьяДДС;
		КонецЦикла;	
		
	КонецЕсли;	
	
	Если Объект.УстановитьПодразделение Тогда
		ДокументОбъект.Подразделение = Объект.Подразделение;
	КонецЕсли;	
	
	Если ДокументОбъект.Проведен Тогда
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Иначе
		ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецЕсли;	
	
	
	Для каждого СтрокаТЗ из Таблица Цикл
		
		ДокументОбъект = СтрокаТЗ.Ссылка.ПолучитьОбъект();
		
		Если Ложь Тогда
			ДокументОбъект = Документы.СписаниеБезналичныхДенежныхСредств.СоздатьДокумент();
		КонецЕсли;	
		
		Если Объект.УстановитьСтатьюДДС Тогда
			
			Для каждого СтрокаТЧ из ДокументОбъект.РасшифровкаПлатежа Цикл
				СтрокаТЧ.СтатьяДвиженияДенежныхСредств = Объект.СтатьяДДС;
			КонецЦикла;	
			
		КонецЕсли;	
		
		Если Объект.УстановитьПодразделение Тогда
			ДокументОбъект.Подразделение = Объект.Подразделение;
		КонецЕсли;
		
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
	КонецЦикла;	
	
	Если Таблица.Количество() > 0 Тогда
		МассивДокументов = Таблица.ВыгрузитьКолонку("Ссылка");
		РеглУчетПроведениеСервер.ОтразитьДокументыВРеглУчете(МассивДокументов);
	КонецЕсли;	
		
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Заявка = Параметры.ОбъектыНазначения[0];

КонецПроцедуры

