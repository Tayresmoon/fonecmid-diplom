﻿#language: ru

@tree

Функционал: Массовое создание актов от имени Бухгалтера

Как Бухгалтера я хочу
Начать массовое создание актов 
чтобы оформить месячную оплату абонентского обслуживания   

Контекст:
Дано  Я подключаю  TestClient "Тестовый клиент" логин "Бухгалтер" пароль ""

Сценарий: <описание сценария>
И В командном интерфейсе я выбираю 'Обслуживание клиентов' 'Массовое создание актов'
Тогда открылось окно 'Массовое создание актов'
И в поле с именем 'Период' я ввожу текст '31.01.2024'
И я нажимаю на кнопку с именем 'ЗаполнитьПоДоговорам'
Тогда открылось окно '1С:Предприятие'
И я нажимаю на кнопку с именем 'Button0'
Тогда открылось окно 'Массовое создание актов'
И Я закрываю окно 'Массовое создание актов'
