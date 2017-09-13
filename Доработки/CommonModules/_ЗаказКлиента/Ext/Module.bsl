﻿
Процедура ПриСозданииНаСервере_ФормаДокумента(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Объект = Форма.Объект;
	
	Группа = Форма.Элементы.Вставить("_ГруппаМест", Тип("ГруппаФормы"), Форма.Элементы.Товары, Форма.Элементы.ТоварыКоличествоУпаковок);
	Группа.Вид          = ВидГруппыФормы.ГруппаКолонок;
	Группа.Заголовок    = "Группа мест";
	Группа.Группировка  = ГруппировкаКолонок.Горизонтальная;
	
	Элемент = Форма.Элементы.Вставить("_КоличествоМест", Тип("ПолеФормы"), Группа, );
    Элемент.Вид         = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "Объект.Товары._КоличествоМест";
	Элемент.Ширина      = 8;
	Элемент.УстановитьДействие("ПриИзменении", "_КоличествоМестПриИзменении");
	
	Элемент = Форма.Элементы.Вставить("_ЕдиницаМест", Тип("ПолеФормы"), Группа, );
   	Элемент.Вид         = ВидПоляФормы.ПолеВвода;
	Элемент.ПутьКДанным = "Объект.Товары._ЕдиницаМест";
	Элемент.Ширина      = 8;
	Элемент.КнопкаВыпадающегоСписка = Ложь;
	Элемент.КнопкаВыбора            = Истина;
	
	Форма.Элементы.Товары.Подвал = Истина;
	Форма.Элементы.ТоварыКоличествоУпаковок.ПутьКДаннымПодвала = "Объект.Товары.ИтогКоличествоУпаковок";
	Форма.Элементы._КоличествоМест.ПутьКДаннымПодвала          = "Объект.Товары.Итог_КоличествоМест";
	
	//Свернуть таблицу
	Команда = Форма.Команды.Добавить("_СвернутьтаблицуТовары");
	Команда.Заголовок = "Свернуть таблицу";
	Команда.ИзменяетСохраняемыеДанные = Истина;
	Команда.Действие  = "_СвернутьтаблицуТовары";
	
	Кнопка = Форма.Элементы.Вставить("_СвернутьтаблицуТовары", Тип("КнопкаФормы"), Форма.Элементы.ТоварыГруппаЗаполнить, );
	Кнопка.ИмяКоманды = "_СвернутьтаблицуТовары";
	
	//Актуализировать по остаткам
	Команда = Форма.Команды.Добавить("_АктуализироватьПоОстаткам");
	Команда.Заголовок = "Актуализировать по остаткам";
	Команда.ИзменяетСохраняемыеДанные = Истина;
	Команда.Действие  = "_АктуализироватьПоОстаткам";
	
	Кнопка = Форма.Элементы.Вставить("_АктуализироватьПоОстаткам", Тип("КнопкаФормы"), Форма.Элементы.ТоварыГруппаЗаполнить, );
	Кнопка.ИмяКоманды = "_АктуализироватьПоОстаткам";
	
	Форма.Элементы.Подразделение.АвтоОтметкаНезаполненного = Истина;
	
	// Строка с оплатами обрезается
	Форма.Элементы.ГруппаЭтапыОплатыРасчеты.Ширина = 80;
	
КонецПроцедуры

Процедура ПриСозданииНаСервере_ФормаСпискаДокументов(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	_ОбщегоНазначенияДоп.ДобавитьКолонкуЕстьФайлы(Форма, "Список", "ДокументЗаказКлиента", Форма.Элементы.СписокСуммаДокумента);
	
	Форма.Элементы.Список.ПоложениеСтрокиПоиска = ПоложениеСтрокиПоиска.Нет;
	
КонецПроцедуры

Функция ПолучитьЕдиницуМест(Ссылка, КодСтроки) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Ссылка",    Ссылка);
	Запрос.Параметры.Вставить("КодСтроки", КодСтроки);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док._ЕдиницаМест
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК Док
	|ГДЕ
	|	Док.Ссылка = &Ссылка
	|	И Док.КодСтроки = &КодСтроки";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
		Возврат Результат.Выгрузить()[0][0];
	КонецЕсли;	
	
КонецФункции	

Процедура СвернутьтаблицуТовары(Объект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Товары", Объект.Товары.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таб.НомерСтроки,
	|	Таб.ДатаОтгрузки,
	|	Таб.Номенклатура,
	|	Таб.Характеристика,
	|	Таб.Упаковка,
	|	Таб.ВидЦены,
	|	Таб.Цена,
	|	Таб.СтавкаНДС,
	|	Таб.ПроцентРучнойСкидки,
	|	Таб.ПроцентАвтоматическойСкидки,
	|	Таб.ПричинаОтмены,
	|	Таб.Отменено,
	|	Таб.Склад,
	|	Таб.СрокПоставки,
	|	Таб.Содержание,
	|	Таб.СтатусУказанияСерий,
	|	Таб.ВариантОбеспечения,
	|	Таб.Серия,
	|	Таб.НоменклатураНабора,
	|	Таб.ХарактеристикаНабора,
	|	Таб._ЕдиницаМест,
	|	Таб._КоличествоМест КАК _КоличествоМест,
	|	Таб.КоличествоУпаковок КАК КоличествоУпаковок,
	|	Таб.Количество КАК Количество,
	|	Таб.Сумма КАК Сумма,
	|	Таб.СуммаНДС КАК СуммаНДС,
	|	Таб.СуммаСНДС КАК СуммаСНДС,
	|	Таб.СуммаРучнойСкидки КАК СуммаРучнойСкидки,
	|	Таб.СуммаАвтоматическойСкидки КАК СуммаАвтоматическойСкидки,
	|	Таб.КодСтроки КАК КодСтроки,
	|	Таб.КлючСвязи КАК КлючСвязи
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Таб
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таб.ДатаОтгрузки,
	|	Таб.Номенклатура,
	|	Таб.Характеристика,
	|	Таб.Упаковка,
	|	Таб.ВидЦены,
	|	Таб.Цена,
	|	Таб.СтавкаНДС,
	|	Таб.ПроцентРучнойСкидки,
	|	Таб.ПроцентАвтоматическойСкидки,
	|	Таб.ПричинаОтмены,
	|	Таб.Отменено,
	|	Таб.Склад,
	|	Таб.СрокПоставки,
	|	Таб.Содержание,
	|	Таб.СтатусУказанияСерий,
	|	Таб.ВариантОбеспечения,
	|	Таб.Серия,
	|	Таб.НоменклатураНабора,
	|	Таб.ХарактеристикаНабора,
	|	Таб._ЕдиницаМест,
	|	СУММА(Таб._КоличествоМест) КАК _КоличествоМест,
	|	СУММА(Таб.КоличествоУпаковок) КАК КоличествоУпаковок,
	|	СУММА(Таб.Количество) КАК Количество,
	|	СУММА(Таб.Сумма) КАК Сумма,
	|	СУММА(Таб.СуммаНДС) КАК СуммаНДС,
	|	СУММА(Таб.СуммаСНДС) КАК СуммаСНДС,
	|	СУММА(Таб.СуммаРучнойСкидки) КАК СуммаРучнойСкидки,
	|	СУММА(Таб.СуммаАвтоматическойСкидки) КАК СуммаАвтоматическойСкидки,
	|	МИНИМУМ(Таб.КодСтроки) КАК КодСтроки,
	|	МИНИМУМ(Таб.КлючСвязи) КАК КлючСвязи,
	|	МИНИМУМ(Таб.НомерСтроки) КАК НомерСтроки
	|ИЗ
	|	Товары КАК Таб
	|
	|СГРУППИРОВАТЬ ПО
	|	Таб.СтавкаНДС,
	|	Таб.НоменклатураНабора,
	|	Таб.Упаковка,
	|	Таб.Номенклатура,
	|	Таб.ХарактеристикаНабора,
	|	Таб.Характеристика,
	|	Таб.Серия,
	|	Таб.Отменено,
	|	Таб.ДатаОтгрузки,
	|	Таб.Содержание,
	|	Таб._ЕдиницаМест,
	|	Таб.ВидЦены,
	|	Таб.ПричинаОтмены,
	|	Таб.Склад,
	|	Таб.ВариантОбеспечения,
	|	Таб.Цена,
	|	Таб.ПроцентРучнойСкидки,
	|	Таб.ПроцентАвтоматическойСкидки,
	|	Таб.СрокПоставки,
	|	Таб.СтатусУказанияСерий
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Таблица = Запрос.Выполнить().Выгрузить();
	Объект.Товары.Загрузить(Таблица);
	
	Для каждого СтрокаТЧ из Объект.Товары Цикл
		
		КоличествоМест = _ОбщегоНазначенияДоп.ПолучитьКоличествоМест(СтрокаТЧ.Характеристика, СтрокаТЧ.Количество);
		Если ЗначениеЗаполнено(КоличествоМест) Тогда
			СтрокаТЧ._КоличествоМест = КоличествоМест;
		КонецЕсли;	
		
	КонецЦикла;	
	
КонецПроцедуры	

Функция ОстатокОплаты(Заказ) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Заказ", Заказ);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегОстатки.СуммаОстаток
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентами.Остатки(, ЗаказКлиента = &Заказ) КАК РегОстатки";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	Иначе
		Возврат Результат.Выгрузить()[0][0];
	КонецЕсли;	
	
КонецФункции	

Функция ПолучитьПараметрыСтроки(Ссылка, КодСтроки) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Ссылка",    Ссылка);
	Запрос.Параметры.Вставить("КодСтроки", КодСтроки);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док._ЕдиницаМест,
	|	Док._КоличествоМест
	|ИЗ
	|	Документ.ЗаказКлиента.Товары КАК Док
	|ГДЕ
	|	Док.Ссылка = &Ссылка
	|	И Док.КодСтроки = &КодСтроки";
	
	Структура = Новый Структура;
	Структура.Вставить("_ЕдиницаМест");
	Структура.Вставить("_КоличествоМест");
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Структура;
	Иначе
		ЗаполнитьЗначенияСвойств(Структура, Результат.Выгрузить()[0]); 
		Возврат Структура;
	КонецЕсли;	
	
КонецФункции	
