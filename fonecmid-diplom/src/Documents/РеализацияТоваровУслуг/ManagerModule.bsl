
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.РеализацияТоваровУслуг) Тогда
		
        КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
        КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.РеализацияТоваровУслуг.ПолноеИмя();
        КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(Метаданные.Документы.РеализацияТоваровУслуг);
        КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;

	Возврат Неопределено;
	
КонецФункции

Процедура ПриОпределенииНастроекПечати(НастройкиОбъекта) Экспорт	
	НастройкиОбъекта.ПриДобавленииКомандПечати = Истина;
КонецПроцедуры

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	//<<KoshAU Создание команды печати Акта выполненых работ
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Акт";
	КомандаПечати.Представление = НСтр("ru = 'Акт выполненных работ'");
		
	//>>
КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
    //<<KoshAU Создание команды печати Акта выполненых работ
	
	ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "Акт");
	Если ПечатнаяФорма <> Неопределено Тогда
		ПечатнаяФорма.ТабличныйДокумент = ПечатьАкта(МассивОбъектов, ОбъектыПечати);
		ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Акт'");
		ПечатнаяФорма.ПолныйПутьКМакету = "Документ.РеализацияТоваровУслуг.ПФ_MXL_ВКМ_АктВыполненияРабот";
	КонецЕсли;
	
    //>>
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПечатьАкта(МассивОбъектов, ОбъектыПечати)
	 //<<KoshAU Формирование данных для макета Акта выполненых работ

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Акт";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РеализацияТоваровУслуг.ПФ_MXL_ВКМ_АктВыполненияРабот");

	ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);

	ПервыйДокумент = Истина;

	Пока ДанныеДокументов.Следующий() Цикл

		Если Не ПервыйДокумент Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ПервыйДокумент = Ложь;

		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

		ВывестиЗаголовокАкта(ДанныеДокументов, ТабличныйДокумент, Макет);

		ВывестиДанныеЗаказчика(ДанныеДокументов, ТабличныйДокумент, Макет);

		ВывестиНоменклатуру(ДанныеДокументов, ТабличныйДокумент, Макет); 
		
		ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
        ТабличныйДокумент.Вывести(ОбластьПодвал);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати,ДанныеДокументов.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;
	
    //>>
КонецФункции

Функция ПолучитьДанныеДокументов(МассивОбъектов)
	//<<KoshAU Формирование данных для макета Акта выполненых работ
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка КАК Ссылка,
	|	РеализацияТоваровУслуг.Номер КАК Номер,
	|	РеализацияТоваровУслуг.Дата КАК Дата,
	|	РеализацияТоваровУслуг.Организация КАК Организация,
	|	ПРЕДСТАВЛЕНИЕ(РеализацияТоваровУслуг.Организация) КАК ОрганизацияПредставление,
	|	РеализацияТоваровУслуг.Контрагент КАК Контрагент,
	|	ПРЕДСТАВЛЕНИЕ(РеализацияТоваровУслуг.Контрагент) КАК КонтрагентПредставление,
	|	РеализацияТоваровУслуг.Договор КАК Договор,
	|	ПРЕДСТАВЛЕНИЕ(РеализацияТоваровУслуг.Договор) КАК ДоговорПредставление,
	|	РеализацияТоваровУслуг.СуммаДокумента КАК СуммаДокумента,
	|	РеализацияТоваровУслуг.Ответственный КАК Ответственный,
	|	ПРЕДСТАВЛЕНИЕ(РеализацияТоваровУслуг.Ответственный) КАК ОтветственныйПредставление,
	|	РеализацияТоваровУслуг.Товары.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура КАК Номенклатура,
	|		ПРЕДСТАВЛЕНИЕ(Номенклатура) КАК НоменклатураПредставление,
	|		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ПРЕДСТАВЛЕНИЕ(Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
	|		Количество КАК Количество,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма) КАК Товары,
	|	РеализацияТоваровУслуг.Услуги.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура КАК Номенклатура,
	|		ПРЕДСТАВЛЕНИЕ(Номенклатура) КАК НоменклатураПредставление,
	|		Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		ПРЕДСТАВЛЕНИЕ(Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмеренияПредставление,
	|		Количество КАК Количество,
	|		Цена КАК Цена,
	|		Сумма КАК Сумма) КАК Услуги
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Ссылка В (&МассивОбъектов)";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Возврат Запрос.Выполнить().Выбрать();
	
	//>>
КонецФункции 

Процедура ВывестиЗаголовокАкта(ДанныеДокументов, ТабличныйДокумент, Макет)
	//<<KoshAU Формирование шапки макета Акта выполненых работ
	
	ОбластьЗаголовокДокумента = Макет.ПолучитьОбласть("Заголовок");
	
	ДанныеПечати = Новый Структура;
	
	ШаблонЗаголовка = "Акт %1 от %2";
	ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка,
		ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер),
		Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
	ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
	
	ОбластьЗаголовокДокумента.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьЗаголовокДокумента);
	
	//>>
КонецПроцедуры

Процедура ВывестиДанныеЗаказчика(ДанныеДокументов, ТабличныйДокумент, Макет)
	//<<KoshAU Формирование данных заказчика макета Акта выполненых работ
	
	ОбластьОрганизацияКонтрагент = Макет.ПолучитьОбласть("ДанныеЗаказчика");
	
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("Контрагент", ДанныеДокументов.КонтрагентПредставление);
	ДанныеПечати.Вставить("Договор", ДанныеДокументов.ДоговорПредставление);
	ДанныеПечати.Вставить("Организация", ДанныеДокументов.ОрганизацияПредставление);
	
	ОбластьОрганизацияКонтрагент.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьОрганизацияКонтрагент);
	
	//>>
КонецПроцедуры 

Процедура ВывестиНоменклатуру(ДанныеДокументов, ТабличныйДокумент, Макет)
	//<<KoshAU Формирование таблицы макета Акта выполненых работ
	
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьНоменклатура = Макет.ПолучитьОбласть("Номенклатура");
	ОбластьИтого = Макет.ПолучитьОбласть("Итого");
	
	ТабличныйДокумент.Вывести(ОбластьШапкаТаблицы);
	
	ВыборкаТовары = ДанныеДокументов.Товары.Выбрать();
	Пока ВыборкаТовары.Следующий() Цикл
		ОбластьНоменклатура.Параметры.Заполнить(ВыборкаТовары);
		ТабличныйДокумент.Вывести(ОбластьНоменклатура);
	КонецЦикла;
	
	ВыборкаУслуги = ДанныеДокументов.Услуги.Выбрать();
	Пока ВыборкаУслуги.Следующий() Цикл
		ОбластьНоменклатура.Параметры.Заполнить(ВыборкаУслуги);
		ТабличныйДокумент.Вывести(ОбластьНоменклатура);
	КонецЦикла;
		
	ДанныеПечати = Новый Структура;
	ДанныеПечати.Вставить("Итого", ДанныеДокументов.СуммаДокумента);
	
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета = "рубль, рубля, рублей, м, копейка, копейки, копеек, ж, 2";
	ОбластьИтого.Параметры.ИтогоПрописью = ЧислоПрописью(ДанныеДокументов.СуммаДокумента,ФормСтрока, ПарПредмета);
	ОбластьИтого.Параметры.Заполнить(ДанныеПечати);
	ТабличныйДокумент.Вывести(ОбластьИтого);
	
	//>>
КонецПроцедуры

#КонецОбласти

#КонецЕсли






















