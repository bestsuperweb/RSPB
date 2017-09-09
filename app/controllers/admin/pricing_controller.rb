class Admin::PricingController < ApplicationController
    layout 'admin'

    def index

        @products = [
            {
                "title" => "Clipping path",
                "handle" => "clipping-path",
                "variants" => [
                    {
                        "name" => "Category 1",
                        "handle" => "c1",
                        "variant_price" => "0.49"
                    },
                    {
                        "name" => "Category 2",
                        "handle" => "c2",
                        "variant_price" => "0.89"
                    },
                    {
                        "name" => "Category 3",
                        "handle" => "c3",
                        "variant_price" => "1.59"
                    },
                    {
                        "name" => "Category 4",
                        "handle" => "c4",
                        "variant_price" => "3.99"
                    },
                    {
                        "name" => "Category 5",
                        "handle" => "c5",
                        "variant_price" => "7.99"
                    },
                    {
                        "name" => "Category 6",
                        "handle" => "c6",
                        "variant_price" => "11.99"
                    }
                ]
            },
            {
                "title" => "Shadow effect",
                "handle" => "shadow-effect",
                "variants" => [
                    {
                        "name" => "Drop shadow category 1",
                        "handle" => "c1",
                        "variant_price" => "0.25"
                    },
                    {
                        "name" => "Drop shadow category 2",
                        "handle" => "c2",
                        "variant_price" => "0.25"
                    },
                    {
                        "name" => "Drop shadow category 3",
                        "handle" => "c3",
                        "variant_price" => "1.25"
                    },
                    {
                        "name" => "Existing shadow",
                        "handle" => "c4",
                        "variant_price" => "0.79"
                    },
                    {
                        "name" => "Natural shadow category 1",
                        "handle" => "c5",
                        "variant_price" => "0.79"
                    },
                    {
                        "name" => "Natural shadow category 2",
                        "handle" => "c6",
                        "variant_price" => "1.49"
                    },
                    {
                        "name" => "Natural shadow category 3",
                        "handle" => "c6",
                        "variant_price" => "3.49"
                    },
                    {
                        "name" => "Floating shadow",
                        "handle" => "c6",
                        "variant_price" => "0.25"
                    },
                    {
                        "name" => "Mirror effect category 1",
                        "handle" => "c6",
                        "variant_price" => "0.49"
                    },
                    {
                        "name" => "Mirror effect category 2",
                        "handle" => "c6",
                        "variant_price" => "1.49"
                    },
                    {
                        "name" => "Mirror effect category 3",
                        "handle" => "c6",
                        "variant_price" => "3.49"
                    }
                ]
            }
        ]

        @turnarounds = Turnaround.all
        @volume_discounts = VolumeDiscount.all

        #render layout: true
    end

end
