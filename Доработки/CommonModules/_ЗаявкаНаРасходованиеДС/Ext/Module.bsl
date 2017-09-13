﻿
Процедура ПриСозданииНаСервере_ФормаДокумента(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Объект = Форма.Объект;
	
	Команда = Форма.Команды.Добавить("_ЗаполнитьНазначениеПоСчетам");
	Команда.Заголовок = "По счетам";
	Команда.ИзменяетСохраняемыеДанные = Истина;
	Команда.Действие  = "_ЗаполнитьНазначениеПоСчетам";
	
	//Группа = Форма.Элементы.Вставить("_ГруппаЗаполнить", Тип("ГруппаФормы"), Форма.Элементы.ГруппаНазначениеПлатежа, Форма.Элементы.ЗаполнитьНазначениеПлатежа);
	//Группа.Вид         = ВидГруппыФормы.ОбычнаяГруппа;
	//Группа.Отображение = ОтображениеОбычнойГруппы.Нет;
	//Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	//Группа.ОтображатьЗаголовок = Ложь;
	//
	//Форма.Элементы.Переместить(Форма.Элементы.ВставитьНазначениеПлатежа, Группа);
	
	Кнопка = Форма.Элементы.Вставить("_ЗаполнитьНазначениеПоСчетам", Тип("КнопкаФормы"), Форма.Элементы.ГруппаЗаполнитьНазначение, Форма.Элементы.ЗаполнитьНазначениеПлатежа);
	Кнопка.ИмяКоманды = "_ЗаполнитьНазначениеПоСчетам";
	
	Если Объект.Статус = Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.Согласована
		Или Объект.Статус = Перечисления.СтатусыЗаявокНаРасходованиеДенежныхСредств.КОплате Тогда
		
		ТолькоПросмотрЭлементов = Объект.Проведен;
	Иначе
		ТолькоПросмотрЭлементов = Ложь;
	КонецЕсли;
	
	Кнопка.Доступность = НЕ ТолькоПросмотрЭлементов;
	
	Форма.Элементы.Подразделение.АвтоОтметкаНезаполненного = Истина;
	
КонецПроцедуры

Процедура ПриСозданииНаСервере_ФормаСпискаДокументов(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ТекстЗапроса = Форма.Список.ТекстЗапроса;
	
	СхемаЗапроса = Новый СхемаЗапроса;
    СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапроса);	
	
	ЗапросВыбораСхемыЗапроса = СхемаЗапроса.ПакетЗапросов[0];
	Оператор = ЗапросВыбораСхемыЗапроса.Операторы[0];
	
	Источник = Оператор.Источники.Добавить("Документ.ЗаявкаНаРасходованиеДенежныхСредств.РасшифровкаПлатежа", "ЗаявкаРасшифровкаПлатежа");
	Источник.Соединения.Очистить();
	
	_ОбработчикиПроведенияСервер.ДобавитьУсловиеСоединения(Оператор, "Заявка", "ЗаявкаРасшифровкаПлатежа", "Заявка.Ссылка = ЗаявкаРасшифровкаПлатежа.Ссылка И ЗаявкаРасшифровкаПлатежа.НомерСтроки = 1");
	
	ТекстСтатьяДДС = 
	"ВЫБОР 
	|	КОГДА ЗаявкаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств = ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ПустаяСсылка)
	|		ТОГДА Заявка.СтатьяДвиженияДенежныхСредств
	|	ИНАЧЕ
	|		ЗаявкаРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств
	|КОНЕЦ";
	
	_ОбработчикиПроведенияСервер.ДобавитьПолеВЗапрос(ЗапросВыбораСхемыЗапроса, Оператор, "_СтатьяДДС", ТекстСтатьяДДС);
	_ОбработчикиПроведенияСервер.ДобавитьПолеВЗапрос(ЗапросВыбораСхемыЗапроса, Оператор, "_СчетУчета", "ЗаявкаРасшифровкаПлатежа.СчетУчета");
 
	ТекстЗапроса = СхемаЗапроса.ПолучитьТекстЗапроса();
	Форма.Список.ТекстЗапроса = ТекстЗапроса;
	
	Элемент = Форма.Элементы.Вставить("_СтатьяДДС", Тип("ПолеФормы"), Форма.Элементы.Список,);
    Элемент.Вид         = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "Список._СтатьяДДС";
	
	Элемент = Форма.Элементы.Вставить("_СчетУчета", Тип("ПолеФормы"), Форма.Элементы.Список,);
    Элемент.Вид         = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "Список._СчетУчета";
	
