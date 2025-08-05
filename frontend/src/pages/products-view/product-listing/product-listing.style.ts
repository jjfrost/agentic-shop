import styled from 'styled-components';

export const ListingContainer = styled.div`
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
`;

export const InfoMessageContainer = styled.div`
  display: flex;
  align-items: center;
  column-gap: 6px;
  font-size: 14px;
  margin-top: 12px;
  background-color: #e0be4e26;
  padding: 6px;
  border-radius: 25px;
  max-width: 625px;
  border: 1px solid #f5c000;
  color: #b58a00;
`;

export const ProductGrid = styled.div`
  display: grid;
  grid-template-columns: repeat(1, 1fr);
  gap: 2rem;
  max-width: 75rem;
  margin: 0 auto;
  padding: 4rem 1rem;

  @media (min-width: 48rem) {
    /* 768px */
    grid-template-columns: repeat(2, 1fr);
  }

  @media (min-width: 64rem) {
    /* 1024px */
    grid-template-columns: repeat(3, 1fr);
  }

  @media (min-width: 80rem) {
    /* 1280px */
    grid-template-columns: repeat(4, 1fr);
  }
`;

export const LoadMore = styled.button`
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: ${(props) => props.theme.colors.primary};
  background: none;
  border: 0.0625rem solid ${(props) => props.theme.colors.primary};
  font-size: 0.875rem;
  cursor: pointer;
  margin: 0 auto;
  border-radius: 0.25rem;
  padding: 0.75rem;

  &:hover {
    text-decoration: underline;
  }
`;
