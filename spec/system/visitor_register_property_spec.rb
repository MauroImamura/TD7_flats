require 'rails_helper'

describe 'Visitor register property' do
    it 'successfully' do
        PropertyType.create!(title: 'Casa')
        PropertyLocation.create!(title: 'Litoral SC')
        property_owner = PropertyOwner.create!(email: 'ousuario@mail.com.br', password: '123456')

        login_as property_owner, scope: :property_owner
        visit root_path
        click_on 'Cadastrar imóvel'
        fill_in 'Título', with: 'Casa em Florianópolis'
        fill_in 'Descrição', with: 'Ótima casa próxima a UFSC'
        fill_in 'Quartos', with: '3'
        fill_in 'Banheiros', with: '2'
        fill_in 'Diária', with: 200
        check 'Aceita Pets'
        check 'Vaga de estacionamento'
        select 'Casa', from: 'Tipo'
        select 'Litoral SC', from: 'Região'
        click_on 'Enviar'

        expect(page).to have_content('Casa em Florianópolis')
        expect(page).to have_content('Ótima casa próxima a UFSC')
        expect(page).to have_content('Quartos: 3')
        expect(page).to have_content('Banheiros: 2')
        expect(page).to have_content('Aceita Pets: Sim')
        expect(page).to have_content('Estacionamento: Sim')
        expect(page).to have_content('Diária: R$ 200,00')
        expect(page).to have_content('Casa')
        expect(page).to have_content('Litoral SC')
        expect(page).to have_content('Imóvel de: ousuario@mail.com.br')
    end

    it 'but decide to return to home instead' do
        property_owner = PropertyOwner.create!(email: 'ousuario@mail.com.br', password: '123456')

        login_as property_owner, scope: :property_owner
        visit root_path
        click_on 'Cadastrar imóvel'
        click_on 'Início'

        expect(current_path).to eq root_path
    end

    it 'and try to register property without information and do not succed' do
        PropertyType.create!(title: 'Casa')
        PropertyLocation.create!(title: 'Litoral SC')
        property_owner = PropertyOwner.create!(email: 'ousuario@mail.com.br', password: '123456')

        login_as property_owner, scope: :property_owner
        visit root_path
        click_on 'Cadastrar imóvel'
        select 'Casa', from: 'Tipo'
        select 'Litoral SC', from: 'Região'
        click_on 'Enviar'

        expect(page).to have_content('Não foi possível cadastrar')
        expect(page).to have_content('Título não pode ficar em branco')
        expect(page).to have_content('Descrição não pode ficar em branco')
        expect(page).to have_content('Quartos não pode ficar em branco')
        expect(page).to have_content('Banheiros não pode ficar em branco')
        expect(page).to have_content('Diária não pode ficar em branco')
    end
end