КонецПроцедуры

Процедура ЗаполнитьНазначениеПоСчетам(Форма) Экспорт
	
	Объект = Форма.Объект;
	Объект.НазначениеПлатежа = ПолучитьСписокДокументовДляНазначенияПлатежа(Объект);
	 
КонецПроцедуры	

// Возвращает строку с перечислением документов из расшифровки платежа.
//
// Параметры: Объект - ДокументСсылка - Документ, содержащий расшифровку платежа.
//
// Возвращаемое значение: Строка.
//
Функция ПолучитьСписокДокументовДляНазначенияПлатежа(Объект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РасшифровкаПлатежа = Объект.РасшифровкаПлатежа.Выгрузить(, "Заказ, Сумма, СтавкаНДС, СуммаНДС");
	ТаблицаДокументов = Новый ТаблицаЗначений;
	ТаблицаДокументов.Колонки.Добавить("Документ", Новый ОписаниеТипов(Документы.ТипВсеСсылки(), "СправочникСсылка.ДоговорыКонтрагентов"));
	ТаблицаДокументов.Колонки.Добавить("Сумма", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(15,2)));
	Для Сч = 1 По РасшифровкаПлатежа.Количество() Цикл
		ТаблицаДокументов.Добавить();
	КонецЦикла;
	ТаблицаДокументов.ЗагрузитьКолонку(РасшифровкаПлатежа.ВыгрузитьКолонку("Заказ"), "Документ");
	ТаблицаДокументов.ЗагрузитьКолонку(РасшифровкаПлатежа.ВыгрузитьКолонку("Сумма"), "Сумма");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИсходнаяТаблица.Документ КАК Документ,
	|	ИсходнаяТаблица.Сумма КАК Сумма
	|ПОМЕСТИТЬ ТаблицаДокументов
	|ИЗ
	|	&ТаблицаДокументов КАК ИсходнаяТаблица
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Документ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Документ,
	|	ДанныеДокумента.НомерПоДаннымПоставщика КАК Номер,
	|	ДанныеДокумента.ДатаПоДаннымПоставщика КАК Дата,
	|	СУММА(ТаблицаДокументов.Сумма) КАК Сумма
	|ИЗ
	|	Документ.ЗаказПоставщику КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокументов КАК ТаблицаДокументов
	|		ПО (ТаблицаДокументов.Документ = ДанныеДокумента.Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.НомерПоДаннымПоставщика,
	|	ДанныеДокумента.ДатаПоДаннымПоставщика
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.НомерВходящегоДокумента,
	|	ДанныеДокумента.ДатаВходящегоДокумента,
	|	СУММА(ТаблицаДокументов.Сумма)
	|ИЗ
	|	Документ.ПоступлениеТоваровУслуг КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокументов КАК ТаблицаДокументов
	|		ПО (ТаблицаДокументов.Документ = ДанныеДокумента.Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	ДанныеДокумента.Ссылка,
	|	ДанныеДокумента.НомерВходящегоДокумента,
	|	ДанныеДокумента.ДатаВходящегоДокумента";
	
	Запрос.УстановитьПараметр("ТаблицаДокументов", ТаблицаДокументов);
	Выборка = Запрос.Выполнить().Выбрать();
	СуммаКРаспределению = Объект.РасшифровкаПлатежа.Итог("Сумма");
	ТекстНазначенияПлатежа = "";
	
	//РеквизитыВалюты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Валюта, "Код, Наименование");
	//Если РеквизитыВалюты.Код = "643" Тогда
	//	ВалютаДляПечати = НСтр("ru = 'руб.'");
	//Иначе
	//	ВалютаДляПечати = СокрЛП(РеквизитыВалюты.Наименование);
	//КонецЕсли;
	//
	//Пока Выборка.Следующий() Цикл
	//	ВидДокумента = "счету";
	//	ПредставлениеДляПечати = НСтр("ru = '%Вид% №%Номер% от %Дата% %Заметки%%Сумма% %Валюта%'");
	//	ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Вид%", ВидДокумента);
	//	ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Номер%",	СокрЛП(Выборка.Номер));
	//	ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Дата%", Формат(Выборка.Дата, "ДЛФ=D"));
	//		
	//	Если ЗначениеЗаполнено(Объект.Комментарий) Тогда
	//		ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Заметки%", СокрЛП(Объект.Комментарий) + " ");
	//	Иначе
	//		ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Заметки%", "");
	//	КонецЕсли;	
	//	
	//	ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Сумма%",
	//		Формат(Выборка.Сумма, "ЧЦ=15; ЧДЦ=2; ЧРД=-; ЧН=0-00; ЧГ="));
	//	ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Валюта%", ВалютаДляПечати);
	//	ТекстНазначенияПлатежа = ТекстНазначенияПлатежа + ", " + ПредставлениеДляПечати;
	//	СуммаКРаспределению = СуммаКРаспределению - Выборка.Сумма;
	//КонецЦикла;
	//
	//Если СуммаКРаспределению > 0 Тогда
	//	ТекстНазначенияПлатежа = ТекстНазначенияПлатежа + ", "
	//		+ НСтр("ru = 'без указания назначения'")
	//		+ " " + Формат(СуммаКРаспределению, "ЧЦ=15; ЧДЦ=2; ЧРД=-; ЧН=0-00; ЧГ=")
	//		+ " " + ВалютаДляПечати;
	//КонецЕсли;
	//ТекстНазначенияПлатежа = НСтр("ru = 'Оплата по'") + Сред(ТекстНазначенияПлатежа, 2);
	//Если Прав(ТекстНазначенияПлатежа, 1) <> "." Тогда
	//	ТекстНазначенияПлатежа = ТекстНазначенияПлатежа + ".";
	//КонецЕсли;
	//ДлинаТекстаДокументов = СтрДлина(ТекстНазначенияПлатежа);
	//
	//ТекстСуммаНДС = ДенежныеСредстваСервер.ТекстСуммаНДСПлатежа(
	//	Объект.РасшифровкаПлатежа.Итог("Сумма"),
	//	Объект.Валюта,
	//	Истина);
	//ДлинаТекстаНДС = СтрДлина(ТекстСуммаНДС);
	//
	//Если ДлинаТекстаДокументов + ДлинаТекстаНДС > 210 Тогда
	//	ДлинаТекстаДокументов = 207 - ДлинаТекстаНДС;
	//	ТекстНазначенияПлатежа = Лев(ТекстНазначенияПлатежа, ДлинаТекстаДокументов);
	//	ТекстПоискаПоследнегоДокумента = ТекстНазначенияПлатежа;
	//	ПозицияПоследнейЗапятой = 0;
	//	ПозицияЗапятой = СтрНайти(ТекстПоискаПоследнегоДокумента, ",");
	//	Пока НЕ ПозицияЗапятой = 0 Цикл
	//		ПозицияПоследнейЗапятой = ПозицияПоследнейЗапятой + ПозицияЗапятой;
	//		ТекстПоискаПоследнегоДокумента = Сред(ТекстПоискаПоследнегоДокумента, ПозицияЗапятой + 1);
	//		ПозицияЗапятой = СтрНайти(ТекстПоискаПоследнегоДокумента, ",");
	//	КонецЦикла;
	//	ТекстНазначенияПлатежа = Лев(ТекстНазначенияПлатежа, ПозицияПоследнейЗапятой - 1) + "...";
	//КонецЕсли;
	//ТекстНазначенияПлатежа = СокрЛП(ТекстНазначенияПлатежа) + Символы.ПС + СокрЛП(ТекстСуммаНДС);
	//
	//Если ПривилегированныйРежим() Тогда
	//	УстановитьПривилегированныйРежим(Ложь);
	//КонецЕсли;
	//
	//Возврат ТекстНазначенияПлатежа;
	
	РеквизитыВалюты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Валюта, "Код, Наименование");
	Если РеквизитыВалюты.Код = "643" Тогда
		ВалютаДляПечати = НСтр("ru = 'руб.'");
	Иначе
		ВалютаДляПечати = СокрЛП(РеквизитыВалюты.Наименование);
	КонецЕсли;
	
	Пока Выборка.Следующий() Цикл
		Если ТипЗнч(Выборка.Документ) = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
			ТекстНазначенияПлатежа = ТекстНазначенияПлатежа + ", "
			+ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Документ, "НаименованиеДляПечати")
			+ " " + Формат(Выборка.Сумма, "ЧЦ=15; ЧДЦ=2; ЧРД=-; ЧН=0-00; ЧГ=")
			+ " " + ВалютаДляПечати;
		Иначе
			ВидДокумента = "счету";
			ПредставлениеДляПечати = НСтр("ru = '%Вид% №%Номер% от %Дата% %Заметки%%Сумма% %Валюта%'");
			ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Вид%", ВидДокумента);
			ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Номер%",	СокрЛП(Выборка.Номер));
			ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Дата%", Формат(Выборка.Дата, "ДЛФ=D"));
				
			Если ЗначениеЗаполнено(Объект.Комментарий) Тогда
				ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Заметки%", СокрЛП(Объект.Комментарий) + " ");
			Иначе
				ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Заметки%", "");
			КонецЕсли;
			
			ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Сумма%",
				Формат(Выборка.Сумма, "ЧЦ=15; ЧДЦ=2; ЧРД=-; ЧН=0-00; ЧГ="));
			ПредставлениеДляПечати = СтрЗаменить(ПредставлениеДляПечати, "%Валюта%", ВалютаДляПечати);
			ТекстНазначенияПлатежа = ТекстНазначенияПлатежа + ", " + ПредставлениеДляПечати;
			
		КонецЕсли;
		СуммаКРаспределению = СуммаКРаспределению - Выборка.Сумма;
	КонецЦикла;
	
	Если СуммаКРаспределению > 0 Тогда
		ТекстНазначенияПлатежа = ТекстНазначенияПлатежа + ", "
			+ НСтр("ru = 'без указания назначения'")
			+ " " + Формат(СуммаКРаспределению, "ЧЦ=15; ЧДЦ=2; ЧРД=-; ЧН=0-00; ЧГ=")
			+ " " + ВалютаДляПечати;
	КонецЕсли;
	Если СуммаКРаспределению <= 0 Тогда
		ТекстНазначенияПлатежа = НСтр("ru = 'Оплата по'") + Сред(ТекстНазначенияПлатежа, 2);
	Иначе
		ТекстНазначенияПлатежа = НСтр("ru = 'Оплата'") + Сред(ТекстНазначенияПлатежа, 2);
	КонецЕсли;
	
	Если Прав(ТекстНазначенияПлатежа, 1) <> "." Тогда
		ТекстНазначенияПлатежа = ТекстНазначенияПлатежа + ".";
	КонецЕсли;
	ДлинаТекстаДокументов = СтрДлина(ТекстНазначенияПлатежа);
	
	ТекстСуммаНДС = ДенежныеСредстваСервер.ТекстСуммаНДСПлатежа(
		Объект.Валюта,
		РасшифровкаПлатежа,
		Истина);
	ДлинаТекстаНДС = СтрДлина(ТекстСуммаНДС);
	
	Если ДлинаТекстаДокументов + ДлинаТекстаНДС > 210 Тогда
		ДлинаТекстаДокументов = 207 - ДлинаТекстаНДС;
		ТекстНазначенияПлатежа = Лев(ТекстНазначенияПлатежа, ДлинаТекстаДокументов);
		ТекстПоискаПоследнегоДокумента = ТекстНазначенияПлатежа;
		ПозицияПоследнейЗапятой = 0;
		ПозицияЗапятой = СтрНайти(ТекстПоискаПоследнегоДокумента, ",");
		Пока НЕ ПозицияЗапятой = 0 Цикл
			ПозицияПоследнейЗапятой = ПозицияПоследнейЗапятой + ПозицияЗапятой;
			ТекстПоискаПоследнегоДокумента = Сред(ТекстПоискаПоследнегоДокумента, ПозицияЗапятой + 1);
			ПозицияЗапятой = СтрНайти(ТекстПоискаПоследнегоДокумента, ",");
		КонецЦикла;
		ТекстНазначенияПлатежа = Лев(ТекстНазначенияПлатежа, ПозицияПоследнейЗапятой - 1) + "...";
	КонецЕсли;
	ТекстНазначенияПлатежа = СокрЛП(ТекстНазначенияПлатежа) + Символы.ПС + СокрЛП(ТекстСуммаНДС);
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ТекстНазначенияПлатежа;
	
