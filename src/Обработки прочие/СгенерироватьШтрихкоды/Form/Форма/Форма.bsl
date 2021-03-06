﻿
&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Номенклатура", Номенклатура);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика,
	|	ШтрихкодыНоменклатуры.Штрихкод
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|		ПО (ШтрихкодыНоменклатуры.Характеристика = ХарактеристикиНоменклатуры.Ссылка)
	|			И (ШтрихкодыНоменклатуры.Номенклатура = &Номенклатура)
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Владелец = &Номенклатура";
	
	ТаблицаДанных.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	Для каждого СтрокаТЗ из ТаблицаДанных Цикл
		
		Если ЗначениеЗаполнено(СтрокатЗ.Штрихкод) Тогда
			Продолжить;
		КонецЕсли;	
		
		СтрокаТЗ.Штрихкод = РегистрыСведений.ШтрихкодыНоменклатуры.СформироватьШтрихкодEAN13();
		
		Запись = РегистрыСведений.ШтрихкодыНоменклатуры.СоздатьМенеджерЗаписи();
		Запись.Номенклатура   = Номенклатура;
		Запись.Характеристика = СтрокаТЗ.Характеристика;
		Запись.Штрихкод       = СтрокаТЗ.Штрихкод;
		Запись.Записать();
		
	КонецЦикла;	
	
КонецПроцедуры
