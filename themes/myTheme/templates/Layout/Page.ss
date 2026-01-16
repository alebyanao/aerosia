<!-- section carausel -->
<section class="container my-4">
	<div
		id="tokopediaCarousel"
		class="carousel slide rounded-carousel overflow-hidden shadow-sm"
		data-bs-ride="carousel"
	>

		<!-- Slides -->
		<div class="carousel-inner">
			<% loop CarouselImage %>
			<div class="carousel-item active">
				<img
					src="$image.URL"
					class="d-block w-100 img-fluid carousel-img"
					alt="$Name"
				/>
			</div>
			<% end_loop %>
		</div>

		<!-- Controls -->
		<button
			class="carousel-control-prev"
			type="button"
			data-bs-target="#tokopediaCarousel"
			data-bs-slide="prev"
		>
			<span class="carousel-control-prev-icon"></span>
			<span class="visually-hidden">Previous</span>
		</button>

		<button
			class="carousel-control-next"
			type="button"
			data-bs-target="#tokopediaCarousel"
			data-bs-slide="next"
		>
			<span class="carousel-control-next-icon"></span>
			<span class="visually-hidden">Next</span>
		</button>

	</div>
</section>
<style>
.rounded-carousel {
	border-radius: 32px; /* sudut melengkung halus */
}

.carousel-img {
	max-height: 600px;
	object-fit: cover;
}
</style>