КонецФункции

Функция ПолучитьСписокСтатейДДС(Ссылка, ВключатьПустую, ВключатьГруппы) Экспорт
	
	СписокСтатейДДС = Новый СписокЗначений;
	Если ВключатьПустую Тогда
		СписокСтатейДДС.Добавить(Справочники.СтатьиДвиженияДенежныхСредств.ПустаяСсылка());
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокРасшифровкаПлатежа.СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств.РасшифровкаПлатежа КАК ДокРасшифровкаПлатежа
	|ГДЕ
	|	ДокРасшифровкаПлатежа.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Док.СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.ЗаявкаНаРасходованиеДенежныхСредств КАК Док
	|ГДЕ
	|	Док.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СписокСтатейДДС.Добавить(Выборка.СтатьяДвиженияДенежныхСредств);
		Если ВключатьГруппы Тогда
			
			Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.СтатьяДвиженияДенежныхСредств, "Родитель");
			Пока ЗначениеЗаполнено(Родитель) Цикл
				
				СписокСтатейДДС.Добавить(Родитель);
				Родитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Родитель, "Родитель");
			
			КонецЦикла;	
			
		КонецЕсли;	
		
	КонецЦикла;	
	
	Возврат СписокСтатейДДС;
	
КонецФункции

Функция ТекстЗапросаПроведение(Запрос, ТекстыЗапроса, Регистры) Экспорт

    ТекстЗапроса_ДвиженияДенежныеСредстваКонтрагент(Запрос, ТекстыЗапроса, Регистры);
    ТекстЗапроса_ДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры);
	
	Возврат "";

КонецФункции

Процедура ТекстЗапроса_ДвиженияДенежныеСредстваКонтрагент(Запрос, ТекстыЗапроса, Регистры) Экспорт

    ЭлементТекстЗапроса = _ОбработчикиПроведенияСервер.НайтиЭлементСписка(ТекстыЗапроса, "ДвиженияДенежныеСредстваКонтрагент");
	Если ЭлементТекстЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
    ТекстЗапроса = ЭлементТекстЗапроса.Значение;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ТаблицаРасшифровкаПлатежа.Заказ.Подразделение",                  "ДанныеДокумента.Подразделение");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ТаблицаРасшифровкаПлатежа.ДоговорКредитаДепозита.Подразделение", "ДанныеДокумента.Подразделение");
	
	ЭлементТекстЗапроса.Значение = ТекстЗапроса;
	Возврат;

КонецПроцедуры

Процедура ТекстЗапроса_ДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры) Экспорт

    ЭлементТекстЗапроса = _ОбработчикиПроведенияСервер.НайтиЭлементСписка(ТекстыЗапроса, "ДвиженияДенежныеСредстваДоходыРасходы");
	Если ЭлементТекстЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ТекстЗапроса = ЭлементТекстЗапроса.Значение;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДанныеДокумента.БанковскийСчет.Подразделение", "ДанныеДокумента.Подразделение");
	
	ЭлементТекстЗапроса.Значение = ТекстЗапроса;
	Возврат;

КонецПроцедуры
